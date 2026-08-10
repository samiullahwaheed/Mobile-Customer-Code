class AppRoutes {
  AppRoutes._privateConstructor();
  static final AppRoutes _instance = AppRoutes._privateConstructor();
  static AppRoutes get instance => _instance;
  /////////////  initial or splash screen
  final String initial = "/";
  final String onBoardingScreen = "/onboarding-screen";
  final String navigationScreen = "/navigation-screen";

  final String signInScreen = "/sign-in-screen";
  final String signUpScreen = "/sign-up-screen";
  final String cteatePasswordScreen = "/create-your-password-screen";
  final String cteateNewPasswordScreen = "/create-new-password-screen";
  final String signupWithReffralIdScreen = "/signup-with-reffral-id-screen";
  final String enterReffralIdScreen = "/enter-reffarl-id-screen";
  final String verifyOtpScreen = "/verify-otp-screen";
  final String forgetPassVerifyOtpScreen = "/forgetpass-verify-otp-screen";
  final String forgetPassScreen = "/forget-pass-screen";
  final String authScreen = "/auth-screen";
  final String locationScreen = "/location-screen";
  final String preferencesScreen = "/preferences-screen";
  final String waitingScreen = "/waiting-screen";

  ///////////////App Screen////////////////////////////////////
  final String profileScreen = "/profile-screen";
  final String changeProfileScreen = "/change-profile-screen";
  final String changePassScreen = "/change-pass-screen";
  final String contactUsScreen = "/contact-us-screen";
  final String mySubScreen = "/my-sub-screen";
  final String stripeCheckoutWebView = "/stripe-checkout-webview";
  final String kuickpayCheckoutWebView = "/kuickpay-checkout-webview";
  final String termsScreen = "/terms-screen";
  final String privicyScreen = "/privicy-screen";
  final String confirmScreen = "/confirm-screen";
  final String noInternetScreen = "/no-internet-screen";
  final String notificationScreen = "/notification-screen";
  final String notificationSettingScreen = "/notification-settings-screen";
  final String transactionHistoryScreen = "/transaction-history-screen";
  final String voucherScreen = "/voucher-screen";
  final String homeScreen = "/home-screen";
  final String merchantsScreen = "/merchant-screen";
  final String myWallet = "/my-wallet-screen";
  final String myGIftCardScreen = "/my-gift-card-screen";
  final String showDetailsScreen = "/show-details-screen";
  final String mapDetailsScreen = "/map-details-screen";
  final String giftCardListScreen = "/gift-card-list-screen";
  final String refferFriendScreen = "/reffer-friend-screen";
  final String promoRewardScreen = "/promo-reward-screen";
  final String recentlyViewScreen = "/recently-view-screen";
  final String refferFriendMainScreen = "/reffer-friend-main-screen";
  final String refferFriendListScreen = "/reffer-friend-list-screen";
  final String myPointScreen = "/my-point-screen";
  final String singlePromoAndRewardScreen = "/single-promo-and-reward-screen";
  final String specificServiceScreen = "/specific-service-screen";
  
}
