import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/model/digital_card_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class MyWalletController extends GetxController {
  GetRepository getRepository = GetRepository.instance;
  RxList<DigitalCard> digitalCardList = <DigitalCard>[].obs;
  RxBool isLoading = false.obs;
  int page = 1;
  int limit = 10;
  RxBool isMoreDataAvailable = true.obs;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  // Add debounce timer
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchDigitalCard();
  }

  Future<void> fetchDigitalCard() async {
    try {
      isLoading.value = true;
      final response = await getRepository.getDigitalCard(
        limit: limit,
        page: page,
        // search: "test",
        search: searchController.text,
      );

      if (response.isNotEmpty) {
        // Clear list only when it's a new search or first page
        if (page == 1) {
          digitalCardList.clear();
        }
        digitalCardList.addAll(response);
        AppPrint.apiResponse(
          response.length,
          title: "Digital Card List - Page $page",
        );

        // Check if we've reached the last page
        if (response.length < limit) {
          isMoreDataAvailable.value = false;
        }
      } else {
        if (page == 1) {
          digitalCardList.clear();
        }
        AppPrint.appError("No Digital Card Found");
        isMoreDataAvailable.value = false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "Fetch Digital Card Error in Controller");
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
      fetchDigitalCard();
    });
  }

  //----------------For Reload Page------------------------------
  void reloadPage() {
    page = 1;
    digitalCardList.clear();
    isMoreDataAvailable.value = true;
    fetchDigitalCard();
  }

  //----------------Reset Pagination------------------------------
  void resetPagination() {
    page = 1;
    isMoreDataAvailable.value = true;
    digitalCardList.clear();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isMoreDataAvailable.value && !isLoading.value) {
        page++;
        fetchDigitalCard();
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
