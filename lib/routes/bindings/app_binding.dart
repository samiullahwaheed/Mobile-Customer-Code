import 'package:get/get.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/controller/navigation_screen_controller.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/controller/gift_card_list_controller.dart';
import 'package:loyalty_customer/screen/home_screen/controller/home_controller.dart';
import 'package:loyalty_customer/screen/home_screen/controller/specific_service_controller.dart';
import 'package:loyalty_customer/screen/map_details_screen/controller/map_details_controller.dart';
import 'package:loyalty_customer/screen/merchants_screen/controller/merchant_controller.dart';
import 'package:loyalty_customer/screen/my_gift_card_screen/controller/my_gift_card_controller.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/controller/my_wallet_controller.dart';
import 'package:loyalty_customer/screen/notification_screen/controller/notification_controller.dart';
import 'package:loyalty_customer/screen/preferences_screen/controller/prefferance_controller.dart';
import 'package:loyalty_customer/screen/privicy_screen/controller/privicy_policy_controller.dart';
import 'package:loyalty_customer/screen/profile_section/chnage_pass_screen/controller/chnage_pass_controller.dart';
import 'package:loyalty_customer/screen/profile_section/chnage_profile_info/controller/chnage_profile_controller.dart';
import 'package:loyalty_customer/screen/profile_section/notification_setting_screen/controller/notification_setting_controller.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/screen/promo_and_reward_screen/controller/promo_and_reward_controller.dart';
import 'package:loyalty_customer/screen/promo_and_reward_screen/controller/single_promo_and_reward_controller.dart';
import 'package:loyalty_customer/screen/recently_view_screen/controller/recently_view_controller.dart';
import 'package:loyalty_customer/screen/reffer_friend_list_screen/controller/reffer_friend_list_controller.dart';
import 'package:loyalty_customer/screen/show_details_screen/controller/show_details_controller.dart';
import 'package:loyalty_customer/screen/subscription_screen/controller/my_sub_controller.dart';
import 'package:loyalty_customer/screen/transaction_history_screen/controller/transaction_history_controller.dart';
import 'package:loyalty_customer/screen/voucher_screen/controller/voucher_controller.dart';

class AppBinding extends Bindings {
  @override
  dependencies() {
    Get.lazyPut(() => NotificationSettingController());
    Get.lazyPut(() => RecentlyViewController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PrefferanceController());
    Get.lazyPut(() => ChnageProfileController());
    Get.lazyPut(() => PromoAndRewardController());
    Get.lazyPut(() => PrivicyPolicyController());
    Get.lazyPut(() => ChnagePassController());
    Get.lazyPut(() => SinglePromoAndRewardController());
    Get.lazyPut(() => MyGiftCardController());
    Get.lazyPut(() => ShowDetailsController());
    Get.lazyPut(() => GiftCardListController());
    Get.lazyPut(() => VoucherController());
    Get.lazyPut(() => SpecificServiceController());
    Get.lazyPut(() => NotificationController());
    Get.lazyPut(() => TransactionHistoryController());
    Get.lazyPut(() => MapDetailsController());
    Get.lazyPut(() => MySubController());
    Get.lazyPut(() => RefferFriendListController());

    // ----------- Navigation Screen Controller
    Get.lazyPut(() => NavigationScreenController());
    Get.lazyPut(() => MerchantController());
    Get.lazyPut(() => MyWalletController());
  }
}
