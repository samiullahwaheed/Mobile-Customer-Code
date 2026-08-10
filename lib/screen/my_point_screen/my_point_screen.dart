import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/my_point_screen/widget/my_point_screen.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class MyPointScreen extends StatelessWidget {
  const MyPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return Scaffold(
      appBar: CustomAppbar(appThemeColor: appThemeColor, text: "My Point"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: AppSize.size.height * 0.01,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: appThemeColor.icon),
                borderRadius: BorderRadius.circular(AppSize.width(value: 8)),
                color: appThemeColor.cart,
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: AppSize.width(value: 8),
                children: [
                  AppImage(
                    path: AssetsPath.icSubShow,
                    width: AppSize.width(value: 34),
                  ),
                  AppText(
                    data: "Gold Membership",
                    fontSize: AppSize.width(value: 22),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            AppText(
              data: "Your Benefits",
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w700,
              color: appThemeColor.text2,
            ),

            Row(
              spacing: AppSize.width(value: 4),
              children: [
                Expanded(
                  child: MyPointCard(
                    appThemeColor: appThemeColor,
                    iconPath: AssetsPath.icShop1,
                    text1: "Shopping",
                    text2: r"1 point per $1",
                  ),
                ),
                Expanded(
                  child: MyPointCard(
                    appThemeColor: appThemeColor,
                    iconPath: AssetsPath.icGroup,
                    text1: "Refer Friends",
                    text2: r"$50",
                  ),
                ),
              ],
            ),
            Row(
              spacing: AppSize.width(value: 4),
              children: [
                Expanded(
                  child: MyPointCard(
                    appThemeColor: appThemeColor,
                    iconPath: AssetsPath.icSupport,
                    text1: "Priority Support",
                    text2: "24/7",
                  ),
                ),
                Expanded(
                  child: MyPointCard(
                    appThemeColor: appThemeColor,
                    iconPath: AssetsPath.icCertificate,
                    text1: "Special Offers",
                  ),
                ),
              ],
            ),
            AppText(
              data: "Recent Activity",
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w700,
              color: appThemeColor.text2,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 2, // Replace with your list of all transactions
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: AppSize.width(value: 8)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppSize.width(value: 12),
                        ),
                        border: Border.all(
                          color: AppColor.button1Dark.withValues(alpha: 0.2),
                        ),
                        color: appThemeColor.button3,
                      ),
                      padding: EdgeInsets.all(AppSize.width(value: 16)),
                      child: Row(
                        spacing: AppSize.width(value: 16),
                        children: [
                          AppImage(
                            path: AssetsPath.icMacdonal,
                            width: AppSize.width(value: 40),
                            height: AppSize.width(value: 40),
                          ),
                          Column(
                            spacing: AppSize.width(value: 4),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                data: "McDonald",
                                fontSize: AppSize.width(value: 18),
                                fontWeight: FontWeight.w700,
                                color: AppColor.text4Light,
                              ),
                              AppText(
                                data: "New Work | 2.6 km",
                                fontSize: AppSize.width(value: 12),
                                fontWeight: FontWeight.w400,
                                color: AppColor.text4Light,
                              ),
                              AppText(
                                data: r"May 15, 2023 $4.50",
                                fontSize: AppSize.width(value: 12),
                                fontWeight: FontWeight.w400,
                                color: AppColor.text4Light,
                              ),
                            ],
                          ),
                          Spacer(),
                          AppText(
                            data: "+45",
                            fontSize: AppSize.width(value: 18),
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


