import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/home_screen/model/promotion_model.dart';
import 'package:loyalty_customer/screen/show_details_screen/controller/show_details_controller.dart';
import 'package:loyalty_customer/screen/show_details_screen/widgets/show_details_shimmer.dart';
import 'package:loyalty_customer/screen/show_details_screen/widgets/view_dialog.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/utils/date_formetter_for_promotion.dart';
import 'package:loyalty_customer/utils/url_luncher.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class ShowDetailsScreen extends StatelessWidget {
  const ShowDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;

    return GetBuilder<ShowDetailsController>(
      init: ShowDetailsController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              // return Center(child: CircularProgressIndicator());
              return ShowDetailsShimmer();
            }
            return CustomScrollView(
              slivers: [
                /// 🔥 SliverAppBar OVERLAY on image
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: AppSize.size.height * 0.28,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: Get.back,
                      child: AppImage(
                        width: AppSize.width(value: 28),
                        path: AssetsPath.arrowBack,
                        iconColor: Colors.white,
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: AppImageCircular(
                      borderRadius: 0,
                      fit: BoxFit.fitWidth,
                      url:
                      AppApiEndPoint.mediaUrl(controller.merchantDetails.value?.merchant?.photo),
                      // width: double.infinity,
                      height: AppSize.size.height * 0.28,
                    ),
                  ),
                ),

                /// 🔽 Body Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppSize.width(value: 12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Merchant Info
                        Row(
                          spacing: AppSize.width(value: 12),
                          children: [
                            AppImageCircular(
                              width: AppSize.width(value: 48),
                              height: AppSize.width(value: 48),
                              url:
                              AppApiEndPoint.mediaUrl(controller.merchantDetails.value?.merchant?.profile),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: AppSize.width(value: 8),
                                children: [
                                  AppText(
                                    data:
                                    controller
                                        .merchantDetails
                                        .value
                                        ?.merchant
                                        ?.businessName ??
                                        "Loading...",
                                    fontSize: AppSize.width(value: 18),
                                    fontWeight: FontWeight.w700,
                                    color: color.text2,
                                  ),
                                  Row(
                                    children: [
                                      AppImage(
                                        path: AssetsPath.icLocationIcon,
                                        width: AppSize.width(value: 16),
                                        iconColor: color.text2,
                                      ),
                                      Gap(width: AppSize.width(value: 8)),
                                      Expanded(
                                        child: AppText(
                                          data:
                                          controller
                                              .merchantDetails
                                              .value
                                              ?.merchant
                                              ?.address ??
                                              "Loading...",
                                          fontSize: AppSize.width(value: 12),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          color: color.text2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final website = controller
                                          .merchantDetails
                                          .value
                                          ?.merchant
                                          ?.website;
                                      if (website != null) {
                                        UrlLauncherHelper.open(website);
                                      } else {
                                        AppSnackBar.error("Website not found");
                                      }
                                    },
                                    child: AppText(
                                      data: "Visit Website",
                                      fontSize: AppSize.width(value: 14),
                                      fontWeight: FontWeight.w700,
                                      color: color.text2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                if (controller
                                    .merchantDetails
                                    .value
                                    ?.merchant
                                    ?.digitalCardId !=
                                    "............")
                                  AppButton(
                                    onTap: () {
                                      Get.toNamed(
                                        AppRoutes.instance.myGIftCardScreen,
                                        arguments: {
                                          "digitalCardId": controller
                                              .merchantDetails
                                              .value
                                              ?.merchant
                                              ?.digitalCardId,
                                          "merchantId": controller
                                              .merchantDetails
                                              .value
                                              ?.merchant
                                              ?.id,
                                          "merchantName": controller
                                              .merchantDetails
                                              .value
                                              ?.merchant
                                              ?.businessName,
                                          "cardCode": controller
                                              .merchantDetails
                                              .value
                                              ?.merchant
                                              ?.cardCode,
                                          "image": controller
                                              .merchantDetails
                                              .value
                                              ?.merchant
                                              ?.profile,
                                          "point": controller
                                              .merchantDetails
                                              .value
                                              ?.merchant
                                              ?.availablePoints,
                                        },
                                      );
                                    },
                                    height: AppSize.width(value: 32),
                                    width: AppSize.width(value: 78),
                                    title: "View History",
                                    titleSize: AppSize.width(value: 10),
                                    filColor: color.button,
                                    titleColor: AppColor.button2Dark,
                                  ),
                                Gap(height: AppSize.width(value: 8)),
                                if (controller.tiarList.value != null)
                                  AppButton(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => ViewPointTierDialog(
                                          tiarList: controller.tiarList.value,
                                        ),
                                      );
                                    },
                                    height: AppSize.width(value: 32),
                                    width: AppSize.width(value: 100),
                                    titleSize: AppSize.width(value: 10),
                                    title: "View Point & Tiers",
                                    filColor: color.button,
                                    titleColor: AppColor.button2Dark,
                                  ),
                                Gap(height: AppSize.width(value: 8)),
                                if (controller
                                    .merchantDetails
                                    .value
                                    ?.merchant
                                    ?.digitalCardId ==
                                    "")
                                  Obx(() {
                                    return controller
                                        .isLoadingAddCardForWallet
                                        .value
                                        ? CircularProgressIndicator()
                                        : AppButton(
                                      onTap: () {
                                        controller.addCardForWallet();
                                      },
                                      height: AppSize.width(value: 32),
                                      width: AppSize.width(value: 88),
                                      title: "Add Card",
                                    );
                                  }),
                              ],
                            ),
                          ],
                        ),
                        Gap(height: AppSize.width(value: 16)),

                        /// Tier Info
                        Row(
                          children: [
                            AppImageCircular(
                              width: AppSize.width(value: 34),
                              path: AssetsPath.icPoint,
                            ),
                            Gap(width: AppSize.width(value: 12)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  data:
                                  "Your Tier: ${controller.merchantTiar.value?.tierName ?? "Not set"}",
                                  fontSize: AppSize.width(value: 14),
                                  color: color.text2,
                                ),
                                Gap(height: 8),
                                AppText(
                                  data:
                                  "Points: ${controller.merchantTiar.value?.availablePoints?.toStringAsFixed(2) ?? 0}",
                                  fontSize: AppSize.width(value: 18),
                                  fontWeight: FontWeight.w700,
                                  color: color.text2,
                                ),
                              ],
                            ),
                          ],
                        ),

                        Gap(height: AppSize.width(value: 16)),

                        /// About Us
                        AppText(
                          data: "About Us",
                          fontSize: AppSize.width(value: 18),
                          fontWeight: FontWeight.w600,
                          color: color.text2,
                        ),
                        Gap(height: 8),
                        AppText(
                          data:
                          controller
                              .merchantDetails
                              .value
                              ?.merchant
                              ?.about ??
                              "",
                          fontSize: AppSize.width(value: 12),
                          height: 1.7,
                          color: color.text2,
                        ),

                        Gap(height: AppSize.width(value: 20)),

                        /// Promotions
                        if (controller
                            .merchantDetails
                            .value
                            ?.promotions
                            .isNotEmpty ??
                            false)
                          AppText(
                            data: "Available Special Promotions",
                            fontSize: AppSize.width(value: 18),
                            fontWeight: FontWeight.w700,
                            color: color.text2,
                          ),

                        Gap(height: 12),

                        if (controller
                            .merchantDetails
                            .value
                            ?.promotions
                            .isNotEmpty ??
                            false)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller
                                .merchantDetails
                                .value
                                ?.promotions
                                .length,
                            itemBuilder: (context, index) {
                              final promotion = controller
                                  .merchantDetails
                                  .value
                                  ?.promotions[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Obx(() {
                                  return PostDetailsItemCard(
                                    show: promotion?.buy ?? false,
                                    isLoading:
                                    controller.loadingPromotionId.value ==
                                        promotion?.id,
                                    promotion: Promotion(
                                      id: promotion?.id,
                                      name: promotion?.name,
                                      image: promotion?.image,
                                      promotionType: promotion?.promotionType,
                                      startDate: promotion?.startDate,
                                      endDate: promotion?.endDate,
                                      discountPercentage:
                                      promotion?.discountPercentage,
                                    ),

                                    onTap: () {
                                      controller.addPromotionToWallet(
                                        promotionId: promotion?.id ?? "",
                                      );
                                    },
                                  );
                                }),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}

class PostDetailsItemCard extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDetails;
  final Promotion? promotion;
  final bool isLoading;
  final bool show;
  const PostDetailsItemCard({
    super.key,
    this.onTap,
    this.promotion,
    this.onTapDetails,
    this.isLoading = false,
    this.show = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapDetails,
      child: Container(
        width: AppSize.size.width * double.infinity,
        height: AppSize.size.height * 0.31,
        decoration: BoxDecoration(
          color: AppColor.cart1Light,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.button1Dark.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: AppImage(
                fit: BoxFit.cover,
                url: promotion?.image ?? "",
                width: double.infinity,
                height: AppSize.height(value: 150),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 8),
                vertical: AppSize.width(value: 4),
              ),
              child: Column(
                spacing: AppSize.width(value: 4),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        data: promotion?.name ?? "",
                        fontSize: AppSize.width(value: 18),
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      Spacer(),
                      AppImage(
                        path: AssetsPath.qrCodeImg,
                        width: AppSize.width(value: 24),
                      ),
                    ],
                  ),
                  AppText(
                    data: "${promotion?.discountPercentage ?? ""} % OFF",
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  AppText(
                    data:
                    "Expire On ${dateFormetterForPromotion(promotion?.endDate)}",
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  if (!show)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: isLoading
                          ? Padding(
                        padding: EdgeInsets.only(
                          right: AppSize.width(value: 12.0),
                        ),
                        child: CircularProgressIndicator(),
                      )
                          : AppButton(
                        onTap: onTap,
                        height: AppSize.width(value: 32),
                        width: AppSize.width(value: 135),
                        title: "Add To Wallet",
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}