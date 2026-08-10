// ignore_for_file: strict_top_level_inference

class AppApiEndPoint {
  AppApiEndPoint._privateConstructor();
  static final AppApiEndPoint _instance = AppApiEndPoint._privateConstructor();
  static AppApiEndPoint get instance => _instance;

  /// Injected at compile time via `--dart-define` or `--dart-define-from-file`.
  /// Defaults to the production API so plain `flutter build apk --release`
  /// (no dart-define flags) works out of the box.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.rewaldo.com',
  );

  /// Defaults to [apiBaseUrl] when not set separately.
  static const String socketBaseUrl = String.fromEnvironment('SOCKET_BASE_URL');

  /// One of: development | staging | production
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static final String domain = _normalizeBaseUrl(
    apiBaseUrl,
    name: 'API_BASE_URL',
  );

  static final String _socketOrigin = _socketOriginUrl();

  /// ==========================================================
  /// MEDIA / IMAGE URL BUILDER
  /// ==========================================================
  ///
  /// Backend ab images DigitalOcean Spaces par upload karta hai aur DB mein
  /// poora absolute URL save karta hai (https://cdn.rewaldo.com/uploads/...).
  ///
  /// Purane records mein abhi bhi relative path ho sakta hai (/uploads/...).
  ///
  /// Is helper se dono cases sahi chalte hain. Kabhi bhi seedha
  /// domain aur path ko string mein jode mat, warna absolute URL ke aage
  /// domain lag kar "https://api.rewaldo.comhttps://cdn..." ban jata hai
  /// aur image kabhi load nahi hoti.
  static String mediaUrl(String? path) {
    if (path == null) return '';

    final value = path.trim();
    if (value.isEmpty) return '';

    // Pehle se poora URL hai to jaisa hai waisa hi wapas do
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    // Local file ya data URI
    if (value.startsWith('file://') || value.startsWith('data:')) {
      return value;
    }

    // Legacy relative path
    if (value.startsWith('/')) {
      return '$domain$value';
    }

    return '$domain/$value';
  }

  final String baseUrl = '$domain/api/v1';
  final String refreshToken = '/auth/refresh-token';

  ////Auth/////////////
  final String googleAuth = '/auth/google';
  final String login = '/auth/login';
  final String resetToken = '/auth/refresh-token';
  final String signUp = '/user';
  final String verifyPhone = '/auth/verify-otp';
  final String resendPhone = '/auth/resend-otp';
  final String forgotPassword = '/auth/forgot-password';
  final String resetPassword = '/auth/reset-password';
  final String changePassword = '/auth/change-password';
  final String contactUs = '/contact';
  final String deleteAccount = '/auth/user-delete-account';
  ////in app Url/////////////
  final String getProfile = '/user/profile';
  final String updateProfile = '/user';
  final String addCardForWallet = '/add-promotion/create-digital-card';
  final String recentViewedPromotions = '/recent-viewed-promotions';
  final String addPromotionToWallet = '/add-promotion/add';
  final String merchant = '/promo-merchant/popular-merchants';
  final String myGiftCard = '/add-promotion/my-promotions';
  final String digitalCard = '/add-promotion/my-digital-cards';
  final String merchantTier = '/promo-merchant/users/tier';
  final String merchantAll = '/admin/merchants';
  final String transactionHistory = '/sell/points-history';
  final String approveAndRejectRedemptionRequest = '/sell/promotion/';
  final String socketGetPopupResponse = _socketOrigin;
  final String specificPromotionList = '/promo-merchant/by-category';
  final String notification = '/notifications';
  final String nearByMerchent = '/admin/merchants/nearby';
  final String packageList = '/package/active-packages';
  final String sellRequist = '/sell/pending-checkouts';
  final String packagePayment = '/subscription/create';
  final String kuickpayPackagePayment = '/kuickpay/create';
  final String kuickpayConfirmPayment = '/kuickpay/confirm';
  final String kuickpayOrderStatus = '/kuickpay/order';
  final String packageHistory = '/subscription';
  final String favoriteMerchant = '/favorite/add';
  final String notificationRead = '/notifications/read';
  final String subscriptionSummary = '/user/summary-counts';
  final String rateMerchant = '/rating/give-rating';
  final String referralSummary = '/referrals/mine';
  final String referralVerify = '/referrals/verify-referral';
  final String salesRep = '/sales-rep';
  final String salesRepTokenValided = '/sales-rep/validate';
  static String ruls(var endPoint) => '/disclaimers/$endPoint';
  static String tiarList(var endPoint) => '/tier/merchant/$endPoint';
  static String merchantDetails(var merchantId) =>
      '/promo-merchant/merchants/$merchantId';
  static String promotion(var limit, var page) =>
      '/promo-merchant/user-combine-promotions?limit=$limit&page=$page';
}

String _normalizeBaseUrl(String raw, {required String name}) {
  final url = raw.trim();
  if (url.isEmpty) {
    throw StateError(
      '$name is not set. Run with:\n'
          '  flutter run --dart-define-from-file=dart_defines/dev.json\n'
          'Or select a launch configuration in VS Code / Cursor.',
    );
  }
  return url.replaceAll(RegExp(r'/+$'), '');
}

String _socketOriginUrl() {
  final override = AppApiEndPoint.socketBaseUrl.trim();
  if (override.isNotEmpty) {
    return _normalizeBaseUrl(override, name: 'SOCKET_BASE_URL');
  }
  return AppApiEndPoint.domain;
}