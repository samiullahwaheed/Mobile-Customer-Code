import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/model/my_gift_card_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class GiftCardListController extends GetxController {
  //----------Dependencies----------
  GetRepository getRepository = GetRepository.instance;
  //----------Variables----------
  RxList<PromotionElement> myGiftCardList = <PromotionElement>[].obs;
  RxBool isLoading = false.obs;
  RxBool isMoreDataAvailable = true.obs;
  int page = 1;
  int limit = 10;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  // Add debounce timer
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchMyGiftCard();
  }

  //----------Fetch My Gift Card----------
  Future<void> fetchMyGiftCard() async {
    try {
      isLoading.value = true;
      final response = await getRepository.getMyGiftCard(
        limit: limit,
        page: page,
        search: searchController.text,
      );

      if (response.isNotEmpty) {
        // Clear list only when it's a new search or first page
        if (page == 1) {
          myGiftCardList.clear();
        }
        myGiftCardList.addAll(response);
        AppPrint.apiResponse(
          response.length,
          title: "My Gift Card List - Page $page",
        );

        // Check if we've reached the last page
        if (response.length < limit) {
          isMoreDataAvailable.value = false;
        }
      } else {
        if (page == 1) {
          myGiftCardList.clear();
        }
        AppPrint.appError("No Gift Card Found");
        isMoreDataAvailable.value = false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "Fetch My Gift Card Error in Controller");
      isMoreDataAvailable.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  //----------------For Debounced Search------------------------------
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Reset pagination for new search
      resetPagination();
      fetchMyGiftCard();
    });
  }

  //----------------For Reload Page------------------------------
  void reloadPage() {
    page = 1;
    myGiftCardList.clear();
    isMoreDataAvailable.value = true;
    fetchMyGiftCard();
  }

  //----------------Reset Pagination------------------------------
  void resetPagination() {
    page = 1;
    isMoreDataAvailable.value = true;
    myGiftCardList.clear();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isMoreDataAvailable.value && !isLoading.value) {
        page++;
        fetchMyGiftCard();
      }
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
