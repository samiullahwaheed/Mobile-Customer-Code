import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/model/my_gift_card_model.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class GiftListItemCard extends StatelessWidget {
  final PromotionElement myGiftCard;
  final String? cardId;
  const GiftListItemCard({super.key, required this.myGiftCard, this.cardId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: AppSize.size.width * double.infinity,
        height: AppSize.size.height * 0.37,
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
            // Image widget with border radius
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: AppImage(
                fit: BoxFit.cover,
                url: AppApiEndPoint.mediaUrl(myGiftCard.promotion?.image),
                width: double.infinity,
                height: AppSize.height(
                  value: 150,
                ), // This will make the image take up 2/3 of the container height
              ),
            ),
            // Text widget below the image
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
                        data: myGiftCard.promotion?.name ?? "",
                        fontSize: AppSize.width(value: 18),
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      Spacer(),
                      AppImage(
                        path: AssetsPath.giftCardIcon,
                        width: AppSize.width(value: 24),
                      ),
                    ],
                  ),

                  if (cardId != null)
                    AppText(
                      data: "Card ID: ${cardId ?? ""}",
                      fontSize: AppSize.width(value: 14),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),


                  AppText(
                    data: "Tier: ${myGiftCard.promotion?.promotionType ?? ""}",
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  AppText(
                    data:
                    "Rewards:${myGiftCard.promotion?.discountPercentage ?? 0}% Discount",
                    fontSize: AppSize.width(value: 14),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: AppButton(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Get.toNamed(AppRoutes.instance.myPointScreen);
                        Get.toNamed(
                          AppRoutes.instance.voucherScreen,
                          arguments: myGiftCard,
                        );
                      },
                      height: AppSize.width(value: 32),
                      width: AppSize.width(value: 62),
                      title: "Apply",
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