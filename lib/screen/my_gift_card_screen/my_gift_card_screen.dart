import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/my_gift_card_screen/controller/my_gift_card_controller.dart';
import 'package:loyalty_customer/screen/my_gift_card_screen/widgets/shimmer/tiar_shimmer.dart';
import 'package:loyalty_customer/screen/my_gift_card_screen/widgets/shimmer/trans_rating_shimmer.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_input/add_descreption_text_field.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class MyGiftCardScreen extends StatelessWidget {
  const MyGiftCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;
    return GetBuilder<MyGiftCardController>(
      init: MyGiftCardController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(text: "My Gift Card", appThemeColor: color),
          body: Padding(
            padding: EdgeInsets.all(AppSize.width(value: 16)),
            child: Column(
              spacing: AppSize.width(value: 12),
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(AppSize.width(value: 24)),
                          width: double.infinity,

                          height: AppSize.height(value: 180),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSize.width(value: 12),
                            ),
                            color: AppColor.buttonLight,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    data:
                                    "User Name : ${controller.merchantName ?? ""}",
                                    fontSize: AppSize.width(value: 12),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  Gap(height: AppSize.width(value: 6)),
                                  AppText(
                                    data:
                                    "Point Available : ${controller.point?.toStringAsFixed(2) ?? 0}",
                                    fontSize: AppSize.width(value: 12),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  Spacer(),
                                  AppText(
                                    data:
                                    "Card ID: ${controller.cardCode ?? ""}",
                                    fontSize: AppSize.width(value: 12),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ],
                              ),

                              AppImageCircular(
                                url:
                                AppApiEndPoint.mediaUrl(controller.image ?? ""),
                                width: AppSize.width(value: 34),
                                height: AppSize.width(value: 34),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(width: AppSize.width(value: 12)),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCustomPopup(
                                context: context,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    AppSize.width(value: 16),
                                  ),
                                  width: AppSize.width(value: 220),
                                  height: AppSize.height(value: 260),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      AppSize.width(value: 12),
                                    ),
                                  ),
                                  child: SfBarcodeGenerator(
                                    value: controller.cardCode ?? "",
                                    symbology: QRCode(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: AppSize.width(value: 78),
                              height: AppSize.height(value: 88),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppSize.width(value: 12),
                                ),
                                color: Colors.white,
                              ),
                              child: SfBarcodeGenerator(
                                value: controller.cardCode ?? "",
                                symbology: QRCode(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // showImageDialog(context, AssetsPath.barCodeImg);
                              showCustomPopup(
                                context: context,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    AppSize.width(value: 16),
                                  ),
                                  height: AppSize.height(value: 88),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppSize.width(value: 12),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: SfBarcodeGenerator(
                                    value: controller.cardCode ?? "",
                                  ),
                                ),
                              );
                            },
                            child: AppImage(
                              path: AssetsPath.barCodeImg,
                              iconColor: color.text2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: TiarShimmer());
                  }
                  return Container(
                    padding: EdgeInsets.all(AppSize.width(value: 16)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppSize.width(value: 12),
                      ),
                      border: Border.all(color: AppColor.button2Dark),
                    ),
                    child: Row(
                      children: [
                        AppImage(
                          path: AssetsPath.icPoint,
                          width: AppSize.width(value: 18),
                          height: AppSize.width(value: 18),
                        ),
                        Gap(width: AppSize.width(value: 16)),
                        Column(
                          spacing: AppSize.width(value: 4),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              data:
                              "Your Tier: ${controller.merchantTiar.value?.tierName ?? "No Tier"}",
                              fontSize: AppSize.width(value: 14),
                              fontWeight: FontWeight.w400,
                              color: color.text4,
                            ),
                          ],
                        ),
                        Spacer(),
                        AppText(
                          data: r"1 point = 10",
                          fontSize: AppSize.width(value: 10),
                          fontWeight: FontWeight.w400,
                          color: color.text4,
                        ),
                      ],
                    ),
                  );
                }),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSize.width(value: 12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        offset: Offset(0, -2),
                        blurRadius: 8,
                      ),
                    ],
                    color: color.button3,
                  ),
                  child: TabBar(
                    controller: controller.tabController,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'All'),
                      Tab(text: 'Earned'),
                      Tab(text: 'Used'),
                    ],
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: color.icon,
                    ),
                    labelColor: color.tabbarText,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.transparent,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
                // TabBarView with Expanded to constrain height
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      _buildTransactionList(controller, color),
                      _buildTransactionList(controller, color),
                      _buildTransactionList(controller, color),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionList(
      MyGiftCardController controller,
      AppThemeColor color,
      ) {
    return Obx(() {
      if (controller.isLoading.value) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5, // shimmer item count
          itemBuilder: (context, index) {
            return const TransRatingShimmer();
          },
        );
      }

      if (controller.transactionHistoryList.isEmpty) {
        return Center(
          child: AppText(
            data: "No transactions found",
            fontSize: AppSize.width(value: 16),
            fontWeight: FontWeight.w400,
            color: color.text4,
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.transactionHistoryList.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactionHistoryList[index];
          final isEarned = transaction.isEarn ?? false;

          return Padding(
            padding: EdgeInsets.only(top: AppSize.width(value: 8)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
                border: Border.all(
                  color: AppColor.button1Dark.withValues(alpha: 0.2),
                ),
                color: color.button3,
              ),
              padding: EdgeInsets.all(AppSize.width(value: 16)),
              child: Row(
                spacing: AppSize.width(value: 16),
                children: [
                  AppImageCircular(
                    url:
                    AppApiEndPoint.mediaUrl(transaction.merchantProfile),
                    width: AppSize.width(value: 40),
                    height: AppSize.width(value: 40),
                  ),
                  Expanded(
                    child: Column(
                      spacing: AppSize.width(value: 4),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          data: transaction.merchant ?? "Merchant",
                          fontSize: AppSize.width(value: 18),
                          fontWeight: FontWeight.w700,
                          color: AppColor.text4Light,
                        ),
                        AppText(
                          data: transaction.type ?? "",
                          fontSize: AppSize.width(value: 12),
                          fontWeight: FontWeight.w400,
                          color: AppColor.text4Light,
                        ),
                        AppText(
                          data:
                          "${transaction.date != null ? _formatDate(transaction.date!) : ""} || ${transaction.totalBill ?? 0}",
                          fontSize: AppSize.width(value: 12),
                          fontWeight: FontWeight.w400,
                          color: AppColor.text4Light,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        data: _buildPointText(transaction.points, isEarned),
                        fontSize: AppSize.width(value: 18),
                        fontWeight: FontWeight.w700,
                        color: transaction.points == 0
                            ? Colors.grey
                            : (isEarned ? Colors.green : Colors.red),
                      ),

                      Gap(height: AppSize.width(value: 16)),

                      if ((transaction.promotionId?.isNotEmpty ?? false) &&
                          transaction.type == "earn")
                        InkWell(
                          onTap: () {
                            if (transaction.rating == null ||
                                transaction.rating! > 0) {
                              AppSnackBar.message("Ratting Done");
                            } else {
                              showCustomPopup(
                                context: context,
                                child: Obx(() {
                                  return Container(
                                    height: AppSize.height(value: 420),
                                    padding: EdgeInsets.all(
                                      AppSize.width(value: 16),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        AppSize.width(value: 12),
                                      ),
                                    ),
                                    child: Column(
                                      spacing: AppSize.width(value: 8),
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: Icon(Icons.close),
                                          ),
                                        ),
                                        AppDescriptionTextField(
                                          controller:
                                          controller.commentController,
                                          title: '',
                                          hintText: "Write Your Feedback Here",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppSize.width(value: 12),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: RatingBar.builder(
                                            initialRating:
                                            controller.ratingValue.value,
                                            minRating: 0.5,
                                            allowHalfRating: true,
                                            itemSize: 34,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: AppColor.button5Light,
                                            ),
                                            onRatingUpdate: (rating) {
                                              controller.updateRating(
                                                value: rating,
                                                promotionId:
                                                transaction.promotionId ??
                                                    "",
                                                merchantId:
                                                transaction.merchantId ??
                                                    "",
                                                digitalCardId:
                                                transaction.digitalCardId ??
                                                    "",
                                              );
                                            },
                                          ),
                                        ),
                                        Gap(height: AppSize.width(value: 16)),
                                        AppButton(
                                          title: "Submit Review",
                                          onTap: () {
                                            controller.rateMerchant(
                                              digitalCardId:
                                              transaction.digitalCardId ??
                                                  "",
                                              promotionId:
                                              transaction.promotionId ?? "",
                                              merchantId:
                                              transaction.merchantId ?? "",
                                              rating:
                                              controller.ratingValue.value,
                                            );

                                            // AppPrint.apiResponse(
                                            //   "Rating: ${controller.rating.value}, DigitalCardId : ${transaction.digitalCardId} , PromotionId : ${transaction.promotionId} , MerchantId : ${transaction.merchantId} , Comment : ${controller.commentController.text}",
                                            // );
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            }
                          },
                          child: RatingBarIndicator(
                            rating: transaction.rating ?? 0.0,
                            itemBuilder: (context, index) =>
                                Icon(Icons.star, color: AppColor.button5Light),
                            itemCount: 5,
                            itemSize: 18,
                            direction: Axis.horizontal,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}

String _buildPointText(double? points, bool isEarned) {
  final value = points ?? 0;

  if (value == 0) {
    return "$value"; // kono + / - nai
  }

  if (isEarned) {
    return "+$value";
  } else {
    return "-$value";
  }
}

void showCustomPopup({
  required BuildContext context,
  required Widget child, // <-- ANY widget
  Color backgroundColor = Colors.transparent,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(backgroundColor: backgroundColor, child: child);
    },
  );
}