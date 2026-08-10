# Google Auth Implementation Documentation

This document outlines the step-by-step implementation of Google Authentication in the project.

## 1. Dependencies

First, the necessary packages were added to `pubspec.yaml`.

```yaml
dependencies:
  firebase_core: ^4.2.1
  firebase_auth: ^6.1.3
  google_sign_in: ^7.2.0
  flutter_dotenv: ^6.0.0
```

## 2. Configuration

### A. Environment Variables

A `.env` file was used to securely store sensitive keys, specifically the `WEB_CLIENT_ID` which is required for the `serverClientId` configuration in `GoogleSignIn`.

**File:** `.env`

```
WEB_CLIENT_ID=your_web_client_id_here
```

### B. Platform Setup

- **Android:** `google-services.json` must be placed in `android/app/`.
- **iOS:** `GoogleService-Info.plist` must be placed in `ios/Runner/`.
- **Firebase Console:** The SHA-1 and SHA-256 fingerprints were added to the Firebase project settings to enable Google Sign-In.

## 3. Service Layer (`GoogleAuthService`)

A dedicated service class `GoogleAuthService` was created to handle the raw Google Sign-In logic. This keeps the authentication logic separate from the UI and state management.

**File:** `lib/service/google_auth_service/google_auth_service.dart`

**Key Responsibilities:**

- **Initialization:** Loads the `WEB_CLIENT_ID` from `.env` and initializes `GoogleSignIn`.
- **Sign In:** Calls `_googleSignIn.authenticate()` and requests specific scopes (`email`, `profile`).
- **Data Model:** Maps the `GoogleSignInAccount` to a custom `GoogleUserModel` containing `userId`, `name`, `email`, `photo`, and `accessToken`.

```dart
class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  GoogleUserModel? userData;

  Future<void> initialize() async {
    String clientId = dotenv.get('WEB_CLIENT_ID');
    await _googleSignIn.initialize(serverClientId: clientId);
  }

  Future<bool> signIn() async {
    try {
      final GoogleSignInAccount user = await _googleSignIn.authenticate();
      // ... authorization and data mapping ...
      return true;
    } catch (e, s) {
      log("Google SignIn Error", error: e, stackTrace: s);
      return false;
    }
  }
}
```

## 4. Controller Layer (`AuthController`)

The `AuthController` (using GetX) connects the Service layer to the UI.

**File:** `lib/screen/auth/auth_screen/controller/auth_controller.dart`

**Key Responsibilities:**

- **Initialization:** Calls `googleAuthService.initialize()` in `onInit()`.
- **Login Method:** Exposes `loginWithGoogle()` which calls the service's `signIn()` and handles success/failure logging.

```dart
class AuthController extends GetxController {
  final GoogleAuthService googleAuthService = GoogleAuthService();

  @override
  void onInit() {
    super.onInit();
    initializeGoogle();
  }

  Future<void> initializeGoogle() async {
    await googleAuthService.initialize();
  }

  Future<void> loginWithGoogle() async {
    final success = await googleAuthService.signIn();
    // ... success handling ...
  }
}
```

## 5. UI Integration (`AuthScreen`)

The `AuthScreen` triggers the sign-in process via user interaction.

**File:** `lib/screen/auth/auth_screen/auth_screen.dart`

**Key Responsibilities:**

- **Button:** A "Continue with Google" button.
- **Action:** Calls `controller.loginWithGoogle()` on tap.

```dart
GestureDetector(
  onTap: () {
    controller.loginWithGoogle();
  },
  child: Container(
    // ... styling ...
    child: Row(
      children: [
        AppImage(path: AssetsPath.icGoogle, width: 22),
        // ... text ...
      ],
    ),
  ),
)
```

## Summary Flow

1.  App starts -> `AuthController` initializes `GoogleAuthService`.
2.  `GoogleAuthService` reads `WEB_CLIENT_ID` from `.env`.
3.  User taps "Continue with Google" on `AuthScreen`.
4.  `AuthController` calls `GoogleAuthService.signIn()`.
5.  `GoogleSignIn` plugin handles the native Google auth flow.
6.  On success, user data is stored in `GoogleAuthService.userData`.
