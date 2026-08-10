import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/promo_and_reward_screen/controller/single_promo_and_reward_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/utils/show_popup_image.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_formater/date_formet.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class SinglePromoAndRewardScreen extends StatelessWidget {
  const SinglePromoAndRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return Builder(
      builder: (controller) {
        return GetBuilder<SinglePromoAndRewardController>(
          init: SinglePromoAndRewardController(),
          builder: (controller) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final imageUrl = controller.promotion?.image ?? "";
                          if (imageUrl.isNotEmpty) {
                            showPopUpImage(
                              context,
                              AppApiEndPoint.mediaUrl(imageUrl),
                            );
                          }
                        },
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: AppImage(
                            // fit: BoxFit.contain,
                            url: controller.promotion?.image ?? "",
                            width: AppSize.width(value: double.infinity),
                            // height: AppSize.size.height * 0.3,
                          ),
                        ),
                      ),
                      Positioned(
                        top: AppSize.size.height * 0.04,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.button2Dark.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              child: AppImage(
                                width: AppSize.width(value: 28),
                                path: AssetsPath.arrowBack,
                                iconColor: appThemeColor.text2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(value: 8),
                      vertical: AppSize.width(value: 4),
                    ),
                    child: Column(
                      spacing: AppSize.width(value: 8),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          data: "${controller.promotion?.name}",
                          fontSize: AppSize.width(value: 18),
                          fontWeight: FontWeight.w700,
                          color: appThemeColor.text2,
                        ),
                        AppText(
                          data: "Card ID: ${controller.promotion?.cardId}",
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          color: appThemeColor.text2,
                        ),
                        AppText(
                          data:
                          "${controller.promotion?.discountPercentage} % OFF",
                          fontSize: AppSize.width(value: 14),
                          fontWeight: FontWeight.w500,
                          color: appThemeColor.text2,
                        ),
                        Row(
                          children: [
                            AppText(
                              data:
                              "Expire On ${formatDate(controller.promotion?.endDate)}",
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w500,
                              color: appThemeColor.text2,
                            ),
                          ],
                        ),

                        Gap(height: AppSize.size.height * 0.2),
                      ],
                    ),
                  ),

                  Obx(() {
                    return controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: controller.isButtonVisible ?? false
                    ? const SizedBox.shrink()
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppButton(
                    onTap: () {
                      controller.addToWallet();
                    },
                    title: "Add To Wallet",
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DetailsItemRow extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const DetailsItemRow({
    super.key,
    required this.appThemeColor,
    this.title,
    this.subTitle,
  });

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.width(value: 16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            data: title ?? "No Text",
            fontSize: AppSize.width(value: 12),
            fontWeight: FontWeight.w500,
            color: appThemeColor.text2,
          ),
          AppText(
            data: subTitle ?? "No Text",
            fontSize: AppSize.width(value: 12),
            fontWeight: FontWeight.w500,
            color: appThemeColor.text2,
          ),
        ],
      ),
    );
  }
}