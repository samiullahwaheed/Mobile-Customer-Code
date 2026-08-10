# Session Expire & Cookie-Based Token Refresh — Implementation Guide

This document describes the **full implementation** of session expiry handling, automatic token refresh, and cookie management in the Loyalty Customer Flutter app. Use it as a **reference prompt** to understand, replicate, or extend this auth flow in another project.

---

## Overview

When a protected API call returns **401 Unauthorized** (e.g. message: `"Session Expired"`), the app must:

1. **NOT logout immediately**
2. Call **`POST /auth/refresh-token`** to get a new `accessToken`
3. **Retry the original failed request** with the new token
4. **Logout only if refresh fails** or the retried request still returns 401

Authentication uses a **dual strategy**:

| Mechanism | Purpose |
|-----------|---------|
| **GetStorage** | Persist `accessToken` and `refreshToken` locally |
| **PersistCookieJar** | Auto-store & send HTTP cookies (e.g. HttpOnly refresh cookie from server) |

Both `AppApi` (authenticated) and `NonAuthApi` (login/refresh) share the **same cookie jar** so cookies set during login are available during refresh.

---

## Architecture Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         App Startup (main.dart)                  │
│  WidgetsFlutterBinding → CookieService.init() → GetStorage.init() │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Login / Google Auth (NonAuthApi)              │
│  POST /auth/login or /auth/google                                │
│  → Server may Set-Cookie (refresh token)                         │
│  → CookieManager saves cookie to PersistCookieJar                │
│  → _saveAuthTokens() saves accessToken + refreshToken to storage │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│              Protected API Call (AppApi + Bearer token)            │
│  onRequest: Authorization: Bearer <accessToken>                  │
│  CookieManager: attaches stored cookies automatically            │
└─────────────────────────────────────────────────────────────────┘
                                    │
                          401 Session Expired?
                                    │
                    ┌───────────────┴───────────────┐
                    │ YES                           │ NO
                    ▼                               ▼
         ┌──────────────────────┐          Return error to caller
         │ Already retried?     │
         │ (_retriedAfterRefresh)│
         └──────────────────────┘
                    │
         ┌──────────┴──────────┐
         │ YES                 │ NO
         ▼                     ▼
      LOGOUT          ┌─────────────────────────┐
                      │ _refreshAccessToken()    │
                      │ (mutex + Completer)      │
                      └─────────────────────────┘
                                    │
                                    ▼
                      ┌─────────────────────────┐
                      │ AuthRepository.resetToken│
                      │ POST /auth/refresh-token │
                      │ + Bearer expired token   │
                      │ + body: { refreshToken } │
                      │ + cookies from jar       │
                      └─────────────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │ SUCCESS                       │ FAIL
                    ▼                               ▼
         Save new accessToken              LOGOUT
         Retry original request           (storageClear +
         with _dio.fetch()                 cookieJar.deleteAll() +
                                           Get.offAllNamed auth)
                    │
         ┌──────────┴──────────┐
         │ 200 OK              │ 401 again
         ▼                     ▼
    Return success          LOGOUT
    to original caller
```

---

## 1. Dependencies

Added to `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.9.0
  dio_cookie_manager: ^3.4.0
  cookie_jar: ^4.0.9
  get_storage: ^2.1.1
  path_provider: # for PersistCookieJar file storage
```

---

## 2. API Endpoints

**File:** `lib/const/app_api_end_point.dart`

| Constant | Path | Usage |
|----------|------|-------|
| `resetToken` | `/auth/refresh-token` | Refresh expired access token |
| `refreshToken` | `/auth/refresh-token` | Same endpoint (alias) |
| `login` | `/auth/login` | Email/password login |
| `googleAuth` | `/auth/google` | Google OAuth login |

Base URL: `{API_BASE_URL}/api/v1` (from `dart_defines/dev.json` or `--dart-define-from-file`)

---

## 3. Cookie Service

**File:** `lib/service/api_service/cookie_service.dart`

Singleton that creates a **persistent cookie jar** stored on device filesystem.

```dart
class CookieService {
  static final CookieService instance = CookieService._();
  late PersistCookieJar cookieJar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage('${dir.path}/cookies'),
    );
  }
}
```

**What it does:**
- Stores cookies across app restarts (file-based persistence)
- Respects cookie expiry (`ignoreExpires: false`)
- Shared by both `AppApi` and `NonAuthApi` via `CookieManager`

**Initialization:** Must run in `main()` **before** any API call:

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CookieService.instance.init();  // ← Required first
  await GetStorage.init();
  // ...
}
```

---

## 4. Non-Auth API Client (Login & Refresh)

**File:** `lib/service/api_service/non_auth_api.dart`

Used for endpoints that **do not require** a Bearer token in the interceptor (login, signup, refresh-token).

**Key setup:**
```dart
_dio.interceptors.add(CookieManager(CookieService.instance.cookieJar));
```

- No `Authorization` header added automatically
- Cookies from login response are saved automatically
- Cookies are sent automatically on `/auth/refresh-token`

---

## 5. Authenticated API Client (Protected Routes)

**File:** `lib/service/api_service/api.dart`

Singleton `AppApi` used for all authenticated API calls via `ApiServices`.

### 5.1 Request Interceptor

On every request:
- Sets `baseUrl`, `Content-Type`, `Accept`
- Reads `accessToken` from `GetStorageServices`
- Adds `Authorization: Bearer <token>` if token exists
- `CookieManager` attaches cookies from shared jar

### 5.2 Error Interceptor — 401 Handling

```dart
if (error.response?.statusCode == 401) {
  // 1. Prevent infinite retry loop
  if (error.requestOptions.extra['_retriedAfterRefresh'] == true) {
    await _logout();
    return handler.next(error);
  }

  // 2. Extract expired token from failed request
  final expiredToken = /* from Authorization header or storage */;

  // 3. Refresh token (with concurrency lock)
  final newToken = await _refreshAccessToken(expiredAccessToken: expiredToken);

  // 4. Retry original request OR logout
  if (newToken != null) {
    requestOptions.headers["Authorization"] = "Bearer $newToken";
    requestOptions.extra['_retriedAfterRefresh'] = true;
    final response = await _dio.fetch(requestOptions);
    return handler.resolve(response);  // Success — caller never sees 401
  }

  await _logout();
}
```

### 5.3 Concurrent Refresh Lock

When multiple API calls fail with 401 at the same time:

```dart
bool _isRefreshing = false;
Completer<String?>? _refreshCompleter;

Future<String?> _refreshAccessToken({String? expiredAccessToken}) async {
  if (_isRefreshing) {
    return _refreshCompleter?.future;  // Wait for in-progress refresh
  }
  _isRefreshing = true;
  _refreshCompleter = Completer<String?>();
  try {
    final newToken = await AuthRepository.instance.resetToken(...);
    _refreshCompleter?.complete(newToken);
    return newToken;
  } finally {
    _isRefreshing = false;
  }
}
```

Only **one** refresh API call runs; other 401s wait and reuse the same new token.

### 5.4 Logout

```dart
Future<void> _logout() async {
  await storageServices.storageClear();           // Clear tokens from GetStorage
  await CookieService.instance.cookieJar.deleteAll();  // Clear all cookies
  Get.offAllNamed(AppRoutes.instance.authScreen);      // Navigate to auth screen
}
```

---

## 6. Auth Repository — Token Refresh Logic

**File:** `lib/service/repository/auth_repository.dart`

### 6.1 Save Tokens on Login

Helper used by `login()` and `googleAuth()`:

```dart
Future<void> _saveAuthTokens(Map<String, dynamic> data) async {
  // Save access token
  if (data["accessToken"]?.isNotEmpty == true) {
    await storageServices.setToken(data["accessToken"]);
  }
  // Save refresh token (supports refreshToken or refresh_token key)
  final refresh = data["refreshToken"] ?? data["refresh_token"];
  if (refresh != null && refresh.isNotEmpty) {
    await storageServices.setRefreshToken(refresh);
  }
}
```

### 6.2 resetToken() — Refresh API Call

```dart
Future<String?> resetToken({String? expiredAccessToken}) async {
  POST /auth/refresh-token

  Headers:
    Accept: application/json
    Authorization: Bearer <expiredAccessToken>   // if available

  Body (if refreshToken in storage):
    { "refreshToken": "<stored_refresh_token>" }

  Cookies:
    Automatically sent via CookieManager (HttpOnly refresh cookie)

  On 200:
    - Parse accessToken from response.data.data.accessToken
      (also supports token, access_token keys)
    - Save new accessToken to storage
    - Save new refreshToken if returned (token rotation)
    - Return new accessToken string

  On failure:
    - Log status code + response body
    - Return null → triggers logout in interceptor
}
```

### 6.3 Flexible Response Parsing

```dart
String? _extractAccessToken(dynamic responseData) {
  final data = responseData["data"] ?? responseData;
  return data["accessToken"] ?? data["token"] ?? data["access_token"];
}
```

---

## 7. Local Storage (GetStorage)

**File:** `lib/service/api_service/get_storage_services.dart`  
**Keys:** `lib/service/api_service/app_storage_key.dart`

| Key | Storage Key String | Read/Write Methods |
|-----|-------------------|-------------------|
| Access Token | `Token` | `setToken()` / `getToken()` |
| Refresh Token | `refreshToken` | `setRefreshToken()` / `getRefreshToken()` |

**On logout (`storageClear()`):**
- Removes `Token`
- Removes `refreshToken`
- Removes `active`, `fcmToken`, `themeModeDark`

---

## 8. Files Changed / Created

| File | Action | Responsibility |
|------|--------|----------------|
| `lib/service/api_service/cookie_service.dart` | **Created** | Persistent cookie jar singleton |
| `lib/service/api_service/api.dart` | **Modified** | 401 interceptor, refresh lock, retry, logout |
| `lib/service/api_service/non_auth_api.dart` | **Modified** | CookieManager on non-auth Dio client |
| `lib/service/repository/auth_repository.dart` | **Modified** | `resetToken()`, `_saveAuthTokens()`, login token save |
| `lib/service/api_service/get_storage_services.dart` | **Modified** | `setRefreshToken()` / `getRefreshToken()` |
| `lib/main.dart` | **Modified** | `CookieService.instance.init()` at startup |
| `pubspec.yaml` | **Modified** | `dio_cookie_manager`, `cookie_jar` packages |

---

## 9. Backend Contract (Expected)

### Login Response (`POST /auth/login`)

```json
{
  "data": {
    "accessToken": "eyJhbG...",
    "refreshToken": "eyJhbG...",
    "user": { ... }
  }
}
```

Server may **also** set HttpOnly cookie:
```
Set-Cookie: refreshToken=...; HttpOnly; Path=/; ...
```

### Session Expired Response (any protected route)

```json
HTTP 401
{
  "message": "Session Expired"
}
```

### Refresh Token Response (`POST /auth/refresh-token`)

**Request** — any of:
- Cookie: `refreshToken=...` (HttpOnly)
- Body: `{ "refreshToken": "..." }`
- Header: `Authorization: Bearer <expired_access_token>`

**Response:**
```json
HTTP 200
{
  "data": {
    "accessToken": "eyJhbG...",
    "refreshToken": "eyJhbG..."   // optional — token rotation
  }
}
```

---

## 10. Debug Logs

When testing, watch console for these logs:

| Log | Meaning |
|-----|---------|
| `401 message: Session Expired` | Protected API returned 401 |
| `401 — calling resetToken before logout...` | Refresh flow started |
| `resetToken: calling /auth/refresh-token` | Refresh API called |
| `Token Refreshed` | New access token saved |
| `Retrying failed request with new token...` | Original request being retried |
| `resetToken failed: 401 {...}` | Refresh failed — will logout |
| `resetToken failed — logging out.` | No new token — logout triggered |
| `Request already retried after refresh — logging out.` | Retry also got 401 — logout |

---

## 11. Important Edge Cases

### A. Old sessions (before this implementation)
Users logged in before cookie + refreshToken storage was added will have:
- `accessToken` in storage
- **No** `refreshToken` in storage
- **No** refresh cookie in jar

→ Refresh will fail → logout. **Solution:** User must login once after app update.

### B. HTTP dev environment + Secure cookies
If API runs on `http://` and server sets `Secure` flag on cookies, mobile clients **will not store** the cookie. Ensure dev server omits `Secure` on HTTP, or use HTTPS.

### C. Infinite retry prevention
`requestOptions.extra['_retriedAfterRefresh'] = true` ensures each request is retried **at most once** after refresh.

### D. Concurrent 401s
Multiple simultaneous failed requests share one refresh call via `_isRefreshing` + `Completer`.

### E. Manual logout
`GetStorageServices.completeLogout()` clears storage but does **not** clear cookies. The 401 interceptor's `_logout()` clears **both** storage and cookies. Consider aligning manual logout to also call `cookieJar.deleteAll()`.

---

## 12. Re-implementation Prompt

Use this prompt to implement the same system in another Flutter project:

---

**PROMPT:**

Implement session expiry and automatic token refresh in a Flutter app using Dio, GetStorage, and cookie_jar.

**Requirements:**

1. Create `CookieService` singleton with `PersistCookieJar` initialized in `main()` before `GetStorage.init()`.

2. Create two Dio clients:
   - `NonAuthApi` — for login/signup/refresh; attach `CookieManager` with shared cookie jar; no Bearer header.
   - `AppApi` — for protected routes; attach same `CookieManager`; add Bearer token from storage in `onRequest`.

3. On login/google auth success, save both `accessToken` and `refreshToken` (if present in `data.refreshToken` or `data.refresh_token`) to GetStorage.

4. In `AppApi` `onError` interceptor, when `statusCode == 401`:
   - If `requestOptions.extra['_retriedAfterRefresh']` is true → clear storage, delete all cookies, navigate to auth screen.
   - Else call `resetToken()` which POSTs to `/auth/refresh-token` with:
     - `Authorization: Bearer <expired_token>`
     - Body `{ refreshToken }` if stored
     - Cookies auto-attached
   - If refresh returns new token → update storage, set `_retriedAfterRefresh = true`, retry original request with `_dio.fetch()`, resolve handler.
   - If refresh fails → logout.

5. Use mutex (`_isRefreshing` + `Completer`) so parallel 401s trigger only one refresh.

6. `resetToken()` must parse `accessToken` from `data.accessToken`, `data.token`, or `data.access_token`.

7. On logout: clear GetStorage tokens + `cookieJar.deleteAll()` + `Get.offAllNamed(authScreen)`.

8. Add debug logs at each step for troubleshooting.

**Packages:** `dio`, `dio_cookie_manager`, `cookie_jar`, `get_storage`, `path_provider`

---

## 13. Testing Checklist

- [ ] Fresh login saves `accessToken` and `refreshToken` in storage
- [ ] Login response `Set-Cookie` is persisted (check cookie jar / logs)
- [ ] Protected API works with Bearer token
- [ ] After access token expires → 401 → auto refresh → original API succeeds (no logout)
- [ ] Multiple parallel 401s → only one refresh call
- [ ] Invalid/expired refresh token → logout to auth screen
- [ ] After logout → storage empty + cookies cleared
- [ ] App restart → cookies persist → refresh still works without re-login

---

*Last updated: Implementation as of session expire + cookie auth feature in `mlitech_loyalty_and_rewards_app`.*
