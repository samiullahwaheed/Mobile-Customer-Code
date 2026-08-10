import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/home_screen/controller/specific_service_controller.dart';
import 'package:loyalty_customer/screen/show_details_screen/show_details_screen.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class SpecificServiceScreen extends StatelessWidget {
  const SpecificServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;
    return GetBuilder<SpecificServiceController>(
      init: SpecificServiceController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            text: controller.categoryName.isNotEmpty
                ? controller.categoryName
                : "No Data Found",
            appThemeColor: color,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              // যদি list empty হয় এবং loading শেষ হয়ে যায়
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.specificPromotionList.isEmpty) {
                return Center(child: AppText(data: "No Promotion available"));
              }

              return ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: controller.specificPromotionList.length,
                      itemBuilder: (context, index) {
                        var item = controller.specificPromotionList[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: AppSize.width(value: 12),
                          ),
                          child: Obx(() {
                            return PostDetailsItemCard(
                              isLoading:
                                  controller.loadingPromotionId.value != null &&
                                  controller.loadingPromotionId.value ==
                                      item.id,
                              promotion: item,
                              onTapDetails: () {
                                Get.toNamed(
                                  AppRoutes.instance.singlePromoAndRewardScreen,
                                  arguments: item,
                                );
                              },
                              onTap: () {
                                controller.addPromotionToWallet(
                                  promotionId: item.id ?? "",
                                );
                              },
                            );
                          }),
                        );
                      },
                    );
            }),
          ),
        );
      },
    );
  }
}
