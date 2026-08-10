import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/controller/navigation_screen_controller.dart';
import 'package:loyalty_customer/screen/app_navigation_screen/navigation_tab.dart';
import 'package:loyalty_customer/screen/home_screen/controller/home_controller.dart';
import 'package:loyalty_customer/screen/home_screen/model/promotion_model.dart';
import 'package:loyalty_customer/screen/home_screen/widget/auto_scroll_reward_carousel.dart';
import 'package:loyalty_customer/screen/home_screen/widget/home_map_preview.dart';
import 'package:loyalty_customer/screen/home_screen/widget/home_reward_card.dart';
import 'package:loyalty_customer/screen/home_screen/widget/shimmer/home_name_shimmer_item.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_shimmer/home_card_shimmer.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0,
            toolbarHeight: 62,
            title: Obx(() {
              if (controller.isLoading.value) {
                return const HomeNameShimmerItem();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: AppText(
                          data:
                          "Hello ${controller.profileController.profileData.value?.firstName ?? "Loading..."}",
                          fontSize: AppSize.width(value: 18),
                          fontWeight: FontWeight.w700,
                          color: appThemeColor.text2,
                          maxLines: 1,
                        ),
                      ),
                      if (controller.subSummaryList.value?.subscriptionTitles.isNotEmpty == true) ...[
                        Gap(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.width(value: 8),
                            vertical: AppSize.width(value: 3),
                          ),
                          decoration: BoxDecoration(
                            color: appThemeColor.icon.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: AppText(
                            data: controller.subSummaryList.value!.subscriptionTitles.last,
                            fontSize: AppSize.width(value: 10),
                            fontWeight: FontWeight.w600,
                            color: appThemeColor.icon,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Gap(height: 12),
                  SizedBox(
                    width: AppSize.width(value: 160),

                    child: AppText(
                      data:
                      controller
                          .profileController
                          .profileData
                          .value
                          ?.address ??
                          "Loading...",
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w400,
                      maxLines: 2,
                      color: appThemeColor.text2,
                    ),
                  ),
                ],
              );
            }),

            leadingWidth: 62,
            leading: InkWell(
              onTap: () {
                final NavigationScreenController controller = Get.find();
                controller.changeTab(NavigationTab.profile);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() {
                  return AppImageCircular(
                    borderColor: appThemeColor.icon,
                    url:
                    AppApiEndPoint.mediaUrl(controller.profileController.profileData.value?.profile),
                  );
                }),
              ),
            ),
            actionsPadding: EdgeInsets.only(top: 8, right: 16),
            actions: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.instance.notificationScreen);
                  controller.navController.notificationController
                      .getNotification();
                  controller.hasNotification.value = false;
                },
                child: Obx(() {
                  return Stack(
                    children: [
                      Container(
                        width: AppSize.width(value: 32),
                        height: AppSize.width(value: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: AppColor.text1Dark,
                        ),
                      ),

                      if (controller.hasNotification.value ||
                          controller
                              .navController
                              .notificationController
                              .notificationList
                              .firstWhereOrNull(
                                (element) => element.isRead == false,
                          ) !=
                              null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(AppSize.width(value: 16)),
            child: RefreshIndicator(
              onRefresh: () async {
                controller.reloadPage();
              },
              child: SingleChildScrollView(
                child: Column(
                  spacing: AppSize.size.height * 0.01,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      data: "Explore Shop on the Map",
                      fontSize: AppSize.width(value: 18),
                      fontWeight: FontWeight.w700,
                      color: appThemeColor.text2,
                    ),
                    Obx(() {
                      if (controller.isLoadingNearbyMerchant.value) {
                        return Skeletonizer(
                          enabled: true,
                          child: Container(
                            width: AppSize.width(value: double.infinity),
                            height: AppSize.size.height * 0.20,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          AppPrint.appPrint(
                            "Location: ${controller.location.toList()}",
                            title: "Location",
                          );
                          Get.toNamed(
                            AppRoutes.instance.mapDetailsScreen,
                            arguments: controller.nearbyMerchantList,
                          );
                          // controller.getNearbyMerchant();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            width: AppSize.width(value: double.infinity),
                            height: AppSize.size.height * 0.20,
                            decoration: BoxDecoration(
                              color: appThemeColor.cart,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Stack(
                              children: [
                                HomeMapPreview(
                                  merchantList: controller.location,
                                ),
                                // Overlay to indicate it's tappable
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.1),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: appThemeColor.icon,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.fullscreen,
                                          color: appThemeColor.text1,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        AppText(
                                          data: "View Full Map",
                                          color: appThemeColor.text1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    if (categoryItems.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                data: "All Services",
                                fontSize: AppSize.width(value: 18),
                                fontWeight: FontWeight.w700,
                                color: appThemeColor.text2,
                              ),
                            ],
                          ),

                          SizedBox(
                            height: AppSize.size.height * 0.14,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryItems.length,
                              itemBuilder: (context, index) {
                                var item = categoryItems[index];
                                return HomeShopCategoryCard(
                                  title: item.title,
                                  merchantImage: item.imageUrl,
                                  appThemeColor: appThemeColor,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  data: "Popular Merchants",
                                  fontSize: AppSize.width(value: 18),
                                  fontWeight: FontWeight.w700,
                                  color: appThemeColor.text2,
                                ),
                              ],
                            ),
                            Skeletonizer(
                              enabled: true,
                              child: SizedBox(
                                height: AppSize.size.height * 0.14,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: AppSize.width(value: 48),
                                            height: AppSize.width(value: 48),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          Gap(height: AppSize.width(value: 8)),
                                          Container(
                                            width: AppSize.width(value: 60),
                                            height: AppSize.width(value: 12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(4),
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (controller.merchantList.isNotEmpty) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  data: "Popular Merchants",
                                  fontSize: AppSize.width(value: 18),
                                  fontWeight: FontWeight.w700,
                                  color: appThemeColor.text2,
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.navController.changeTab(
                                      NavigationTab.merchants,
                                    );
                                  },
                                  child: AppText(
                                    data: "View All",
                                    fontSize: AppSize.width(value: 16),
                                    fontWeight: FontWeight.w700,
                                    color: appThemeColor.icon,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: AppSize.size.height * 0.14,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.merchantList.length,
                                itemBuilder: (context, index) {
                                  final merchant =
                                  controller.merchantList[index];
                                  return HomeShopCard(
                                    onTap: () {
                                      Get.toNamed(
                                        AppRoutes.instance.showDetailsScreen,
                                        arguments: merchant.id,
                                      );
                                    },
                                    title: merchant.displayName,
                                    merchantImage:
                                    AppApiEndPoint.mediaUrl(merchant.profile ?? ""),
                                    appThemeColor: appThemeColor,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    // --------------Your Rewards (Normal)--------------
                    Obx(() {
                      // ❌ Empty হলে পুরো section hide
                      if (!controller.isLoading.value &&
                          controller.myGiftCardList.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          // 🔹 Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                data: "Your Rewards",
                                fontSize: AppSize.width(value: 18),
                                fontWeight: FontWeight.w700,
                                color: appThemeColor.text2,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.instance.giftCardListScreen,
                                  );
                                },
                                child: AppText(
                                  data: "View All",
                                  fontSize: AppSize.width(value: 16),
                                  fontWeight: FontWeight.w700,
                                  color: appThemeColor.icon,
                                ),
                              ),
                            ],
                          ),

                          Gap(height: AppSize.width(value: 12)),

                          // 🔹 Body - Normal horizontal list
                          SizedBox(
                            height: AppSize.size.height * 0.3,
                            child: controller.isLoading.value
                                ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const HomeCardShimmer();
                              },
                            )
                                : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.myGiftCardList.length,
                              itemBuilder: (context, index) {
                                var item =
                                controller.myGiftCardList[index];
                                return HomeRewardCard(
                                  promotion: Promotion(
                                    id: item.promotion?.id,
                                    name: item.promotion?.name,
                                    startDate: item.promotion?.startDate,
                                    endDate: item.promotion?.endDate,
                                    image: item.promotion?.image,
                                    status: item.promotion?.status,
                                    createdAt: item.promotion?.createdAt,
                                    updatedAt: item.promotion?.updatedAt,
                                  ),
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.instance.voucherScreen,
                                      arguments: item,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                    Gap(height: AppSize.width(value: 12)),
                    // --------------Special Promotions (Slider)--------------
                    Obx(() {
                      // ❌ Empty হলে পুরো section hide
                      if (!controller.isLoading.value &&
                          controller.promotionList.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          // 🔹 Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                data: "Special Promotions",
                                fontSize: AppSize.width(value: 18),
                                fontWeight: FontWeight.w700,
                                color: appThemeColor.text2,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.instance.promoRewardScreen,
                                  );
                                },
                                child: AppText(
                                  data: "View All",
                                  fontSize: AppSize.width(value: 16),
                                  fontWeight: FontWeight.w700,
                                  color: appThemeColor.icon,
                                ),
                              ),
                            ],
                          ),

                          Gap(height: AppSize.width(value: 12)),

                          // 🔹 Body - Slider with auto scroll
                          SizedBox(
                            height: AppSize.size.height * 0.3,
                            child: controller.isLoading.value
                                ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const HomeCardShimmer();
                              },
                            )
                                : AutoScrollRewardCarousel(
                              itemCount: controller.promotionList.length,
                              itemWidth: AppSize.size.width * 0.8 + 12,
                              itemBuilder: (context, index) {
                                var item =
                                controller.promotionList[index];
                                return HomeRewardCard(
                                  promotion: item,
                                  onTap: () {
                                    if (item.source == "admin") {
                                      AppSnackBar.message(
                                        "This Promotion is created by Admin",
                                      );
                                    } else {
                                      Get.toNamed(
                                        AppRoutes
                                            .instance
                                            .singlePromoAndRewardScreen,
                                        arguments: {
                                          "promotion": item,
                                          "button": false,
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),

                    Gap(height: AppSize.width(value: 12)),
                    //-------------------Recently Viewed-------------------
                    Obx(() {
                      // ❌ Empty হলে পুরো section hide
                      if (!controller.isLoading.value &&
                          controller.recentViewedPromotionList.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          // 🔹 Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                data: "Your Recently Viewed",
                                fontSize: AppSize.width(value: 18),
                                fontWeight: FontWeight.w700,
                                color: appThemeColor.text2,
                              ),
                              // যদি চান view all button, uncomment করে ব্যবহার করতে পারেন
                              // InkWell(
                              //   onTap: () {
                              //     Get.toNamed(AppRoutes.instance.recentlyViewScreen);
                              //   },
                              //   child: AppText(
                              //     data: "View All",
                              //     fontSize: AppSize.width(value: 16),
                              //     fontWeight: FontWeight.w700,
                              //     color: appThemeColor.icon,
                              //   ),
                              // ),
                            ],
                          ),

                          Gap(height: AppSize.width(value: 12)),

                          // 🔹 Body
                          SizedBox(
                            height: AppSize.size.height * 0.3,
                            child: controller.isLoading.value
                                ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const HomeCardShimmer();
                              },
                            )
                                : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller
                                  .recentViewedPromotionList
                                  .length,
                              itemBuilder: (context, index) {
                                final promotion = controller
                                    .recentViewedPromotionList[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: HomeRewardCard(
                                    promotion: promotion,
                                    onTap: () {
                                      Get.toNamed(
                                        AppRoutes
                                            .instance
                                            .singlePromoAndRewardScreen,
                                        arguments: {
                                          "promotion": promotion,
                                          "button":
                                          promotion.isPromotionAdded,
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeShopCard extends StatelessWidget {
  final String? title;
  final String? merchantImage;
  final VoidCallback? onTap;
  const HomeShopCard({
    super.key,
    required this.appThemeColor,
    this.onTap,
    this.title,
    this.merchantImage,
  });

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Get.toNamed(
            AppRoutes.instance.specificServiceScreen,
            arguments: title ?? "",
          );
        }
      },
      child: Padding(

        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppImageCircular(
              width: AppSize.width(value: 48),
              height: AppSize.width(value: 48),
              url:
              merchantImage ??
                  "https://cdn.pixabay.com/photo/2017/03/10/13/57/cooking-2132874_1280.jpg",
            ),
            Gap(height: AppSize.width(value: 8)),
            AppText(
              data: title ?? "Burger King",
              fontSize: AppSize.width(value: 12),
              fontWeight: FontWeight.w500,
              color: appThemeColor.text2,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeShopCategoryCard extends StatelessWidget {
  final String? title;
  final String? merchantImage;
  final VoidCallback? onTap;
  const HomeShopCategoryCard({
    super.key,
    required this.appThemeColor,
    this.onTap,
    this.title,
    this.merchantImage,
  });

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Get.toNamed(
            AppRoutes.instance.specificServiceScreen,
            arguments: title ?? "",
          );
        }
      },
      child: Padding(

        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppImageCircular(
              width: AppSize.width(value: 48),
              height: AppSize.width(value: 48),
              path:
              merchantImage ??
                  "https://cdn.pixabay.com/photo/2017/03/10/13/57/cooking-2132874_1280.jpg",
            ),
            Gap(height: AppSize.width(value: 8)),
            AppText(
              data: title ?? "Burger King",
              fontSize: AppSize.width(value: 12),
              fontWeight: FontWeight.w500,
              color: appThemeColor.text2,
            ),
          ],
        ),
      ),
    );
  }
}

List<String> servicdeItem = [
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
];

List<List<double>> locations = [
  [23.8150, 90.4100],
  [23.8055, 90.4180],
  [23.8120, 90.4050],
  [23.8180, 90.4200],
  [23.8075, 90.4085],
  [23.8110, 90.4150],
  [23.8135, 90.4120],
  [23.8090, 90.4070],
  [23.8160, 90.4170],
  [23.8105, 90.4135],
];