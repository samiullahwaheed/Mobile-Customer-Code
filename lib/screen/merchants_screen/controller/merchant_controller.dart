import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/merchants_screen/model/all_merchant_model.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';

import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_drop_down/app_drop_dow.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_input/app_input_widget_two.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class MerchantController extends GetxController {
  // List of RxBool to track favorite status for each merchant
  var favorites = <RxBool>[].obs;
  GetRepository getRepository = GetRepository.instance;
  PostRepository postRepository = PostRepository.instance;
  RxList<AllMerchantModelData> merchantList = <AllMerchantModelData>[].obs;
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;
  ScrollController scrollController = ScrollController();
  int page = 1;
  int limit = 10;
  RxBool isMoreDataAvailable = true.obs;

  TextEditingController locationController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  String? service;
  String? isFavorite;
  RxBool isFilterOn = false.obs;

  // Add debounce timer
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchMerchant();
  }

  Future<void> fetchMerchant() async {
    try {
      isLoading.value = true;
      final response = await getRepository.getAllMerchant(
        limit: limit,
        page: page,
        search: searchController.text,
        address: locationController.text,
        service: service,
        radius: distanceController.text,
        favorite: isFavorite == "Favourite Merchant" ? true : false,
      );
      if (response.isNotEmpty) {
        // Clear list only when it's a new search or first page
        if (page == 1) {
          merchantList.clear();
        }
        merchantList.addAll(response);
        AppPrint.apiResponse(
          response.length,
          title: "Merchant List - Page $page",
        );

        // Check if we've reached the last page
        if (response.length < limit) {
          isMoreDataAvailable.value = false;
        }
      } else {
        if (page == 1) {
          merchantList.clear();
        }
        AppPrint.appError("No Merchant Found");
        isMoreDataAvailable.value = false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "Fetch Merchant Error");
      isMoreDataAvailable.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> favoriteMerchant({required String merchantId}) async {
    try {
      final response = await postRepository.favoriteMerchant(
        merchantId: merchantId,
      );

      if (response == true) {
        /// list এর ভিতর loop করে matching merchant বের করবো
        final index = merchantList.indexWhere(
          (merchant) => merchant.id == merchantId,
        );

        if (index != -1) {
          /// Toggle the favorite status - যদি true থাকে তাহলে false হবে, আর false থাকলে true হবে
          /// null হলে false ধরে নিয়ে তারপর toggle করবে
          merchantList[index].isFavorite =
              !(merchantList[index].isFavorite ?? false);

          /// GetX কে notify করার জন্য
          merchantList.refresh();
        }

        AppPrint.apiResponse("Merchant favorite status toggled successfully");
      } else {
        AppPrint.apiResponse("Failed to toggle favorite merchant");
      }
    } catch (e) {
      AppPrint.appError(e, title: "favoriteMerchant");
    }
  }

  //----------------For Debounced Search------------------------------
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Reset pagination for new search
      resetPagination();
      fetchMerchant();
    });
  }

  //----------------For Reload Page------------------------------
  void reloadPage() {
    page = 1;
    merchantList.clear();
    isMoreDataAvailable.value = true;
    fetchMerchant();
  }

  void clearFilter() {
    locationController.clear();
    distanceController.clear();
    service = null;
    isFilterOn.value = false;
    isFavorite = null;
    fetchMerchant();
  }

  //----------------Reset Pagination------------------------------
  void resetPagination() {
    page = 1;
    isMoreDataAvailable.value = true;
    merchantList.clear();
  }

  void showMerchantsFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage(width: 24, path: AssetsPath.icShop),
                  Gap(width: AppSize.width(value: 8)),
                  AppText(
                    data: "Merchants Filter",
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ],
              ),
              Divider(height: 2, color: AppColor.button5Light),
              SizedBox(height: 16),

              // Location Input
              AppInputWidgetTwo(
                controller: locationController,
                isOptional: true,
                title: "Location",
                hintText: "Enter Your Location",
                suffixIcon: AppImage(
                  iconColor: AppColor.button2Light,
                  width: 24,
                  path: AssetsPath.icLocation,
                ),
              ),
              AppInputWidgetTwo(
                controller: distanceController,
                isOptional: true,
                title: "Location Distance ",
                hintText: "10KM",
              ),
              Gap(height: AppSize.width(value: 8)),
              AppText(
                data: "Filter Merchants",
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
              ),
              Gap(height: AppSize.width(value: 8)),
              CustomDropdown(
                items: ["All Merchant", "Favourite Merchant"],
                hint: "Filter Merchants",
                onChanged: (p0) {
                  isFavorite = p0 ?? "";
                },
              ),
              Gap(height: AppSize.width(value: 8)),
              AppText(
                data: "All services",
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w500,
              ),
              Gap(height: AppSize.width(value: 8)),
              CustomDropdown(
                items: [
                  "Food and Beverages",
                  "Apparel and Footwear",
                  "Accessories",
                  "Health and Beauty",
                  "Salons and Spas",
                  "Leisure and Entertainment",
                  "Home and Living",
                  "Education",
                  "Electronics",
                  "Toys and Gifts",
                  "Travel and Tour",
                  "Other Services",
                ],
                hint: "All services",
                onChanged: (p0) {
                  service = p0;
                },
              ),
              Gap(height: AppSize.width(value: 8)),
              
              // // Select Service Dropdown
              Gap(height: AppSize.width(value: 16)),
              // Apply Filters Button
              AppButton(
                onTap: () {
                  fetchMerchant();
                  isFilterOn.value = true;
                  Get.back();
                },
                title: "Apply Filters",
              ),
            ],
          ),
        );
      },
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isMoreDataAvailable.value && !isLoading.value) {
        page++;
        fetchMerchant();
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
