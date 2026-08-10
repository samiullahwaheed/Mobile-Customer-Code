class AppStorageKey {
  AppStorageKey._privateConstructor();
  static final AppStorageKey _instance = AppStorageKey._privateConstructor();
  static AppStorageKey get instance => _instance;
  String token = "Token";
  String resetToken = "ResetToken";
  String setFullFill = "userFullFill";
  String onboard = "onboard";
  String suggestion = "suggestion";
  String refreshToken = "refreshToken";
  String userData = "userData";
  // String userRole = "role";
  String language = "language";
  String country = "country";
  String themeModeDark = "themeModeDark";
  String themeModeLight = "themeModeLight";
  String isReferralUsed = "isReferralUsed";
  String isFirstTime = "isFirstTime";
}
