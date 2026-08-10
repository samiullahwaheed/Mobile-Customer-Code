import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/model/digital_card_model.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class WalletCard extends StatelessWidget {
  final DigitalCard? digitalCard;
  final VoidCallback? onTap;
  const WalletCard({super.key, this.digitalCard, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppSize.width(value: 24)),
          width: double.infinity,

          height: AppSize.height(value: 230),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
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
                    "Name : ${digitalCard?.merchantId.businessName ?? ""}",
                    fontSize: AppSize.width(value: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  Gap(height: AppSize.width(value: 10)),
                  AppText(
                    data:
                    "Point Available : ${digitalCard?.availablePoints.toString() ?? 0}",
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  Spacer(),
                  AppText(
                    data: "Card ID: ${digitalCard?.cardCode ?? ""}",
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ],
              ),

              AppImageCircular(
                url:
                AppApiEndPoint.mediaUrl(digitalCard?.merchantId.profile),
                width: AppSize.width(value: 56),
                height: AppSize.width(value: 56),
              ),
            ],
          ),
        ),
      ),
    );
  }
}