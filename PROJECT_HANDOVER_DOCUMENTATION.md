# Cover Page

| Field | Value |
|-------|-------|
| **Project Name** | Miltech Customer — MLITECH Loyalty & Rewards App |
| **Package Name** | `loyalty_customer` |
| **Application ID** | `com.miltech.miltech` |
| **Version** | 1.0.0+1 |
| **Prepared For** | Miltech |
| **Prepared By** | Senior Flutter Solution Architect (Technical Documentation) |
| **Date** | June 30, 2026 |
| **Document Version** | 1.0 |

---

# Table of Contents

1. [Project Overview](#1-project-overview)
2. [Features](#2-features)
3. [Technology Stack](#3-technology-stack)
4. [Project Structure](#4-project-structure)
5. [Architecture](#5-architecture)
6. [State Management](#6-state-management)
7. [Routing](#7-routing)
8. [API Documentation](#8-api-documentation)
9. [Authentication](#9-authentication)
10. [Firebase](#10-firebase)
11. [Local Storage](#11-local-storage)
12. [Third Party Packages](#12-third-party-packages)
13. [Environment Configuration](#13-environment-configuration)
14. [Assets](#14-assets)
15. [Build Instructions](#15-build-instructions)
16. [Deployment Guide](#16-deployment-guide)
17. [Configuration Required Before Running](#17-configuration-required-before-running)
18. [Admin Panel Integration](#18-admin-panel-integration)
19. [Security](#19-security)
20. [Error Handling](#20-error-handling)
21. [Performance Optimizations](#21-performance-optimizations)
22. [Known Issues](#22-known-issues)
23. [Future Improvements](#23-future-improvements)
24. [Project Maintenance Guide](#24-project-maintenance-guide)
25. [Backup & Restore](#25-backup--restore)
26. [Delivery Checklist](#26-delivery-checklist)
27. [Changelog](#27-changelog)
28. [Contact Information](#28-contact-information)
29. [Appendix](#29-appendix)

---

# 1. Project Overview

## 1.1 Purpose of the Application

**Miltech Customer** is a cross-platform Flutter mobile application that serves as the customer-facing front end of the MLITECH Loyalty & Rewards platform. The application enables end users to discover merchants, browse promotions and rewards, manage digital loyalty wallets and gift cards, earn and redeem loyalty points, subscribe to membership plans, participate in referral programs, and receive real-time notifications for merchant-initiated redemption requests.

## 1.2 Business Goal

The application supports Miltech's loyalty ecosystem by:

- Driving customer engagement through promotions, vouchers, and tier-based rewards
- Enabling digital wallet experiences (QR/barcode cards, gift cards)
- Monetizing access via subscription packages (Stripe checkout)
- Growing the user base through referral incentives
- Providing merchants with real-time point-redemption approval workflows via Socket.IO

## 1.3 Target Users

| User Type | Description |
|-----------|-------------|
| **Registered Customers** | Users who sign up, verify via OTP, and maintain an active subscription |
| **Subscribed Members** | Customers with `subscription: active` who access the full app shell |
| **Referred Users** | New sign-ups who enter a referral ID during registration |
| **Sales Rep Assisted Users** | Users onboarded via sales representative token validation |

## 1.4 Main Workflow

```
App Launch (Splash)
        │
        ▼
   Token exists?
    │         │
   No          Yes
    │         │
    ▼         ▼
Onboarding   Fetch Profile
    │         │
    ▼         ▼
Auth Flow    Location set?
(Sign In/Up)   │      │
    │         No      Yes
    ▼          │       │
Location       ▼       ▼
    │      Location  Waiting list?
    ▼      Screen       │      │
Subscription          Yes      No
/ Waiting             │        │
    │                 ▼        ▼
    ▼            Waiting    Subscription
Navigation         Screen      active?
(Main Shell)                    │    │
                               No    Yes
                                │    │
                                ▼    ▼
                          Subscription  Main Navigation
                          Screen        (Home | Merchants | Wallet | Profile)
```

## 1.5 High-Level Summary

| Aspect | Detail |
|--------|--------|
| **Platform** | Android & iOS (primary); desktop/web scaffold present but not production-targeted |
| **Framework** | Flutter 3.41.9 (FVM-managed) |
| **State Management** | GetX |
| **Backend** | Node.js REST API (`/api/v1`) + Socket.IO |
| **Auth** | Email/password, phone OTP, Google Sign-In, JWT Bearer + refresh token + HTTP cookies |
| **Payments** | Stripe checkout via in-app WebView |
| **Push** | Firebase Cloud Messaging + local notifications |
| **Maps** | Google Maps Flutter |

---

# 2. Features

## 2.1 Splash & Onboarding

| Feature | Description |
|---------|-------------|
| Splash Screen | Branded launch screen with animation; routes based on token and profile state |
| Onboarding | Multi-page introduction for first-time users (`on_boarding_screen/`) |
| First-Time Detection | `isFirstTime` flag in GetStorage controls onboarding vs. auth routing |

## 2.2 Authentication

| Feature | Description |
|---------|-------------|
| Sign In | Email/phone identifier + password login |
| Sign Up | Registration with name, phone, email, country, city, password, optional referral ID |
| OTP Verification | Phone OTP verification during registration |
| Forgot Password | Identifier-based password reset with OTP and new password flow |
| Google Sign-In | OAuth via `google_sign_in`; ID token sent to backend `/auth/google` |
| Referral Sign-Up | Dedicated screens for referral ID entry and referral-based registration |
| Create Password | Password creation step during multi-step registration |
| Auth Gateway | Combined auth screen with Google and email/phone entry points |
| Waiting Screen | Shown when user is on admin waiting list (`isUserWaiting`) |
| Account Deletion | Password-confirmed account deletion via API |

## 2.3 Location & Preferences

| Feature | Description |
|---------|-------------|
| Location Selection | Country and city selection during onboarding |
| Geolocation | `geolocator` + `geocoding` for coordinates and address resolution |
| User Preferences | Interest/category preferences screen post-registration |
| Profile Location | Latitude/longitude stored on user profile for map features |

## 2.4 Home

| Feature | Description |
|---------|-------------|
| Dashboard | Carousel, popular merchants, promotions summary |
| Nearby Merchants | Map preview and list of merchants near user location |
| Subscription Summary | Counts for wallet items, points, referrals |
| Notifications Badge | Real-time notification indicator via Socket.IO |
| Specific Services | Category-based promotion browsing |
| Recently Viewed | Track and display recently viewed promotions |

## 2.5 Merchants

| Feature | Description |
|---------|-------------|
| Merchant List | Paginated, searchable merchant directory |
| Filters | Search by term, address, service, radius, favorites |
| Favorite Merchants | Add merchants to favorites |
| Merchant Details | Full merchant profile, tiers, promotions, subscribe actions |
| Merchant Rating | Post-redemption merchant rating with comment |
| Tier System | View merchant loyalty tiers and point thresholds |

## 2.6 Maps

| Feature | Description |
|---------|-------------|
| Home Map Preview | Lite-mode Google Map with merchant markers |
| Full Map Screen | Interactive map with distance calculations |
| Merchant Selection | Tap marker → bottom sheet → navigate to details |
| Location Fallback | Default location (California) when permission denied |

## 2.7 Wallet & Loyalty Cards

| Feature | Description |
|---------|-------------|
| Digital Wallet | List of digital loyalty cards |
| Add to Wallet | Add promotions as digital cards |
| QR/Barcode Display | Syncfusion barcodes for card redemption codes |
| Gift Cards | My gift cards and gift card list screens |
| Vouchers | Voucher management screen |
| Transaction History | Points transaction history |

## 2.8 Promotions & Rewards

| Feature | Description |
|---------|-------------|
| Promo & Rewards List | Combined promotions and rewards catalog |
| Single Promo Detail | Individual promotion/reward detail view |
| Add Promotion | Add promotion to wallet from detail screens |
| Pagination | Paginated promotion API (`limit`, `page`) |

## 2.9 Points

| Feature | Description |
|---------|-------------|
| My Points | View accumulated loyalty points |
| Point Redemption | Real-time merchant-initiated redemption approval dialog |
| Redemption Accept/Reject | POST to `/sell/promotion/{accept\|reject}` |

## 2.10 Subscription

| Feature | Description |
|---------|-------------|
| Package List | Active subscription packages from backend |
| Stripe Checkout | WebView-based Stripe payment URL |
| Sales Rep Flow | Sales representative token validation |
| Subscription History | Per-user subscription history |
| Subscription Gate | App access gated on `subscription == "active"` |

## 2.11 Refer a Friend

| Feature | Description |
|---------|-------------|
| Referral Link/Share | Refer friends screen with sharing capability |
| Referral Summary | View referral stats and rewards |
| Referral List | List of referred users |
| Referral Verification | Validate referral ID during sign-up |

## 2.12 Notifications

| Feature | Description |
|---------|-------------|
| In-App Notifications | Paginated notification list |
| Push Notifications | FCM foreground, background, and terminated handling |
| Local Notifications | `flutter_local_notifications` with image support |
| Mark as Read | PATCH `/notifications/read` |
| Notification Settings | Granular toggles (email, SMS, push, referral, subscription) |
| Real-Time Push | Socket event `newNotification` inserts into live list |

## 2.13 Profile & Settings

| Feature | Description |
|---------|-------------|
| Profile View | User profile with photo, location, subscription status |
| Edit Profile | Name, photo (multipart), location, preferences, FCM token |
| Change Password | Current + new + confirm password |
| Contact Us | Support form submission |
| Theme | Light/dark mode with persistence |
| Terms & Privacy | HTML content from disclaimers API |
| Logout | Clears storage and navigates to auth |

## 2.14 Real-Time (Socket.IO)

| Feature | Description |
|---------|-------------|
| Redemption Popup | Event `getApplyRequest::{userId}` triggers approval dialog |
| Live Notifications | Event `newNotification` updates notification list |
| Auth Token | Socket connects with JWT in `auth.token` |

## 2.15 Legal & Compliance

| Feature | Description |
|---------|-------------|
| Terms of Service | Dynamic HTML from `/disclaimers/{endpoint}` |
| Privacy Policy | Dynamic HTML from disclaimers API |
| Confirm Screen | Confirmation/acknowledgment screen |

---

# 3. Technology Stack

## 3.1 Core Framework

| Component | Version / Detail |
|-----------|------------------|
| **Flutter** | 3.41.9 (`.fvmrc`, `.fvm/release`) |
| **Dart SDK** | `^3.8.1` (`pubspec.yaml`) |
| **Package Name** | `loyalty_customer` |
| **App Version** | 1.0.0+1 |

## 3.2 State Management

| Component | Detail |
|-----------|--------|
| **GetX** | `^4.7.3` — state, routing, dependency injection |

## 3.3 Architecture Pattern

Feature-based layered architecture with Repository pattern:

- **Presentation:** Screens + Controllers (GetX)
- **Data:** Repositories → ApiServices → Dio HTTP clients
- **Not strict Clean Architecture** — no separate domain/use-case layer

## 3.4 HTTP Client

| Component | Detail |
|-----------|--------|
| **Dio** | `^5.9.0` |
| **dio_cookie_manager** | `^3.4.0` |
| **cookie_jar** | `^4.0.9` |
| **pretty_dio_logger** | `^1.4.0` (debug only) |

## 3.5 Database

| Component | Status |
|-----------|--------|
| Local Database (SQLite/Hive) | **Not used** |
| Remote Database | Node.js backend (not in this repo) |

## 3.6 Firebase Services

| Service | Used | Package |
|---------|------|---------|
| Firebase Core | ✅ Yes | `firebase_core: ^4.2.1` |
| Firebase Messaging (FCM) | ✅ Yes | `firebase_messaging: ^16.1.0` |
| Firebase Auth | ❌ Listed in pubspec, **not used in code** | `firebase_auth: ^6.1.3` |
| Firestore | ❌ No | — |
| Realtime Database | ❌ No | — |
| Analytics | ❌ Disabled (`IS_ANALYTICS_ENABLED: false` in plist) | — |
| Crashlytics | ❌ No | — |
| Storage | ❌ No (bucket configured but unused) | — |
| Remote Config | ❌ No | — |
| Dynamic Links | ❌ No | — |

**Firebase Project:** `miltech-c3007`

## 3.7 Push Notifications

| Component | Detail |
|-----------|--------|
| FCM | Token registration, foreground/background handlers |
| flutter_local_notifications | `^18.0.0` — local display with image download |

## 3.8 Maps

| Component | Detail |
|-----------|--------|
| google_maps_flutter | `^2.14.0` |
| geolocator | `^14.0.2` |
| geocoding | `^4.0.0` |

## 3.9 Payments

| Component | Detail |
|-----------|--------|
| Stripe | Backend-generated checkout URL opened in `webview_flutter` |
| In-App Purchases | **Not used** |

## 3.10 Storage

| Component | Detail |
|-----------|--------|
| get_storage | `^2.1.1` — tokens, theme, preferences |
| PersistCookieJar | File-based HTTP cookie persistence |
| flutter_cache_manager | Image caching |
| Secure Storage (flutter_secure_storage) | **Not used** |

## 3.11 Image Libraries

| Package | Purpose |
|---------|---------|
| cached_network_image | Remote image caching |
| flutter_svg | SVG icon rendering |
| image_picker | Profile photo selection |
| shimmer_animation / skeletonizer | Loading placeholders |

## 3.12 Animations & UI

| Package | Purpose |
|---------|---------|
| smooth_page_indicator | Onboarding page dots |
| device_preview | Debug-only responsive preview |
| flutter_html | Terms/privacy HTML rendering |
| syncfusion_flutter_barcodes | QR/barcode generation |

## 3.13 Localization

| Component | Status |
|-----------|--------|
| flutter_localizations / intl / ARB files | **Not implemented** |
| `intl` | Used indirectly via `date_formet.dart` for date formatting only |
| App Language | English (UI strings hardcoded; some error messages in Bengali) |

## 3.14 Real-Time

| Package | Purpose |
|---------|---------|
| socket_io_client | `^3.1.3` — redemption and notification events |

## 3.15 SDK Requirements

| Platform | Requirement |
|----------|-------------|
| Android minSdk | Flutter default (`flutter.minSdkVersion`) |
| Android compileSdk | Flutter default |
| Android Java | 17 |
| iOS | Xcode with CocoaPods; Google Maps SDK |
| FVM | Recommended — `.fvmrc` pins Flutter 3.41.9 |

## 3.16 Operating System Requirements

| OS | Development |
|----|-------------|
| macOS | Required for iOS builds |
| Windows/Linux | Android builds supported |
| CI | `macos-latest` (GitHub Actions) |

---

# 4. Project Structure

```
mlitech_loyalty_and_rewards_app/
├── lib/
│   ├── main.dart                    # App entry: cookies, env, Firebase, FCM, socket
│   ├── firebase_options.dart        # FlutterFire-generated config
│   ├── screen/                      # Feature screens (UI + controllers + models)
│   ├── service/                     # API, repositories, FCM, socket, maps, auth
│   ├── routes/                      # GetX routes and bindings
│   ├── widget/                      # Shared reusable UI components
│   ├── model/                       # Shared data models
│   ├── const/                       # Theme, colors, API endpoints, assets paths
│   └── utils/                       # Helpers (sizing, URL launcher, formatters)
├── assets/
│   ├── images/                      # WebP raster images
│   ├── icon/                        # PNG/SVG icons
│   └── fonts/                       # Outfit font family
├── dart_defines/                    # Environment JSON (API URLs)
├── android/                         # Android native config
├── ios/                             # iOS native config
├── test/                            # Widget tests
├── .env                             # WEB_CLIENT_ID (gitignored)
├── .fvmrc                           # FVM Flutter version
├── pubspec.yaml                     # Dependencies and assets
└── docs/                            # Feature documentation (MD/TXT)
```

## 4.1 Folder Responsibilities

### `lib/main.dart`

Application bootstrap sequence: `CookieService` → `.env` → `GetStorage` → Firebase/FCM → `SocketService` → `MyApp`.

### `lib/screen/`

Feature modules following the pattern:

```
screen/<feature>/
├── <feature>_screen.dart       # UI
├── controller/                 # GetX controller
├── model/                      # Feature-specific models (optional)
└── widgets/                    # Feature-specific widgets, shimmers (optional)
```

**Key screen folders:**

| Folder | Responsibility |
|--------|------------------|
| `splash_screen/` | Initial routing logic |
| `on_boarding_screen/` | First-run onboarding |
| `auth/` | All authentication flows |
| `app_navigation_screen/` | Bottom-nav shell (Home, Merchants, Wallet, Profile) |
| `home_screen/` | Dashboard, carousel, nearby merchants |
| `merchants_screen/` | Merchant directory |
| `show_details_screen/` | Merchant detail, tiers, promotions |
| `map_details_screen/` | Full-screen interactive map |
| `my_wallet_screen/` | Digital loyalty cards |
| `my_gift_card_screen/` | Gift card management |
| `gift_card_list_screen/` | Gift card listing |
| `promo_and_reward_screen/` | Promotions and rewards |
| `my_point_screen/` | Points overview |
| `transaction_history_screen/` | Points transaction log |
| `voucher_screen/` | Vouchers |
| `subscription_screen/` | Packages, Stripe WebView |
| `reffer_friends/`, `reffer_friend_*` | Referral program |
| `notification_screen/` | In-app notifications |
| `profile_section/` | Profile, settings, password, contact |
| `preferences_screen/` | User interest preferences |
| `terms_screen/`, `privicy_screen/` | Legal content |
| `confirm_screen/` | Confirmation UI |

### `lib/service/`

| Folder/File | Responsibility |
|-------------|----------------|
| `api_service/api.dart` | Authenticated Dio client with 401 refresh interceptor |
| `api_service/non_auth_api.dart` | Unauthenticated Dio client (login, refresh) |
| `api_service/api_services.dart` | HTTP verb wrappers (GET/POST/PATCH/PUT/DELETE) |
| `api_service/cookie_service.dart` | Persistent cookie jar |
| `api_service/get_storage_services.dart` | Local key-value storage |
| `api_service/app_storage_key.dart` | Storage key constants |
| `repository/` | Data access layer (auth, get, post, patch, delete) |
| `push_notification/` | FCM + local notification services |
| `socket_service.dart/` | Socket.IO client singleton |
| `google_auth_service/` | Google Sign-In wrapper |
| `map/map_service.dart` | Map initialization helpers |

### `lib/routes/`

| File | Responsibility |
|------|----------------|
| `app_routes.dart` | Route path constants |
| `app_routes_file.dart` | `GetPage` definitions with bindings |
| `bindings/` | GetX dependency injection per route group |

### `lib/widget/`

Shared UI: buttons, inputs, images, snackbars, dropdowns, location fields, formatters, shimmer placeholders.

### `lib/const/`

| File | Responsibility |
|------|----------------|
| `app_api_end_point.dart` | Base URL resolution + all API path constants |
| `app_const.dart` | Font family, Maps API key constant |
| `app_theme.dart` / `app_theme_color.dart` | Light/dark themes |
| `assets_icons_path.dart` | Asset path constants |

### `lib/model/`

Shared models used across features (e.g., `merchant_tiar_model.dart`).

### `lib/utils/`

App sizing, URL launcher, date formatters for promotions.

### `assets/`

Raster images (WebP), PNG icons, SVG, Outfit font files.

### `dart_defines/`

Compile-time environment injection files (`dev.json`, `staging.json`, `prod.local.json`).

### `android/` / `ios/`

Native configuration: Firebase, Google Maps API keys, permissions, signing.

---

# 5. Architecture

## 5.1 Architectural Style

The application uses a **Feature-Module + Repository** architecture orchestrated by **GetX**. It is inspired by layered design but does not implement a formal Clean Architecture with separate domain entities and use cases.

## 5.2 Layer Breakdown

### Presentation Layer

- **Screens:** Flutter `StatelessWidget` / `StatefulWidget`
- **Controllers:** `GetxController` with `Rx` observables, `GetBuilder`, `Obx`
- **Widgets:** Reusable components and feature-specific shimmer loaders

### Data Layer

- **Repositories:** `AuthRepository`, `GetRepository`, `PostRepository`, `PatchRepository`, `DeleteRepository`
- **ApiServices:** Centralized HTTP method wrappers
- **HTTP Clients:** `AppApi` (authenticated) and `NonAuthApi` (public)

### Infrastructure Layer

- Firebase (FCM)
- Socket.IO
- Google Maps
- Google Sign-In
- GetStorage + Cookie Jar

## 5.3 Dependency Injection

GetX bindings inject controllers:

| Binding | Scope |
|---------|-------|
| `SplashScreenBinding` | Splash controller |
| `AuthBinding` | Auth flow controllers |
| `NavigationScreenBinding` | Navigation shell |
| `AppBinding` | Majority of app controllers (lazy) |

`SocketService` is registered permanently in `main.dart` via `Get.put(SocketService.instance, permanent: true)`.

## 5.4 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        PRESENTATION                          │
│   Screen (UI)  ←→  Controller (GetX)  ←→  Obx/GetBuilder     │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      REPOSITORY LAYER                        │
│  AuthRepository | GetRepository | PostRepository | etc.     │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      SERVICE LAYER                           │
│              ApiServices (GET/POST/PATCH/DELETE)             │
└────────────────────────────┬────────────────────────────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────────┐
        │  AppApi  │  │NonAuthApi│  │SocketService │
        │  (Dio)   │  │  (Dio)   │  │ (Socket.IO)  │
        └────┬─────┘  └────┬─────┘  └──────┬───────┘
             │             │               │
             └─────────────┼───────────────┘
                           ▼
              ┌────────────────────────────┐
              │   Node.js Backend API        │
              │   {API_BASE_URL}/api/v1      │
              └────────────────────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
         Firebase      Google Maps    Stripe
         (FCM)         API           (WebView)
```

## 5.5 Controller Flow Example (Login)

```
SignInScreen
    → SignInController.login()
        → AuthRepository.login(identifier, password, device)
            → NonAuthApi.post(/auth/login)
                → _saveAuthTokens() → GetStorage
                → CookieManager saves Set-Cookie
        → Navigate based on profile/subscription state
```

## 5.6 Startup Sequence

```
main()
  ├── WidgetsFlutterBinding.ensureInitialized()
  ├── CookieService.instance.init()
  ├── dotenv.load(".env")
  ├── GetStorage.init()
  ├── FirebaseMessaging.onBackgroundMessage(handler)
  ├── Firebase.initializeApp()
  ├── NotificationService.initLocalNotification()
  ├── FCMService.initialize()
  ├── DeviceInfoService().init()
  ├── Get.put(SocketService.instance, permanent: true)
  └── runApp(MyApp) [wrapped in DevicePreview for debug]
```

---

# 6. State Management

## 6.1 GetX Controllers

Each feature has a dedicated `GetxController` responsible for:

- Holding reactive state (`Rx`, `RxList`, `Rxn`)
- Calling repositories
- Navigation (`Get.toNamed`, `Get.offAllNamed`)
- Showing snackbars/dialogs

**Example controllers:**

| Controller | Feature |
|------------|---------|
| `SplashController` | Splash routing |
| `AuthController` | Google auth |
| `SignInController` | Email/password login |
| `HomeController` | Dashboard data |
| `NavigationScreenController` | Bottom nav + socket events |
| `MySubController` | Subscription + Stripe WebView |
| `ProfileController` | User profile |

## 6.2 Bindings

Bindings register controllers lazily when routes are opened:

```dart
class AppBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ProfileController());
    // ... 20+ controllers
  }
}
```

## 6.3 Reactive Variables

| Pattern | Usage |
|---------|-------|
| `.obs` | Primitive and object observables |
| `RxList<T>` | Observable lists (merchants, packages) |
| `Rxn<T>` | Nullable observables (profile, selected merchant) |
| `Obx(() => ...)` | Rebuild widget on observable change |
| `GetBuilder<T>` | Rebuild on `update()` call |

## 6.4 Lifecycle

| Method | When |
|--------|------|
| `onInit()` | Controller created — fetch data, init socket |
| `onReady()` | After first frame (rarely used) |
| `onClose()` | Controller disposed — cleanup text controllers |

## 6.5 Navigation

GetX named routing via `GetMaterialApp`:

```dart
Get.toNamed(AppRoutes.instance.showDetailsScreen, arguments: merchantId);
Get.offAllNamed(AppRoutes.instance.navigationScreen);
```

## 6.6 Dependency Injection Patterns

| Pattern | Example |
|---------|---------|
| `Get.lazyPut()` | Deferred controller creation in bindings |
| `Get.put()` | Immediate/permanent registration (`SocketService`) |
| `Get.find<T>()` | Retrieve registered controller |
| `Get.isRegistered<T>()` | Check before find |

---

# 7. Routing

## 7.1 Route Registry

All routes are defined in `lib/routes/app_routes.dart` and registered in `lib/routes/app_routes_file.dart`.

| Route Path | Screen | Binding | Auth Required |
|------------|--------|---------|---------------|
| `/` | SplashScreen | SplashScreenBinding | No |
| `/onboarding-screen` | OnBoardingScreen | — | No |
| `/auth-screen` | AuthScreen | AuthBinding | No |
| `/sign-in-screen` | SignInScreen | AppBinding | No |
| `/sign-up-screen` | SignUpScreen | AuthBinding | No |
| `/create-your-password-screen` | CreatePasswordScreen | AuthBinding | No |
| `/create-new-password-screen` | CreateNewPasswordScreen | AuthBinding | No |
| `/verify-otp-screen` | VerifyOtpScreen | AuthBinding | No |
| `/forget-pass-screen` | ForgetPassScreen | AuthBinding | No |
| `/forgetpass-verify-otp-screen` | ForgetPassVerifyOtpScreen | AuthBinding | No |
| `/signup-with-reffral-id-screen` | SignUpWithReffaleIDScreen | — | No |
| `/enter-reffarl-id-screen` | EnterReffalIdScreen | — | No |
| `/location-screen` | LocationScreen | AuthBinding | Partial |
| `/waiting-screen` | WaitningScreen | AuthBinding | Yes |
| `/preferences-screen` | PreferencesScreen | AppBinding | Yes |
| `/navigation-screen` | NavigationScreen | NavigationScreenBinding | Yes |
| `/home-screen` | HomeScreen | — | Yes |
| `/merchant-screen` | MerchantsScreen | — | Yes |
| `/my-wallet-screen` | MyWalletScreen | — | Yes |
| `/show-details-screen` | ShowDetailsScreen | AppBinding | Yes |
| `/map-details-screen` | MapDetailsScreen | AppBinding | Yes |
| `/my-gift-card-screen` | MyGiftCardScreen | AppBinding | Yes |
| `/gift-card-list-screen` | GiftCardListScreen | AppBinding | Yes |
| `/promo-reward-screen` | PromoAndRewardScreen | AppBinding | Yes |
| `/single-promo-and-reward-screen` | SinglePromoAndRewardScreen | AppBinding | Yes |
| `/my-point-screen` | MyPointScreen | — | Yes |
| `/recently-view-screen` | RecentlyViewScreen | AppBinding | Yes |
| `/transaction-history-screen` | TransactionHistoryScreen | AppBinding | Yes |
| `/voucher-screen` | VoucherScreen | AppBinding | Yes |
| `/notification-screen` | NotificationScreen | AppBinding | Yes |
| `/notification-settings-screen` | NotificationSettingScreen | AppBinding | Yes |
| `/profile-screen` | ProfileScreen | — | Yes |
| `/change-profile-screen` | ChnageProfileScreen | AppBinding | Yes |
| `/change-pass-screen` | ChangePassScreen | AppBinding | Yes |
| `/contact-us-screen` | ContactUsScreen | — | Yes |
| `/my-sub-screen` | MySubScreen | AppBinding | Yes |
| `/stripe-checkout-webview` | StripeCheckoutWebViewScreen | AppBinding | Yes |
| `/reffer-friend-screen` | RefferFriendsScreen | — | Yes |
| `/reffer-friend-main-screen` | RefferFriendMainScreen | — | Yes |
| `/reffer-friend-list-screen` | RefferFriendListScreen | AppBinding | Yes |
| `/specific-service-screen` | SpecificServiceScreen | AppBinding | Yes |
| `/terms-screen` | TermsScreen | — | Yes |
| `/privicy-screen` | PrivicyScreen | AppBinding | Yes |
| `/confirm-screen` | ConfirmScreen | — | No |

## 7.2 Intended Initial Route

**Production intended route:** `/` (SplashScreen)

> **⚠️ Development Override:** `lib/screen/my_app.dart` currently sets `initialRoute: AppRoutes.instance.confirmScreen`. This must be reverted to `AppRoutes.instance.initial` before release.

## 7.3 Navigation Flow

### Unauthenticated

```
Splash → Onboarding (first time) → Auth → Sign In/Up → OTP → Location → Subscription
```

### Authenticated (Active Subscription)

```
Splash → NavigationScreen (Home tab default)
```

### Authenticated (No Subscription)

```
Splash → MySubScreen → Stripe WebView → NavigationScreen
```

### Authenticated (Waiting List)

```
Splash → WaitingScreen
```

### Authenticated (Missing Location)

```
Splash → LocationScreen
```

## 7.4 Protected Routes

Routes requiring a valid JWT are enforced **server-side** (401 responses). Client-side, `SplashController` gates entry to the main shell. The `AppApi` interceptor handles session expiry globally.

## 7.5 Bottom Navigation Shell

`NavigationScreen` uses `IndexedStack` with four tabs:

| Tab | Enum | Screen |
|-----|------|--------|
| Home | `NavigationTab.home` | HomeScreen |
| Merchants | `NavigationTab.merchants` | MerchantsScreen |
| Wallet | `NavigationTab.wallet` | MyWalletScreen |
| Profile | `NavigationTab.profile` | ProfileScreen |

---

# 8. API Documentation

## 8.1 Base Configuration

| Setting | Value |
|---------|-------|
| **Base URL** | `{API_BASE_URL}/api/v1` |
| **Domain (images)** | `{API_BASE_URL}` (no `/api/v1`) |
| **Socket URL** | `{SOCKET_BASE_URL}` or `{API_BASE_URL}` |
| **Content-Type** | `application/json` |
| **Accept** | `application/json` |
| **Auth Header** | `Authorization: Bearer {accessToken}` |
| **Connect Timeout** | 60 seconds |
| **Send Timeout** | 60 seconds |
| **Receive Timeout** | 60 seconds |
| **Follow Redirects** | `false` |

## 8.2 API Endpoint Reference

| Endpoint | Method | Auth | Description | Request Body / Params | Response |
|----------|--------|------|-------------|----------------------|----------|
| `/auth/login` | POST | No | Email/phone login | `{identifier, password, device}` | `{data: {accessToken, refreshToken, user}}` |
| `/auth/google` | POST | No | Google OAuth | `{idToken}` | `{data: {accessToken, subscription, ...}}` |
| `/auth/refresh-token` | POST | Partial | Refresh access token | `{refreshToken}` + Bearer + cookies | `{data: {accessToken}}` |
| `/auth/verify-otp` | POST | No | Verify phone OTP | `{identifier, oneTimeCode}` | `{data: {...}}` or `{data: {resetToken}}` |
| `/auth/resend-otp` | POST | No | Resend OTP | `{identifier}` | Success message |
| `/auth/forgot-password` | POST | No | Initiate reset | `{identifier}` | Success message |
| `/auth/reset-password` | POST | Token | Reset password | `{newPassword, confirmPassword}` | Success |
| `/auth/change-password` | POST | Yes | Change password | `{currentPassword, newPassword, confirmPassword}` | Success |
| `/auth/user-delete-account` | DELETE | Yes | Delete account | `{password}` | Success |
| `/user` | POST | No | Sign up | `{firstName, phone, email, country, city, password, role, referredId?}` | Success |
| `/user` | PATCH | Yes | Update profile | Multipart: name, location, photo, fcmToken, notificationSettings, prefreances | Success |
| `/user/profile` | GET | Yes | Get profile | — | `{data: ProfileModelData}` |
| `/user/summary-counts` | GET | Yes | Dashboard summary | — | `{data: UserSummaryData}` |
| `/contact` | POST | Yes | Contact us | `{name, email, phone, address, message, subject}` | Success |
| `/promo-merchant/popular-merchants` | GET | Yes | Popular merchants | — | `{data: [merchants]}` |
| `/promo-merchant/merchants/{id}` | GET | Yes | Merchant details | Path: merchantId | `{data: MerchantDetails}` |
| `/promo-merchant/users/tier` | GET | Yes | User tier for merchant | Body: `{merchantId}` | `{data: tier}` |
| `/promo-merchant/user-combine-promotions` | GET | Yes | Promotions list | Query: `limit`, `page` | `{data: [promotions]}` |
| `/promo-merchant/by-category` | GET | Yes | Category promotions | Query: `categoryName` | `{data: [promotions]}` |
| `/admin/merchants` | GET | Yes | All merchants | Query: limit, page, searchTerm, address, service, radius, favorite | `{data: [merchants]}` |
| `/admin/merchants/nearby` | GET | Yes | Nearby merchants | Query: optional radius | `{data: [merchants]}` |
| `/add-promotion/create-digital-card` | POST | Yes | Create wallet card | `{merchantId}` | `{data: {cardId}}` |
| `/add-promotion/add` | POST | Yes | Add promotion to wallet | `{promotionId}` | Success |
| `/add-promotion/my-digital-cards` | GET | Yes | Digital cards | Query: limit, page, searchTerm | `{data: {digitalCards}}` |
| `/add-promotion/my-promotions` | GET | Yes | My gift cards | Query: limit, page, searchTerm | `{data: {promotions}}` |
| `/recent-viewed-promotions` | GET | Yes | Recently viewed | — | `{data: [promotions]}` |
| `/recent-viewed-promotions` | POST | Yes | Track view | `{promotionId}` | Success |
| `/sell/points-history` | GET | Yes | Transaction history | — | `{data: [transactions]}` |
| `/sell/pending-checkouts` | GET | Yes | Pending redemptions | — | `{data: SellRequist}` |
| `/sell/promotion/{accept\|reject}` | POST | Yes | Approve/reject redemption | `{digitalCardCode, userId, sellId}` | Success |
| `/notifications` | GET | Yes | Notification list | Query: limit, page | `{data: {notifications}}` |
| `/notifications/read` | PATCH | Yes | Mark all read | — | `{data: true}` |
| `/package/active-packages` | GET | Yes | Subscription packages | — | `{data: [packages]}` |
| `/subscription/create` | POST | Yes | Stripe checkout | `{packageId}` | `{success, data: {url}}` |
| `/subscription/{userId}` | GET | Yes | Subscription history | Path: userId | `{data: [history]}` |
| `/rating/give-rating` | POST | Yes | Rate merchant | `{digitalCardId, promotionId, merchantId, rating, comment}` | Success |
| `/favorite/add` | POST | Yes | Favorite merchant | `{merchantId}` | Success |
| `/referrals/mine` | GET | Yes | Referral summary | — | `{data: ReferralSummary}` |
| `/referrals/verify-referral` | POST | No | Validate referral | `{referralId}` | Success |
| `/sales-rep` | POST | Yes | Sales rep assignment | `{packageId}` | Success |
| `/sales-rep/validate` | POST | Yes | Validate sales token | `{token}` | Success |
| `/disclaimers/{endpoint}` | GET | Yes/No | Legal content | Path: endpoint key | `{data: {content}}` |
| `/tier/merchant/{merchantId}` | GET | Yes | Tier list | Path: merchantId | `{data: [tiers]}` |

## 8.3 Error Handling

| HTTP Code | Client Behavior |
|-----------|-----------------|
| **400** | Show `message` from response via `AppSnackBar` |
| **401** | Attempt token refresh → retry once → logout on failure |
| **Network (SocketException)** | Snackbar: "Check Your Internet Connection" |
| **Timeout** | Logged; returns `null` from ApiServices |
| **Other** | Logged via `errorLog()`; returns `null` |

## 8.4 Retry Logic

- **401 retry:** Automatic via `AppApi` interceptor with `_retriedAfterRefresh` flag (max 1 retry per request)
- **Concurrent 401:** Mutex (`_isRefreshing` + `Completer`) ensures single refresh call
- **General API:** No automatic retry for network failures

## 8.5 Interceptors

| Client | Interceptors |
|--------|-------------|
| `AppApi` | CookieManager, Auth header injection, 401 refresh, PrettyDioLogger (debug) |
| `NonAuthApi` | CookieManager, PrettyDioLogger (debug) |

## 8.6 Token Handling

- Access token stored in GetStorage key `Token`
- Refresh token stored in key `refreshToken`
- Bearer token attached in `onRequest` interceptor
- HttpOnly cookies persisted via `PersistCookieJar`

## 8.7 Refresh Token Flow

See Section 9 for detailed flow. Summary:

```
401 → POST /auth/refresh-token (Bearer expired + body refreshToken + cookies)
    → Save new accessToken
    → Retry original request
    → On failure: clear storage + cookies + navigate to /auth-screen
```

---

# 9. Authentication

## 9.1 Login Flow (Email/Password)

```
1. User enters identifier + password on SignInScreen
2. SignInController calls AuthRepository.login()
3. POST /auth/login with {identifier, password, device}
4. Server returns accessToken + refreshToken (+ may Set-Cookie)
5. _saveAuthTokens() persists to GetStorage
6. CookieManager saves HTTP cookies to PersistCookieJar
7. Navigate based on profile/subscription state
```

## 9.2 Google Sign-In Flow

```
1. AuthController.initializeGoogle() loads WEB_CLIENT_ID from .env
2. User taps "Continue with Google"
3. GoogleAuthService.signIn() → obtains idToken
4. AuthRepository.googleAuth(idToken) → POST /auth/google
5. Backend returns tokens + subscription status
6. Route:
   - subscription "active" → NavigationScreen
   - new user → LocationScreen
   - inactive → MySubScreen
```

## 9.3 Token Storage

| Token | Storage Key | Method |
|-------|-------------|--------|
| Access Token | `Token` | `setToken()` / `getToken()` |
| Refresh Token | `refreshToken` | `setRefreshToken()` / `getRefreshToken()` |
| FCM Token | `fcmToken` | `setFCMtoken()` / `getFCMtoken()` |

**Storage engine:** `get_storage` (plain text JSON file on device — not encrypted).

## 9.4 Secure Storage

`flutter_secure_storage` is **not used**. Tokens are stored in GetStorage without platform keychain/keystore encryption.

## 9.5 Session Handling

- Sessions are JWT-based with server-side expiry
- Client detects expiry via HTTP 401 `"Session Expired"`
- Automatic silent refresh before forced logout

## 9.6 Logout

| Method | Clears Storage | Clears Cookies | Navigation |
|--------|---------------|----------------|------------|
| `AppApi._logout()` (401 failure) | ✅ | ✅ | `Get.offAllNamed(authScreen)` |
| `GetStorageServices.completeLogout()` (manual) | ✅ | ❌ | `Get.offAllNamed(authScreen)` |

> **Note:** Manual logout should also call `CookieService.instance.cookieJar.deleteAll()` for consistency.

## 9.7 Cookie Handling

- Shared `PersistCookieJar` at `{appDocuments}/cookies`
- Both `AppApi` and `NonAuthApi` use `CookieManager`
- Cookies survive app restarts
- Cleared on automatic 401 logout

## 9.8 Authorization Flow

```
Request → onRequest interceptor
    → Read token from GetStorage
    → If non-empty: Authorization: Bearer {token}
    → CookieManager attaches stored cookies
    → Server validates JWT
    → 401 → refresh flow (Section 8.7)
```

## 9.9 Sign-Up & OTP Flow

```
SignUp → POST /user → VerifyOtpScreen → POST /auth/verify-otp
    → LocationScreen → PreferencesScreen → SubscriptionScreen
```

## 9.10 Forgot Password Flow

```
ForgetPassScreen → POST /auth/forgot-password
    → ForgetPassVerifyOtpScreen → POST /auth/verify-otp (returns resetToken)
    → CreateNewPasswordScreen → POST /auth/reset-password (Authorization: resetToken)
```

---

# 10. Firebase

## 10.1 Project Configuration

| Field | Value |
|-------|-------|
| **Project ID** | `miltech-c3007` |
| **Messaging Sender ID** | `593611426236` |
| **Storage Bucket** | `miltech-c3007.firebasestorage.app` |
| **Android App ID** | `1:593611426236:android:9cd87a5138257a308083b9` |
| **iOS App ID** | `1:593611426236:ios:25aa849d8ab9826d8083b9` |
| **iOS Bundle ID** | `com.miltech.miltech` |

## 10.2 Configuration Files

| Platform | File |
|----------|------|
| Android | `android/app/google-services.json` |
| iOS | `ios/Runner/GoogleService-Info.plist` |
| Dart | `lib/firebase_options.dart` (FlutterFire CLI generated) |
| Config | `firebase.json` |

## 10.3 Services in Use

### Firebase Core

Initialized in `main.dart` before FCM:

```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### Firebase Cloud Messaging (FCM)

| State | Handler |
|-------|---------|
| Foreground | `FirebaseMessaging.onMessage` → local notification |
| Background | `_firebaseMessagingBackgroundHandler` (top-level) |
| Terminated | `getInitialMessage()` on startup |
| Token | Saved to GetStorage; sent to backend via profile update |

**Android channel:** `high_importance_channel`  
**Background handler:** Shows local notification with optional image

### Firebase Auth

Listed in `pubspec.yaml` but **not imported or used** in application code. Google authentication uses `google_sign_in` package directly.

## 10.4 Services NOT in Use

| Service | Status |
|---------|--------|
| Firestore | Not configured |
| Realtime Database | Not configured |
| Analytics | Disabled in plist |
| Crashlytics | Not integrated |
| Firebase Storage | Bucket configured, unused in app |
| Dynamic Links | Not integrated |
| Remote Config | Not integrated |

## 10.5 FCM Token Sync

FCM token is obtained on startup and stored locally. It is sent to the backend when the user profile is updated via `updateUserProfile(fcmToken: ...)`.

---

# 11. Local Storage

## 11.1 GetStorage

**Primary storage mechanism** for all client-side persistence.

| Key | Type | Purpose |
|-----|------|---------|
| `Token` | String | JWT access token |
| `refreshToken` | String | JWT refresh token |
| `fcmToken` | String | FCM device token |
| `themeModeDark` | bool | Dark mode preference |
| `isFirstTime` | bool | Onboarding completion flag |
| `language` | String | Language preference (unused UI) |
| `country` | String | Selected country |
| `UID` | String | User ID cache |

**Initialization:** `await GetStorage.init()` in `main.dart`

## 11.2 HTTP Cookie Jar

| Property | Value |
|----------|-------|
| Engine | `PersistCookieJar` + `FileStorage` |
| Path | `{applicationDocumentsDirectory}/cookies` |
| Expiry | Respected (`ignoreExpires: false`) |

## 11.3 Other Storage

| Technology | Status |
|------------|--------|
| SharedPreferences | Not used directly (GetStorage wraps similar functionality) |
| Hive | Not used |
| SQLite | Not used |
| Secure Storage | Not used |

## 11.4 Caching Strategy

| Data | Cache |
|------|-------|
| Images | `cached_network_image` + `flutter_cache_manager` |
| API responses | Not cached locally (always fetched fresh) |
| Cookies | File-persisted cookie jar |
| Tokens | GetStorage until logout/expiry |

## 11.5 Offline Support

**Limited.** The app shows network error snackbars but does not implement offline-first data sync or local database caching of API responses.

---

# 12. Third Party Packages

| Package | Version | Purpose | Why Used | Alternative |
|---------|---------|---------|----------|-------------|
| get | ^4.7.3 | State, routing, DI | Lightweight all-in-one | Provider, Riverpod, Bloc |
| dio | ^5.9.0 | HTTP client | Interceptors, multipart | http, chopper |
| dio_cookie_manager | ^3.4.0 | Cookie handling | HttpOnly refresh cookies | Manual cookie header |
| cookie_jar | ^4.0.9 | Cookie persistence | File-based jar | — |
| get_storage | ^2.1.1 | Local storage | Simple key-value | shared_preferences, hive |
| firebase_core | ^4.2.1 | Firebase init | Required for FCM | — |
| firebase_messaging | ^16.1.0 | Push notifications | Industry standard | OneSignal |
| firebase_auth | ^6.1.3 | Listed but unused | — | Remove or implement |
| flutter_local_notifications | ^18.0.0 | Local notifications | Foreground FCM display | — |
| google_sign_in | ^7.2.0 | Google OAuth | Native Google login | firebase_auth |
| google_maps_flutter | ^2.14.0 | Maps | Merchant location display | Mapbox |
| socket_io_client | ^3.1.3 | Real-time events | Matches Node.js backend | web_socket_channel |
| webview_flutter | ^4.13.0 | Stripe checkout | In-app payment URL | url_launcher |
| flutter_dotenv | ^6.0.0 | .env secrets | WEB_CLIENT_ID | dart-define only |
| cached_network_image | ^3.4.1 | Image caching | Performance | — |
| flutter_svg | ^2.2.3 | SVG rendering | Vector icons | — |
| image_picker | ^1.2.1 | Photo selection | Profile upload | — |
| geolocator | ^14.0.2 | GPS location | Map features | location package |
| geocoding | ^4.0.0 | Address lookup | Reverse geocoding | — |
| permission_handler | ^12.0.1 | Runtime permissions | Camera, location, notifications | — |
| syncfusion_flutter_barcodes | ^31.2.18 | QR/barcode | Loyalty card codes | qr_flutter |
| flutter_html | ^3.0.0 | HTML rendering | Terms/privacy | webview |
| shimmer_animation | ^2.2.2+1 | Loading shimmer | UX polish | — |
| skeletonizer | ^2.1.1 | Skeleton loaders | UX polish | — |
| smooth_page_indicator | ^2.0.1 | Page dots | Onboarding | — |
| flutter_otp_text_field | ^1.5.1+1 | OTP input | Verification screens | pin_code_fields |
| phone_form_field | ^10.0.17 | Phone input | International format | intl_phone_field |
| flutter_rating_bar | ^4.0.1 | Star ratings | Merchant rating | — |
| url_launcher | ^6.3.2 | External URLs | Links | — |
| device_info_plus | ^12.3.0 | Device metadata | Login device field | — |
| device_preview | ^1.3.1 | Responsive preview | Debug layout testing | — |
| pretty_dio_logger | ^1.4.0 | HTTP logging | Debug API traces | — |
| path_provider | ^2.1.6 | File paths | Cookie jar storage | — |
| mime | ^2.0.0 | MIME detection | Multipart uploads | — |
| http_parser | ^4.1.2 | Media types | Multipart Content-Type | — |
| change_app_package_name | ^1.5.0 | Package rename tool | Dev utility | — |
| flutter_lints | ^6.0.0 | Lint rules | Code quality (dev) | — |

---

# 13. Environment Configuration

## 13.1 Configuration Mechanisms

| Mechanism | Purpose | When Loaded |
|-----------|---------|-------------|
| `--dart-define-from-file` | API_BASE_URL, SOCKET_BASE_URL, APP_ENV | Compile time |
| `.env` file | `WEB_CLIENT_ID` for Google Sign-In | Runtime (`main.dart`) |
| Native config | Google Maps API keys, Firebase plist/json | Build time |

## 13.2 Dart Define Files

| File | Committed | Environment |
|------|-----------|-------------|
| `dart_defines/dev.json` | ✅ Yes | Development |
| `dart_defines/staging.json` | ✅ Yes | Staging |
| `dart_defines/prod.local.json.example` | ✅ Yes (template) | Production template |
| `dart_defines/prod.local.json` | ❌ Gitignored | Production (local secrets) |

### Example `dev.json`

```json
{
  "API_BASE_URL": "http://10.10.26.208:5004",
  "SOCKET_BASE_URL": "http://10.10.26.208:5004",
  "APP_ENV": "development"
}
```

### Example `staging.json`

```json
{
  "API_BASE_URL": "http://31.97.117.41:5004",
  "SOCKET_BASE_URL": "http://31.97.117.41:5004",
  "APP_ENV": "staging"
}
```

## 13.3 URL Resolution (`app_api_end_point.dart`)

```
API_BASE_URL  →  AppApiEndPoint.domain (trailing slash stripped)
domain + "/api/v1"  →  AppApiEndPoint.instance.baseUrl
SOCKET_BASE_URL (or domain)  →  socket origin
```

## 13.4 `.env` File

```
WEB_CLIENT_ID=your_google_web_client_id_here
```

- Listed in `pubspec.yaml` assets
- Gitignored (must be created locally)
- Required for Google Sign-In `serverClientId`

## 13.5 Build Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `API_BASE_URL` | **Yes** | Server origin without `/api/v1` |
| `SOCKET_BASE_URL` | No | Socket server (defaults to API URL) |
| `APP_ENV` | No | `development` / `staging` / `production` |

## 13.6 Configuration Process

1. Install FVM: `fvm install && fvm use`
2. Create `.env` with `WEB_CLIENT_ID`
3. Place Firebase config files (Android/iOS)
4. Run with: `fvm flutter run --dart-define-from-file=dart_defines/dev.json`
5. For production: copy `prod.local.json.example` → `prod.local.json` and set real URLs

## 13.7 IDE Launch Configurations

`.vscode/launch.json` provides:

- **Development** → `dart_defines/dev.json`
- **Staging** → `dart_defines/staging.json`
- **Production (local)** → `dart_defines/prod.local.json`

---

# 14. Assets

## 14.1 Images (`assets/images/`)

WebP format for optimized loading:

| Asset | Usage |
|-------|-------|
| `logo.webp` | App branding |
| `onboard1.webp`, `onboard2.webp`, `onbord3.webp` | Onboarding slides |
| `auth_image.webp`, `auth_img1-3.webp` | Auth screens |
| `background_image.webp` | Backgrounds |
| `confirm_img.webp` | Confirmation screen |
| `change_pass_img.webp` | Password change |
| `credit_card_img.webp` | Payment UI |
| `qr_code.webp`, `bar_code_img.webp` | Card code examples |
| `fre_coffe_img.webp` | Promotion placeholder |
| `reffer_img.webp`, `reffer_friend2.webp` | Referral screens |
| `theme_dark.webp`, `theme_light.webp` | Theme selection |
| `payment_option.webp` | Subscription payment |
| `placeholder.webp` | Default image fallback |
| `dev_img_*.webp` | Development/demo merchant images |

## 14.2 Icons (`assets/icon/`)

PNG and SVG icons referenced via `AssetsPath` class:

- Navigation icons: `ic_nav_home.png`, `ic_nav_merchant.png`, `ic_nav_wallet.png`, `ic_nav_profile.png`
- Social: `icgoogle.png`, `icapple.png`
- Feature icons: wallet, gift card, filter, favorite, shop, referral, notification, theme, etc.
- SVG: `popupRight.svg`

## 14.3 Fonts (`assets/fonts/`)

| Family | Weights | Files |
|--------|---------|-------|
| **Outfit** | 400, 500, 600, 700 | `Outfit-Regular.ttf`, `Outfit-Medium.ttf`, `Outfit-SemiBold.ttf`, `Outfit-Bold.ttf` |

Registered in `pubspec.yaml` and referenced as `AppConst.fontFamily1`.

## 14.4 Lottie

**Not used** in this project.

## 14.5 SVG

`flutter_svg` package used for `popupRight.svg` and potentially dynamic SVG content.

## 14.6 Videos

**Not used.**

## 14.7 Localization Files

**Not present.** No `l10n/`, `.arb`, or `flutter_localizations` configuration.

## 14.8 Remote Assets

Merchant images, profile photos, and promotion images are loaded from:

```
{AppApiEndPoint.domain}/{relative_path}
```

via `cached_network_image`.

---

# 15. Build Instructions

## 15.1 Prerequisites

```bash
# Install FVM and Flutter SDK
fvm install && fvm use

# Verify
fvm flutter --version   # Expected: 3.41.9

# Dependencies
fvm flutter pub get

# Environment files
# Create .env manually with WEB_CLIENT_ID

# iOS pods (macOS only)
cd ios && pod install && cd ..
```

## 15.2 Flutter Clean

```bash
fvm flutter clean
fvm flutter pub get
```

## 15.3 Run (Debug)

```bash
fvm flutter run --dart-define-from-file=dart_defines/dev.json
```

## 15.4 Android — Debug APK

```bash
fvm flutter build apk --debug \
  --dart-define-from-file=dart_defines/dev.json
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

## 15.5 Android — Release APK

```bash
# Development
fvm flutter build apk --release \
  --dart-define-from-file=dart_defines/dev.json

# Staging
fvm flutter build apk --release \
  --dart-define-from-file=dart_defines/staging.json

# Production
fvm flutter build apk --release \
  --dart-define-from-file=dart_defines/prod.local.json

# Split per ABI (smaller APKs)
fvm flutter build apk --release --split-per-abi \
  --dart-define-from-file=dart_defines/dev.json
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## 15.6 Android — App Bundle (AAB)

```bash
fvm flutter build appbundle --release \
  --dart-define-from-file=dart_defines/prod.local.json
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## 15.7 Android Signing

**Current state:** Release builds use **debug signing config** (`signingConfigs.getByName("debug")` in `build.gradle.kts`).

**Production requirement:**

1. Generate keystore: `keytool -genkey -v -keystore upload-keystore.jks ...`
2. Create `android/key.properties`
3. Configure `signingConfigs.release` in `build.gradle.kts`
4. **Never commit** keystore or key.properties

## 15.8 iOS — Build

```bash
fvm flutter build ios --release \
  --dart-define-from-file=dart_defines/prod.local.json
```

### Pods

```bash
cd ios
pod install --repo-update
cd ..
```

### Certificates & Provisioning

1. Apple Developer account required
2. Create App ID: `com.miltech.miltech`
3. Configure push notification capability
4. Create distribution certificate and provisioning profile
5. Open `ios/Runner.xcworkspace` in Xcode
6. Set signing team and provisioning profile

### Archive & IPA

1. Xcode → Product → Archive
2. Distribute App → App Store Connect / Ad Hoc
3. Or CI zip method (see Section 16)

---

# 16. Deployment Guide

## 16.1 Google Play Store

1. Build signed AAB with production dart-defines
2. Create app in Google Play Console
3. Upload `app-release.aab`
4. Complete store listing, content rating, privacy policy
5. Configure internal/closed/open testing tracks
6. Submit for review

**Requirements:**

- Production signing keystore (not debug)
- Privacy policy URL
- Target API level compliance

## 16.2 Apple App Store

1. Build and archive via Xcode
2. Upload to App Store Connect via Transporter or Xcode
3. Complete app metadata, screenshots, privacy nutrition labels
4. Enable push notification entitlement
5. Submit for App Review

## 16.3 Firebase App Distribution

**Not configured** in this repository. Can be added for internal QA distribution using Firebase CLI:

```bash
firebase appdistribution:distribute app-release.apk \
  --app <firebase-app-id> \
  --groups testers
```

## 16.4 Manual APK Distribution

```bash
fvm flutter build apk --release --split-per-abi \
  --dart-define-from-file=dart_defines/staging.json
```

Distribute `app-arm64-v8a-release.apk` to testers. Users must enable "Install from unknown sources."

## 16.5 CI/CD (GitHub Actions)

**File:** `.github/workflows/main.yml`

| Trigger | Branches |
|---------|----------|
| push | main, master, develop |
| pull_request | main, master |

**Current pipeline:**

1. Checkout on `macos-latest`
2. Setup Java 17
3. Setup Flutter stable (not FVM-pinned)
4. `flutter build apk --release --split-per-abi`
5. `flutter build ios --no-codesign` + zip IPA
6. Publish to GitHub Releases via `ncipollo/release-action`

**⚠️ CI Gaps (must fix for production):**

- Does not pass `--dart-define-from-file` (build will fail or use empty API URL)
- Uses `stable` channel instead of FVM 3.41.9
- No production signing configuration
- Requires `secrets.TOKEN` for release publishing

**Recommended CI fix:**

```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.41.9'
- run: |
    flutter build apk --release --split-per-abi \
      --dart-define=API_BASE_URL=${{ secrets.PROD_API_BASE_URL }} \
      --dart-define=SOCKET_BASE_URL=${{ secrets.PROD_SOCKET_BASE_URL }} \
      --dart-define=APP_ENV=production
```

---

# 17. Configuration Required Before Running

## 17.1 Mandatory Checklist

| Item | Location | Action |
|------|----------|--------|
| ☐ API URL | `dart_defines/*.json` | Set `API_BASE_URL` and `SOCKET_BASE_URL` |
| ☐ Google Web Client ID | `.env` | Set `WEB_CLIENT_ID` |
| ☐ Firebase Android | `android/app/google-services.json` | Place from Firebase Console |
| ☐ Firebase iOS | `ios/Runner/GoogleService-Info.plist` | Place from Firebase Console |
| ☐ Google Maps API Key (Android) | `AndroidManifest.xml` | Set `com.google.android.geo.API_KEY` |
| ☐ Google Maps API Key (iOS) | `AppDelegate.swift` | `GMSServices.provideAPIKey(...)` |
| ☐ SHA-1/SHA-256 fingerprints | Firebase Console | Required for Google Sign-In on Android |
| ☐ Initial Route | `my_app.dart` | Set to `AppRoutes.instance.initial` (not confirmScreen) |
| ☐ Production URLs | `dart_defines/prod.local.json` | Create from example (gitignored) |
| ☐ Android Signing | `build.gradle.kts` | Configure release keystore for production |
| ☐ iOS Signing | Xcode | Team, certificates, provisioning profile |
| ☐ Stripe | Backend | Ensure `/subscription/create` returns valid checkout URLs |
| ☐ Socket Server | Backend | Ensure Socket.IO accepts JWT in `auth.token` |

## 17.2 API URL Rules

- Include scheme: `https://` or `http://`
- Do **not** append `/api/v1`
- Do **not** trailing slash
- Example: `https://api.miltech.com`

## 17.3 Google Cloud Console

Enable APIs:

- Maps SDK for Android
- Maps SDK for iOS
- (Optional) Places API

Restrict API keys by package name (`com.miltech.miltech`) and iOS bundle ID.

## 17.4 Environment Variables Summary

| Variable | Source | Secret? |
|----------|--------|---------|
| `API_BASE_URL` | dart-define | Low (embedded in binary) |
| `SOCKET_BASE_URL` | dart-define | Low |
| `APP_ENV` | dart-define | No |
| `WEB_CLIENT_ID` | .env | Medium |
| Firebase API keys | Native config files | Medium |
| Google Maps keys | Native config files | Medium |

---

# 18. Admin Panel Integration

## 18.1 Overview

The mobile app communicates with a **Node.js backend** that includes admin-facing APIs. The admin panel itself is not part of this Flutter repository but is referenced through admin-scoped endpoints consumed by the customer app.

## 18.2 Admin API Endpoints Used by Customer App

| Endpoint | Purpose |
|----------|---------|
| `GET /admin/merchants` | Full merchant directory with search/filter |
| `GET /admin/merchants/nearby` | Geolocation-based nearby merchants |

## 18.3 Workflow Relationship

```
┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
│   Admin Panel    │ ──────► │  Node.js Backend │ ◄────── │  Customer App    │
│  (Web/Merchant)  │         │  /api/v1         │         │  (This Project)  │
└──────────────────┘         └────────┬─────────┘         └──────────────────┘
                                      │
                                      ▼
                              ┌──────────────────┐
                              │   Socket.IO      │
                              │  Real-time events│
                              └──────────────────┘
```

## 18.4 Key Integration Points

| Feature | Admin Action | Customer App Effect |
|---------|-------------|---------------------|
| Merchant Management | Admin creates/updates merchants | Merchants appear in list/map |
| Promotions | Admin publishes promotions | Shown in home/promo screens |
| Redemption | Merchant initiates point redemption | Socket popup `getApplyRequest::{userId}` |
| Subscriptions | Admin configures packages | Package list in subscription screen |
| User Waiting List | Admin sets `isUserWaiting` | Customer routed to WaitingScreen |
| Notifications | Admin/system sends push | FCM + in-app notification list |
| Disclaimers | Admin manages legal content | Terms/privacy HTML content |
| Tiers | Admin configures merchant tiers | Tier display on merchant details |

## 18.5 Required Backend Configuration

- CORS and cookie settings for mobile clients
- JWT issuance with refresh token rotation
- Socket.IO authentication middleware (JWT in handshake)
- Stripe integration for `/subscription/create`
- FCM server key for push from backend
- File upload endpoint for profile images (multipart PATCH `/user`)

---

# 19. Security

## 19.1 Authentication

| Measure | Implementation |
|---------|---------------|
| JWT Bearer tokens | All protected API calls |
| Refresh token rotation | `/auth/refresh-token` with mutex |
| HttpOnly cookies | PersistCookieJar for server-set cookies |
| Google OAuth | ID token validated server-side |

## 19.2 Authorization

- Server-side role/permission checks
- Client gates main shell on `subscription == "active"`
- 401 interceptor prevents unauthorized continued access

## 19.3 Data Encryption

| Data | Encryption |
|------|-----------|
| Tokens in GetStorage | **Not encrypted** (plain file) |
| Cookies on disk | File storage, not encrypted |
| HTTPS | Depends on `API_BASE_URL` scheme |
| iOS ATS | `NSAllowsArbitraryLoads: true` (allows HTTP — security risk for production) |

## 19.4 HTTPS

Production `API_BASE_URL` should use `https://`. Development/staging configs currently use `http://`.

## 19.5 Token Security

- Tokens stored in GetStorage (recoverable on rooted/jailbroken devices)
- `--dart-define` values embedded in compiled binary (not hidden from reverse engineering)
- Recommend `flutter_secure_storage` for token persistence in future

## 19.6 Storage Security

- No biometric lock
- Logout clears tokens (automatic path also clears cookies)
- FCM token cleared on `storageClear()`

## 19.7 Input Validation

- Client-side validation on sign-in (empty email/password)
- Phone field uses `phone_form_field` for format
- Server-side validation returns structured `errorMessages`

## 19.8 API Protection

- Bearer token on all authenticated endpoints
- 401 auto-refresh with single retry
- `followRedirects: false` prevents redirect-based attacks

## 19.9 API Key Exposure

Multiple Google Maps API keys exist in source code:

- `AndroidManifest.xml`
- `AppDelegate.swift`
- `app_const.dart`

**Recommendation:** Restrict keys in Google Cloud Console by app package/bundle ID and move to build-time injection.

---

# 20. Error Handling

## 20.1 Exception Handling Layers

| Layer | Handler |
|-------|---------|
| ApiServices | try/catch per HTTP verb; SocketException, TimeoutException, DioException |
| AppApi interceptor | 401 refresh, 400 snackbar |
| Repository | DioException parsing with `errorMessages` array support |
| Controller | try/catch with user-facing snackbars |

## 20.2 API Errors

```dart
// Structured error parsing pattern used across repositories:
if (responseData["errorMessages"] is List) → first error message
else if (responseData["message"]) → direct message
else if (responseData["error"]) → error field
```

## 20.3 Internet Errors

| Exception | User Message |
|-----------|-------------|
| `SocketException` | "Check Your Internet Connection" (or Bengali variant in one GET handler) |
| `TimeoutException` | Logged silently; returns null |

## 20.4 Timeout Configuration

| Setting | Duration |
|---------|----------|
| connectTimeout | 60s |
| sendTimeout | 60s |
| receiveTimeout | 60s |
| resetPassword | 2 minutes (override) |
| Notification image download | 15s |

## 20.5 Fallback Strategy

| Scenario | Fallback |
|----------|----------|
| Location denied | Default map position (California) |
| API returns null | Empty list / null model; snackbar shown |
| Token refresh fails | Logout to auth screen |
| Socket init fails | Logged; app continues without real-time |
| Image load failure | Placeholder image |

## 20.6 Retry Logic

- **401:** Automatic single retry after token refresh
- **Network:** No automatic retry
- **Socket:** Manual reconnect on navigation controller init

## 20.7 Logging

| Utility | Purpose |
|---------|---------|
| `AppPrint.appLog()` | General debug logging |
| `AppPrint.apiResponse()` | API response logging |
| `AppPrint.appError()` | Error logging with title |
| `errorLog()` | Standardized error log wrapper |
| `PrettyDioLogger` | Full HTTP request/response (debug only) |

---

# 21. Performance Optimizations

## 21.1 Image Optimization

- WebP assets for local images
- `cached_network_image` for remote images with disk cache
- `flutter_cache_manager` backing cache layer
- Notification images downloaded with 15s timeout

## 21.2 Lazy Loading

- `Get.lazyPut()` for controllers — created only when route opens
- `IndexedStack` in navigation preserves tab state but lazy-builds Merchants/Wallet tabs

## 21.3 Pagination

| Feature | Pagination |
|---------|-----------|
| Promotions | `limit` + `page` query params |
| Merchants | `limit` + `page` |
| Digital cards | `limit` + `page` |
| Gift cards | `limit` + `page` |
| Notifications | `limit` + `page` |

## 21.4 Caching

- Image disk cache via `cached_network_image`
- HTTP cookies cached on filesystem
- No API response caching

## 21.5 Memory Management

- Socket disposed and re-initialized on reconnect
- `off(eventName)` before re-registering socket listeners (prevents duplicates)
- TextEditingControllers disposed in controller `onClose()`

## 21.6 Widget Optimization

- `Obx` for granular reactive rebuilds
- `IndexedStack` avoids rebuilding all tabs on switch
- `liteModeEnabled: true` on home map preview
- Shimmer/skeleton loaders during data fetch

## 21.7 Build Optimization

- Release builds with tree shaking (Flutter default)
- Split per ABI for smaller APKs
- Code obfuscation available via `--obfuscate --split-debug-info` (not currently configured)

---

# 22. Known Issues

## 22.1 Current Bugs / Dev Overrides

| Issue | Severity | Detail |
|-------|----------|--------|
| Initial route override | **High** | `my_app.dart` sets `initialRoute` to `confirmScreen` instead of splash `/` |
| Manual logout cookie leak | Medium | `completeLogout()` does not clear cookie jar |
| Mixed language errors | Low | Some snackbars in Bengali, most in English |
| `firebase_auth` unused dependency | Low | Listed in pubspec but never imported |

## 22.2 Limitations

| Limitation | Detail |
|------------|--------|
| No offline mode | App requires network for all data |
| No localization | UI strings hardcoded in English |
| No deep linking | Notification tap does not navigate to specific screens |
| DevicePreview in debug | Wraps app in non-release builds |
| iOS ATS disabled | `NSAllowsArbitraryLoads: true` allows insecure HTTP |
| Single retry on 401 | No exponential backoff |

## 22.3 Technical Debt

| Item | Detail |
|------|--------|
| Inconsistent folder casing | `Merchants_screen/` vs `merchants_screen/` |
| Typo in route names | `cteatePasswordScreen`, `reffral` variants |
| Multiple Maps API keys | Different keys in manifest, AppDelegate, app_const |
| Debug signing for release | Android release uses debug keystore |
| CI/CD incomplete | Missing dart-defines and FVM version |
| No unit/integration tests | Only default `widget_test.dart` |
| Commented dead code | Various controllers and screens |

## 22.4 Workarounds

| Issue | Workaround |
|-------|------------|
| API_BASE_URL not set | Always pass `--dart-define-from-file` |
| Old sessions without refresh token | User must re-login after app update |
| Map not showing | `flutter clean`, `pod install`, verify API key |
| HTTP cookies not stored | Ensure server omits `Secure` flag on HTTP dev servers |

---

# 23. Future Improvements

## 23.1 High Priority

1. **Fix production entry point** — Restore `initialRoute` to splash screen
2. **Implement secure token storage** — Migrate to `flutter_secure_storage`
3. **Configure production signing** — Android keystore + iOS distribution
4. **Fix CI/CD pipeline** — FVM version, dart-defines, signing secrets
5. **Unify Google Maps API keys** — Single source via build configuration
6. **Align manual logout** — Clear cookies in `completeLogout()`

## 23.2 Medium Priority

7. **Add localization (i18n)** — `flutter_localizations` + ARB files
8. **Implement deep linking** — FCM notification tap → target screen
9. **Remove unused `firebase_auth`** dependency or integrate properly
10. **Add Crashlytics** — Firebase crash reporting for production
11. **Enable certificate pinning** — For production API endpoints
12. **Disable `NSAllowsArbitraryLoads`** — Use ATS exceptions only for dev

## 23.3 Low Priority / Enhancements

13. **Offline caching** — Cache merchant/promotion data locally
14. **Biometric authentication** — Optional app lock
15. **Widget tests** — Cover critical flows (auth, splash routing)
16. **Remove DevicePreview** from release pipeline
17. **Code obfuscation** — `--obfuscate` for release builds
18. **Standardize error messages** — All English or full i18n
19. **Repository interface abstraction** — Enable mocking for tests
20. **Dark mode polish** — Audit all screens for theme consistency

---

# 24. Project Maintenance Guide

## 24.1 Update Dependencies

```bash
# Check outdated packages
fvm flutter pub outdated

# Upgrade within constraints
fvm flutter pub upgrade

# Major version upgrades (review changelogs)
fvm flutter pub upgrade --major-versions
```

## 24.2 Upgrade Flutter

```bash
# Update FVM config
fvm install <new_version>
fvm use <new_version>

# Update .fvmrc
# Run
fvm flutter pub get
fvm flutter analyze
fvm flutter test
```

## 24.3 Change API URL

1. Edit appropriate `dart_defines/*.json`
2. Stop app completely (not hot reload)
3. Re-run with updated define file

## 24.4 Add a New Screen

1. Create folder: `lib/screen/new_feature/`
2. Add screen, controller, model, widgets
3. Add route constant in `app_routes.dart`
4. Register `GetPage` in `app_routes_file.dart`
5. Add controller to appropriate binding
6. Add API endpoints in `app_api_end_point.dart` (if needed)
7. Add repository methods
8. Navigate via `Get.toNamed()`

## 24.5 Add a New Feature (Full Stack)

1. Define API contract with backend team
2. Add endpoint constants
3. Create model classes with `fromJson`/`toJson`
4. Implement repository methods
5. Create GetX controller with reactive state
6. Build UI screen with shimmer loading states
7. Register route and binding
8. Test on both Android and iOS

## 24.6 Release Updates

1. Bump version in `pubspec.yaml` (`version: x.y.z+build`)
2. Fix `initialRoute` if needed
3. Run full regression on staging environment
4. Build signed release artifacts with production dart-defines
5. Test on physical devices (push, maps, payments, socket)
6. Upload to Play Store / App Store
7. Tag release in git

---

# 25. Backup & Restore

## 25.1 Source Code

| Item | Location | Backup Method |
|------|----------|---------------|
| Git repository | Remote origin | `git push` regularly |
| Uncommitted work | Local | Feature branches |

## 25.2 Assets

| Item | Location |
|------|----------|
| Images, icons, fonts | `assets/` directory (in git) |

## 25.3 Database

No local database. User data resides on Node.js backend — backup is a **backend responsibility**.

## 25.4 Firebase

| Item | Backup |
|------|--------|
| Project config | `firebase.json`, `google-services.json`, `GoogleService-Info.plist` |
| FCM server key | Firebase Console → Project Settings |
| Firebase project | Export via Firebase Console or Infrastructure-as-Code |

## 25.5 Keys & Secrets

| Secret | Storage | Backup |
|--------|---------|--------|
| `WEB_CLIENT_ID` | `.env` (gitignored) | Secure password manager / CI secrets |
| `prod.local.json` | Local only (gitignored) | CI/CD secrets vault |
| Android keystore | Local/CI (not in repo) | Encrypted offline backup |
| iOS certificates | Keychain / CI | Apple Developer portal |
| Google Maps API keys | Native config + Cloud Console | Google Cloud Console |
| GitHub Actions TOKEN | GitHub Secrets | GitHub Settings |

## 25.6 Restore Procedure

1. Clone repository
2. `fvm install && fvm use`
3. Restore `.env` from secure storage
4. Restore `dart_defines/prod.local.json`
5. Place Firebase config files
6. `fvm flutter pub get`
7. iOS: `cd ios && pod install`
8. Run with appropriate dart-define file

---

# 26. Delivery Checklist

## 26.1 Source & Code

- [ ] Complete source code repository access
- [ ] All feature branches merged to release branch
- [ ] `initialRoute` set to splash (`/`)
- [ ] No debug-only overrides in production code
- [ ] `flutter analyze` passes with no errors

## 26.2 Build Artifacts

- [ ] Signed release APK (arm64-v8a)
- [ ] Signed release AAB (Google Play)
- [ ] IPA (App Store / TestFlight)
- [ ] Build commands documented and verified

## 26.3 Documentation

- [ ] This handover document
- [ ] README.md
- [ ] API_URL_SETUP_INSTRUCTIONS.txt
- [ ] SESSION_EXPIRE_AND_COOKIE_AUTH.md
- [ ] GOOGLE_AUTH_FLOW.md
- [ ] GOOGLE_MAPS_FIX.md

## 26.4 Configuration

- [ ] Firebase project access (`miltech-c3007`)
- [ ] `google-services.json` (Android)
- [ ] `GoogleService-Info.plist` (iOS)
- [ ] `.env` with `WEB_CLIENT_ID`
- [ ] `dart_defines/prod.local.json` (production URLs)
- [ ] Google Maps API keys configured and restricted
- [ ] Android release keystore
- [ ] iOS distribution certificate and provisioning profile

## 26.5 Backend & Services

- [ ] Production API URL and health check
- [ ] Socket.IO server running and accessible
- [ ] Stripe integration active
- [ ] FCM server-side push configured
- [ ] Admin panel access (if applicable)

## 26.6 Quality Assurance

- [ ] Auth flows tested (login, signup, OTP, Google, forgot password)
- [ ] Subscription payment tested end-to-end
- [ ] Push notifications (foreground, background, terminated)
- [ ] Socket redemption popup tested
- [ ] Maps on Android and iOS
- [ ] Token refresh after session expiry
- [ ] Logout and re-login

## 26.7 Release

- [ ] Version number updated (`1.0.0+1` or higher)
- [ ] Release notes prepared
- [ ] Store listings complete (screenshots, descriptions)
- [ ] Privacy policy URL live

---

# 27. Changelog

Derived from git commit history:

| Version / Date | Changes |
|----------------|---------|
| **Recent** | Updated README with project structure, architecture, environment setup |
| | Success snackbars for wallet promotion add actions |
| | Removed unused `promotionId` parameter from redemption flow |
| | Quick start build commands; cookie management; token refresh logic |
| | Location repository cleanup |
| | TextFormField toolbar options (copy/paste/cut/select all) |
| | Map distance display and profile location handling |
| | API call corrections |
| | FCM background local notification with image support |
| | Home notification retrieval on tap; dialog height adjustments |
| | Local server URL updates; map user location detection |
| | Sign-in empty field validation; default map position update |
| | Wallet corrections |
| | Merchant model fixes |
| | Subscription plan index check; API endpoint URL updates |
| | FCM problem resolution |
| | Loading state corrections |

**App Version (pubspec.yaml):** `1.0.0+1`

---

# 28. Contact Information

| Field | Value |
|-------|-------|
| **Client** | Miltech |
| **Developer / Company** | Not Found in repository |
| **Email** | Not Found in repository |
| **Phone** | Not Found in repository |
| **Support Hours** | Not Found in repository |

> Contact details should be provided by the delivering team and inserted before final PDF distribution.

---

# 29. Appendix

## 29.1 Full Dependency List (pubspec.yaml)

```yaml
dependencies:
  flutter: sdk
  firebase_auth: ^6.1.3
  firebase_core: ^4.2.1
  firebase_messaging: ^16.1.0
  flutter_local_notifications: ^18.0.0
  cupertino_icons: ^1.0.8
  get: ^4.7.3
  dio: ^5.9.0
  cached_network_image: ^3.4.1
  flutter_cache_manager: ^3.4.1
  skeletonizer: ^2.1.1
  flutter_otp_text_field: ^1.5.1+1
  smooth_page_indicator: ^2.0.1
  device_preview: ^1.3.1
  pretty_dio_logger: ^1.4.0
  get_storage: ^2.1.1
  flutter_svg: ^2.2.3
  geolocator: ^14.0.2
  geocoding: ^4.0.0
  mime: ^2.0.0
  http_parser: ^4.1.2
  image_picker: ^1.2.1
  permission_handler: ^12.0.1
  flutter_html: ^3.0.0
  shimmer_animation: ^2.2.2+1
  device_info_plus: ^12.3.0
  syncfusion_flutter_barcodes: ^31.2.18
  change_app_package_name: ^1.5.0
  socket_io_client: ^3.1.3
  flutter_rating: ^2.0.2
  google_maps_flutter: ^2.14.0
  google_sign_in: ^7.2.0
  flutter_rating_bar: ^4.0.1
  url_launcher: ^6.3.2
  webview_flutter: ^4.13.0
  flutter_dotenv: ^6.0.0
  phone_form_field: ^10.0.17
  dio_cookie_manager: ^3.4.0
  cookie_jar: ^4.0.9
  path_provider: ^2.1.6

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^6.0.0
```

## 29.2 Useful Flutter Commands

```bash
# FVM setup
fvm install && fvm use

# Dependencies
fvm flutter pub get

# Analyze
fvm flutter analyze

# Test
fvm flutter test

# Run (development)
fvm flutter run --dart-define-from-file=dart_defines/dev.json

# Clean build
fvm flutter clean && fvm flutter pub get

# Build APK
fvm flutter build apk --release --dart-define-from-file=dart_defines/dev.json

# Build AAB
fvm flutter build appbundle --release --dart-define-from-file=dart_defines/prod.local.json

# Build iOS
fvm flutter build ios --release --dart-define-from-file=dart_defines/prod.local.json

# List devices
fvm flutter devices

# Outdated packages
fvm flutter pub outdated
```

## 29.3 Useful Git Commands

```bash
git status
git log --oneline -20
git diff
git checkout -b feature/my-feature
git add . && git commit -m "Description"
git push -u origin feature/my-feature
```

## 29.4 Troubleshooting

| Problem | Solution |
|---------|----------|
| `API_BASE_URL is not set` | Pass `--dart-define-from-file=dart_defines/dev.json` |
| Google Sign-In fails | Verify `WEB_CLIENT_ID` in `.env`, SHA fingerprints in Firebase |
| Maps blank | Check API key in manifest/AppDelegate; enable Maps SDK |
| 401 loop / forced logout | Clear app data; re-login to get fresh refresh token |
| Socket not connecting | Verify `SOCKET_BASE_URL`; check JWT in handshake |
| FCM not received | Check notification permissions; verify FCM token sent to backend |
| Stripe WebView blank | Verify backend returns valid checkout URL |
| Hot reload URL change | Full restart required after dart-define changes |
| `fvm: command not found` | Install FVM from https://fvm.app |
| iOS pod errors | `cd ios && pod deintegrate && pod install --repo-update` |

## 29.5 Useful Links

| Resource | URL |
|----------|-----|
| Flutter Documentation | https://docs.flutter.dev |
| FVM | https://fvm.app |
| GetX Documentation | https://pub.dev/packages/get |
| Dio Documentation | https://pub.dev/packages/dio |
| Firebase Console | https://console.firebase.google.com (project: miltech-c3007) |
| Google Cloud Console | https://console.cloud.google.com |
| Google Maps Platform | https://developers.google.com/maps |
| Stripe Documentation | https://stripe.com/docs |
| Socket.IO Client Dart | https://pub.dev/packages/socket_io_client |

## 29.6 Related Project Documentation Files

| File | Description |
|------|-------------|
| `README.md` | Project overview and quick start |
| `API_URL_SETUP_INSTRUCTIONS.txt` | Environment and build guide |
| `SESSION_EXPIRE_AND_COOKIE_AUTH.md` | Token refresh implementation |
| `GOOGLE_AUTH_FLOW.md` | Google Sign-In setup |
| `GOOGLE_MAPS_FIX.md` | Maps configuration and troubleshooting |

## 29.7 Socket.IO Events Reference

| Event | Direction | Purpose |
|-------|-----------|---------|
| `getApplyRequest::{userId}` | Server → Client | Point redemption approval request |
| `newNotification` | Server → Client | Real-time notification push |
| Connection auth | Client → Server | `{token: jwt}` in handshake |

## 29.8 Storage Keys Quick Reference

| Key Constant | String Value | Data |
|-------------|-------------|------|
| `AppStorageKey.token` | `Token` | JWT access token |
| `AppStorageKey.refreshToken` | `refreshToken` | JWT refresh token |
| `AppStorageKey.themeModeDark` | `themeModeDark` | bool |
| `AppStorageKey.isFirstTime` | `isFirstTime` | bool |
| `AppStorageKey.language` | `language` | String |
| `AppStorageKey.country` | `country` | String |

---

**End of Document**

*Miltech Customer — MLITECH Loyalty & Rewards App*  
*Technical Handover Documentation v1.0 — June 30, 2026*
