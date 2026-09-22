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
    // fenix: true — without it, a controller registered here gets fully
    // unregistered (not just disposed) the moment its originating route is
    // cleared from the stack (e.g. Get.offAllNamed, used throughout the
    // purchase/sales-rep flows). Any later Get.find<T>() for it then throws
    // instead of rebuilding it, which is what was silently crashing the
    // first-ever navigation to NavigationScreen (HomeController's own
    // constructor calls Get.find<ProfileController>() and
    // Get.find<NavigationScreenController>()).
    Get.lazyPut(() => NotificationSettingController(), fenix: true);
    Get.lazyPut(() => RecentlyViewController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => PrefferanceController(), fenix: true);
    Get.lazyPut(() => ChnageProfileController(), fenix: true);
    Get.lazyPut(() => PromoAndRewardController(), fenix: true);
    Get.lazyPut(() => PrivicyPolicyController(), fenix: true);
    Get.lazyPut(() => ChnagePassController(), fenix: true);
    Get.lazyPut(() => SinglePromoAndRewardController(), fenix: true);
    Get.lazyPut(() => MyGiftCardController(), fenix: true);
    Get.lazyPut(() => ShowDetailsController(), fenix: true);
    Get.lazyPut(() => GiftCardListController(), fenix: true);
    Get.lazyPut(() => VoucherController(), fenix: true);
    Get.lazyPut(() => SpecificServiceController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => TransactionHistoryController(), fenix: true);
    Get.lazyPut(() => MapDetailsController(), fenix: true);
    Get.lazyPut(() => MySubController(), fenix: true);
    Get.lazyPut(() => RefferFriendListController(), fenix: true);

    // ----------- Navigation Screen Controller
    Get.lazyPut(() => NavigationScreenController(), fenix: true);
    Get.lazyPut(() => MerchantController(), fenix: true);
    Get.lazyPut(() => MyWalletController(), fenix: true);
  }
}
