import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/routes/bindings/app_binding.dart';
import 'package:loyalty_customer/routes/bindings/auth_binding.dart';
import 'package:loyalty_customer/routes/bindings/navigation_screen_binding.dart';
import 'package:loyalty_customer/routes/bindings/splash_screen_binding.dart';
import 'package:loyalty_customer/screen/Merchants_screen/Merchants_screen.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/navigation_screen.dart';
import 'package:loyalty_customer/screen/auth/auth_screen/auth_screen.dart';
import 'package:loyalty_customer/screen/auth/create_new_password_screen/create_new_password_screen.dart';
import 'package:loyalty_customer/screen/auth/create_your_password_screen/create_your_password_screen.dart';
import 'package:loyalty_customer/screen/auth/enter_reffral_id_screen/enter_reffral_id_screen.dart';
import 'package:loyalty_customer/screen/auth/forget_pass_screen/forget_pass_screen.dart';
import 'package:loyalty_customer/screen/auth/location_screen/location_screen.dart';
import 'package:loyalty_customer/screen/auth/sign_in_screen/sign_in_screen.dart';
import 'package:loyalty_customer/screen/auth/sign_up_screen/sign_up_screen.dart';
import 'package:loyalty_customer/screen/auth/signup_with_reffral_id/signup_with_reffral_id_screen.dart';
import 'package:loyalty_customer/screen/auth/verify_otp_screen/verify_otp_screen.dart';
import 'package:loyalty_customer/screen/auth/waiting_screen/waitning_screen.dart';
import 'package:loyalty_customer/screen/confirm_screen/confirm_screen.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/gift_card_list_screen.dart';
import 'package:loyalty_customer/screen/home_screen/home_screen.dart';
import 'package:loyalty_customer/screen/home_screen/specific_service_screen.dart';
import 'package:loyalty_customer/screen/map_details_screen/map_details_screen.dart';
import 'package:loyalty_customer/screen/my_gift_card_screen/my_gift_card_screen.dart';
import 'package:loyalty_customer/screen/my_point_screen/my_point_screen.dart';
import 'package:loyalty_customer/screen/no_internet_screen/no_internet_screen.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/my_wallet_screen.dart';
import 'package:loyalty_customer/screen/notification_screen/notification_screen.dart';
import 'package:loyalty_customer/screen/on_boarding_screen/on_boarding_screen.dart';
import 'package:loyalty_customer/screen/preferences_screen/Preferences_screen.dart';
import 'package:loyalty_customer/screen/privicy_screen/privicy_screen.dart';
import 'package:loyalty_customer/screen/profile_section/chnage_pass_screen/change_pass_screen.dart';
import 'package:loyalty_customer/screen/profile_section/chnage_profile_info/chnage_profile_screen.dart';
import 'package:loyalty_customer/screen/profile_section/contact_us_screen/contact_us_screen.dart';
import 'package:loyalty_customer/screen/profile_section/notification_setting_screen/notification_setting_screen.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/profile_screen.dart';
import 'package:loyalty_customer/screen/promo_and_reward_screen/promo_and_reward_screen.dart';
import 'package:loyalty_customer/screen/promo_and_reward_screen/single_promo_and_reward_screen.dart';
import 'package:loyalty_customer/screen/recently_view_screen/recently_view_screen.dart';
import 'package:loyalty_customer/screen/reffer_friend_list_screen/reffer_friend_list_screen.dart';
import 'package:loyalty_customer/screen/reffer_friend_main_screen/reffer_friend_main_screen.dart';
import 'package:loyalty_customer/screen/reffer_friends/reffer_friends_screen.dart';
import 'package:loyalty_customer/screen/show_details_screen/show_details_screen.dart';
import 'package:loyalty_customer/screen/splash_screen/splash_screen.dart';
import 'package:loyalty_customer/screen/subscription_screen/my_sub_screen/my_sub_screen.dart';
import 'package:loyalty_customer/screen/subscription_screen/my_sub_screen/stripe_checkout_webview_screen.dart';
import 'package:loyalty_customer/screen/subscription_screen/my_sub_screen/kuickpay_checkout_webview_screen.dart';
import 'package:loyalty_customer/screen/terms_screen/terms_screen.dart';
import 'package:loyalty_customer/screen/transaction_history_screen/transaction_history_screen.dart';
import 'package:loyalty_customer/screen/voucher_screen/voucher_screen.dart';

import '../screen/auth/forget_pass_verify_otp_screen/forgetpass_verify_otp_screen.dart';

List<GetPage> appRootRoutesFile = <GetPage>[
  //   /////////////////  splash screen start
  GetPage(
    name: AppRoutes.instance.initial,
    binding: SplashScreenBinding(),
    page: () => const SplashScreen(),
    transitionDuration: Duration(milliseconds: 800),
    opaque: false,
  ),
  GetPage(
    name: AppRoutes.instance.profileScreen,
    // binding: SplashScreenBinding(),
    page: () => const ProfileScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.waitingScreen,
    binding: AuthBinding(),
    page: () => const WaitningScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.changeProfileScreen,
    binding: AppBinding(),
    page: () => const ChnageProfileScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.changePassScreen,
    binding: AppBinding(),
    page: () => const ChangePassScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.contactUsScreen,
    // binding: SplashScreenBinding(),
    page: () => const ContactUsScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.mySubScreen,
    binding: AppBinding(),
    page: () => const MySubScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.stripeCheckoutWebView,
    binding: AppBinding(),
    page: () => const StripeCheckoutWebViewScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.kuickpayCheckoutWebView,
    binding: AppBinding(),
    page: () => const KuickpayCheckoutWebViewScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.termsScreen,
    // binding: SplashScreenBinding(),
    page: () => const TermsScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.privicyScreen,
    binding: AppBinding(),
    page: () => const PrivicyScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.notificationScreen,
    binding: AppBinding(),
    page: () => const NotificationScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.transactionHistoryScreen,
    binding: AppBinding(),
    page: () => const TransactionHistoryScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.confirmScreen,
    // binding: SplashScreenBinding(),
    page: () => ConfirmScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.noInternetScreen,
    page: () => const NoInternetScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.notificationSettingScreen,
    binding: AppBinding(),
    page: () => const NotificationSettingScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.voucherScreen,
    binding: AppBinding(),
    page: () => const VoucherScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.homeScreen,
    // binding: AppBinding(),
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.merchantsScreen,
    // binding: AppBinding(),
    page: () => const MerchantsScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.myWallet,
    // binding: AppBinding(),
    page: () => const MyWalletScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.navigationScreen,
    binding: NavigationScreenBinding(),
    page: () => const NavigationScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.myGIftCardScreen,
    binding: AppBinding(),
    page: () => const MyGiftCardScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.signInScreen,
    binding: AppBinding(),
    page: () => const SignInScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.signUpScreen,
    binding: AuthBinding(),
    page: () => const SignUpScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.cteatePasswordScreen,
    binding: AuthBinding(),
    page: () => const CreatePasswordScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.cteateNewPasswordScreen,
    binding: AuthBinding(),
    page: () => const CreateNewPasswordScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.signupWithReffralIdScreen,
    // binding: AuthBinding(),
    page: () => const SignUpWithReffaleIDScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.enterReffralIdScreen,
    // binding: AuthBinding(),
    page: () => const EnterReffalIdScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.verifyOtpScreen,
    binding: AuthBinding(),
    page: () => const VerifyOtpScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.forgetPassVerifyOtpScreen,
    binding: AuthBinding(),
    page: () => const ForgetPassVerifyOtpScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.forgetPassScreen,
    binding: AuthBinding(),
    page: () => const ForgetPassScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.authScreen,
    binding: AuthBinding(),
    page: () => const AuthScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.locationScreen,
    binding: AuthBinding(),
    page: () => const LocationScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.preferencesScreen,
    binding: AppBinding(),
    page: () => const PreferencesScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.showDetailsScreen,
    binding: AppBinding(),
    page: () => const ShowDetailsScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.mapDetailsScreen,
    binding: AppBinding(),
    page: () => const MapDetailsScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.giftCardListScreen,
    binding: AppBinding(),
    page: () => const GiftCardListScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.onBoardingScreen,
    // binding: AuthBinding(),
    page: () => OnBoardingScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.refferFriendScreen,
    // binding: AuthBinding(),
    page: () => RefferFriendsScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.promoRewardScreen,
    binding: AppBinding(),
    page: () => PromoAndRewardScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.recentlyViewScreen,
    binding: AppBinding(),
    page: () => RecentlyViewScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.refferFriendMainScreen,
    // binding: AuthBinding(),
    page: () => RefferFriendMainScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.refferFriendListScreen,
    binding: AppBinding(),
    page: () => RefferFriendListScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.myPointScreen,
    // binding: AuthBinding(),
    page: () => MyPointScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.singlePromoAndRewardScreen,
    binding: AppBinding(),
    page: () => SinglePromoAndRewardScreen(),
  ),
  GetPage(
    name: AppRoutes.instance.specificServiceScreen,
    binding: AppBinding(),
    page: () => SpecificServiceScreen(),
  ),
];
