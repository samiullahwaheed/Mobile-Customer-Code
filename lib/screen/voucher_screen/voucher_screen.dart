import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/voucher_screen/controller/voucher_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/utils/date_formetter_for_promotion.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<VoucherController>(
      init: VoucherController(),
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              Stack(
                children: [
                  AppImage(
                    url:
                    AppApiEndPoint.mediaUrl(controller.promotion?.promotion?.image),
                    width: AppSize.width(value: double.infinity),
                    height: AppSize.size.height * 0.2,
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
                            color: AppColor.button2Dark.withValues(alpha: 0.4),
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
                  spacing: AppSize.width(value: 4),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          data: "${controller.promotion?.promotion?.name}",
                          fontSize: AppSize.width(value: 18),
                          fontWeight: FontWeight.w700,
                          color: appThemeColor.text2,
                        ),
                        Spacer(),
                        AppImage(
                          path: AssetsPath.giftCardIcon,
                          width: AppSize.width(value: 24),
                          iconColor: appThemeColor.text2,
                        ),
                      ],
                    ),
                    AppText(
                      data: "Card ID: ${controller.promotion?.promoCode}",
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w500,
                      color: appThemeColor.text2,
                    ),
                    AppText(
                      data:
                      "${controller.promotion?.promotion?.discountPercentage} % OFF",
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w500,
                      color: appThemeColor.text2,
                    ),
                    AppText(
                      data:
                      "Expire On ${dateFormetterForPromotion(controller.promotion?.promotion?.endDate)}",
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w500,
                      color: appThemeColor.text2,
                    ),
                    Gap(height: AppSize.size.height * 0.2),

                    Center(
                      child: Container(
                        padding: EdgeInsets.all(AppSize.width(value: 12)),
                        decoration: BoxDecoration(
                          color: AppColor.surfacePrimaryLight,
                          borderRadius: BorderRadius.circular(
                            AppSize.width(value: 12),
                          ),
                        ),
                        child: Container(
                          width: AppSize.width(value: 220),
                          height: AppSize.height(value: 220),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSize.width(value: 12),
                            ),
                            color: Colors.white,
                          ),
                          child: SfBarcodeGenerator(
                            value:
                            controller.promotion?.promoCode ?? "",
                            symbology: QRCode(),
                          ),
                        ),
                      ),
                    ),
                    // Center(
                    //   child: AppImage(
                    //     path: AssetsPath.qrCodeImg,
                    //     iconColor: appThemeColor.text2,
                    //   ),
                    // ),
                  ],
                ),
              ),

            ],
          ),
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