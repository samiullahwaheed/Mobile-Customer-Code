import 'package:get/get.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/controller/navigation_screen_controller.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/model/my_gift_card_model.dart';
import 'package:loyalty_customer/screen/home_screen/model/merchent_model.dart';
import 'package:loyalty_customer/screen/home_screen/model/near_by_merchent_model.dart';
import 'package:loyalty_customer/screen/home_screen/model/promotion_model.dart';
import 'package:loyalty_customer/screen/home_screen/model/subscription_summery_model.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class HomeController extends GetxController {
  //----------Dependencies----------
  ProfileController profileController = Get.find<ProfileController>();
  GetRepository getRepository = GetRepository.instance;
  NavigationScreenController navController =
      Get.find<NavigationScreenController>();
  //----------Variables----------
  RxList<Promotion> promotionList = <Promotion>[].obs;
  RxList<Promotion> recentViewedPromotionList = <Promotion>[].obs;
  RxList<MerchantModelData> merchantList = <MerchantModelData>[].obs;
  RxList<NearByMerchentModelData> nearbyMerchantList =
      <NearByMerchentModelData>[].obs;
  Rxn<UserSummaryData> subSummaryList = Rxn<UserSummaryData>();

  RxBool hasNotification = false.obs;
  RxList<List<double>> location = <List<double>>[].obs;
  RxList<PromotionElement> myGiftCardList = <PromotionElement>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingNearbyMerchant = false.obs;
  //----------Initial----------
  @override
  void onInit() {
    super.onInit();
    fetchPromotion();
    fetchMyGiftCard();
    getNearbyMerchant();
    fetchMerchant();
    fetchRecentViewedPromotion();
    getSubSummary();
  }

  //----------Fetch My Gift Card----------
  Future<void> fetchMyGiftCard() async {
    try {
      isLoading.value = true;
      final response = await getRepository.getMyGiftCard();

      if (response.isNotEmpty) {
        myGiftCardList.value = response;
        AppPrint.apiResponse(myGiftCardList.length, title: "My Gift Card List");
      }
    } catch (e) {
      AppPrint.appError(e, title: "Fetch My Gift Card Error in Controller");
    } finally {
      isLoading.value = false;
    }
  }

  //----------Get sub summary----------
  void getSubSummary() async {
    isLoading.value = true;
    final response = await getRepository.getSubscriptionSummary();
    if (response != null) {
      subSummaryList.value = response;
    } else {
      AppPrint.appError("No Sub Summary Found");
    }
    isLoading.value = false;
  }

  //----------Get Nearby Merchant----------
  void getNearbyMerchant() async {
    isLoadingNearbyMerchant.value = true;
    final response = await getRepository.getNearbyMerchant(distance: 100.0);
    if (response.isNotEmpty) {
      nearbyMerchantList.addAll(response);
      AppPrint.appPrint(
        "Nearby Merchant List: ${nearbyMerchantList.length}",
        title: "Nearby Merchant List",
      );
      location.value = response
          .map((e) => [e.lat ?? 0.0, e.lng ?? 0.0])
          .toList();
      AppPrint.appPrint("Location1234: $location", title: "Location1234");

      // location.value = response
      //     .map((e) => [e.lat ?? 0.0, e.lng ?? 0.0])
      //     .toList();
      // AppPrint.appPrint("Location1234: $location", title: "Location1234");
    } else {
      AppPrint.appError("No Merchant Found");
    }
    isLoadingNearbyMerchant.value = false;
  }
  //----------reload page----------

  void reloadPage() {
    promotionList.clear();
    merchantList.clear();
    recentViewedPromotionList.clear();
    getNearbyMerchant();
    getSubSummary();
    fetchMyGiftCard();
    fetchPromotion();
    fetchMerchant();
    fetchRecentViewedPromotion();
    navController.fetchSellRequist();
  }

  //----------Fetch Promotion----------
  void fetchPromotion() async {
    isLoading.value = true;
    final promotionList = await getRepository.getPromotion(10, 1);
    if (promotionList.isNotEmpty) {
      this.promotionList.value = promotionList;
    } else {
      AppPrint.appError("No Promotion Found");
    }
    isLoading.value = false;
  }

  //----------Fetch merchant----------
  void fetchMerchant() async {
    isLoading.value = true;
    final response = await getRepository.getMerchant(10, 1);
    if (response.isNotEmpty) {
      merchantList.addAll(response);
    } else {
      AppPrint.appError("No Merchant Found");
    }
    isLoading.value = false;
  }

  //----------Fetch recent viewed Promotion----------
  void fetchRecentViewedPromotion() async {
    final response = await getRepository.getRecentViewPromotion();
    if (response.isNotEmpty) {
      recentViewedPromotionList.value = response;
    } else {
      AppPrint.appError("No Recent Viewed Promotion Found");
    }
  }
}

class CategoryItem {
  final String title;
  final String imageUrl;

  const CategoryItem({required this.title, required this.imageUrl});
}

final List<CategoryItem> categoryItems = const [
  CategoryItem(title: 'Food and Beverages', imageUrl: 'assets/icon/food.png'),
  CategoryItem(
    title: 'Apparel and Footwear',
    imageUrl: 'assets/icon/apparel.png',
  ),
  CategoryItem(title: 'Accessories', imageUrl: 'assets/icon/accessoris.png'),
  CategoryItem(title: 'Health and Beauty', imageUrl: 'assets/icon/beauty.png'),
  CategoryItem(title: 'Salons and Spas', imageUrl: 'assets/icon/salon.png'),
  CategoryItem(
    title: 'Leisure and Entertainment',
    imageUrl: 'assets/icon/entertaintment.png',
  ),
  CategoryItem(title: 'Home and Living', imageUrl: 'assets/icon/home.png'),
  CategoryItem(title: 'Education', imageUrl: 'assets/icon/education.png'),
  CategoryItem(title: 'Electronics', imageUrl: 'assets/icon/electronic.png'),
  CategoryItem(title: 'Toys and Gifts', imageUrl: 'assets/icon/toy.png'),
  CategoryItem(title: 'Travel and Tour', imageUrl: 'assets/icon/travel.png'),
  CategoryItem(title: 'Other Services', imageUrl: 'assets/icon/ourService.png'),
];
