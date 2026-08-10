import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/merchants_screen/controller/merchant_controller.dart';
import 'package:loyalty_customer/screen/merchants_screen/widgets/merchent_card.dart';
import 'package:loyalty_customer/screen/merchants_screen/widgets/shimmer/merchent_shimmer.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class MerchantsScreen extends StatelessWidget {
  const MerchantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<MerchantController>(
      init: MerchantController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            showLeading: false,
            text: "All Merchant",
            appThemeColor: appThemeColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        controller: controller.searchController,
                        onChanged: controller.onSearchChanged,
                        style: TextStyle(color: appThemeColor.text2),
                        cursorColor: appThemeColor.text2,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          prefixIconColor: appThemeColor.text2.withValues(
                            alpha: 0.5,
                          ),
                          hintText: 'Search Merchants',
                          hintStyle: TextStyle(
                            color: appThemeColor.text2.withValues(alpha: 0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: appThemeColor.icon,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: appThemeColor.icon,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 10.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.width(value: 12)),
                    Expanded(
                      flex: 1,
                      child: Obx(() {
                        return controller.isFilterOn.value
                            ? GestureDetector(
                                onTap: () {
                                  controller.clearFilter();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: appThemeColor.icon,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.clear,
                                    size: 28,
                                    color: appThemeColor.icon,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  controller.showMerchantsFilterBottomSheet(
                                    context,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: appThemeColor.icon,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.filter_list,
                                    size: 28,
                                    color: appThemeColor.icon,
                                  ),
                                ),
                              );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.height(value: 16)),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => controller.reloadPage(),
                    child: Obx(() {
                      // If loading for the first time and list is empty
                      if (controller.isLoading.value &&
                          controller.merchantList.isEmpty) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const MerchantCardShimmer();
                          },
                        );
                      }

                      // If list is empty and loading is finished
                      if (controller.merchantList.isEmpty &&
                          !controller.isLoading.value) {
                        return Center(
                          child: AppText(
                            data: "No Merchant Found",
                            fontSize: AppSize.width(value: 16),
                            fontWeight: FontWeight.w600,
                            color: appThemeColor.text2,
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.merchantList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < controller.merchantList.length) {
                            var merchant = controller.merchantList[index];
                            return Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: MerchantCard(
                                toggoleFavorate: () {
                                  controller.favoriteMerchant(
                                    merchantId: merchant.id ?? "",
                                  );
                                },
                                favorateValue: merchant.isFavorite ?? false,
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.instance.showDetailsScreen,
                                    arguments: merchant.id,
                                  );
                                },
                                merchant: merchant,
                                appThemeColor: appThemeColor,
                              ),
                            );
                          } else {
                            if (controller.isMoreDataAvailable.value) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: AppText(
                                    data: "No more merchants",
                                    fontSize: AppSize.width(value: 16),
                                    fontWeight: FontWeight.w600,
                                    color: appThemeColor.text2,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
