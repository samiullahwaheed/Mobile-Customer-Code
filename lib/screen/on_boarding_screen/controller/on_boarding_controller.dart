import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();
  final GetStorageServices storageServices = GetStorageServices.instance;
  final pageController = PageController();
  RxInt currentPageIndex = 0.obs;

  void updatePageIndicator(index) => currentPageIndex.value = index;
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage() {
    if (currentPageIndex.value == 2) {
      storageServices.isUserFirstTime(true);
      Get.toNamed(AppRoutes.instance.authScreen);
    } else {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
