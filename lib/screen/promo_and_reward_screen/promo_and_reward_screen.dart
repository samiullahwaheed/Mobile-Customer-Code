import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/screen/promo_and_reward_screen/controller/promo_and_reward_controller.dart';
import 'package:loyalty_customer/screen/show_details_screen/show_details_screen.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_shimmer/home_card_shimmer.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class PromoAndRewardScreen extends StatelessWidget {
  const PromoAndRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme data
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;
    return GetBuilder<PromoAndRewardController>(
      init: PromoAndRewardController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(text: "Promo & Rewards", appThemeColor: color),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: RefreshIndicator(
              onRefresh: () async {
                controller.reset();
              },
              child: Obx(() {
                // যদি প্রথমবার load হচ্ছে এবং list empty থাকে
                if (controller.isLoading.value) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const HomeCardShimmer();
                    },
                  );
                }

                // যদি list empty হয় এবং loading শেষ হয়ে যায়
                if (controller.promotionList.isEmpty) {
                  return Center(child: AppText(data: "No Promotion available"));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: controller.promotionList.length,
                  itemBuilder: (context, index) {
                    var item = controller.promotionList[index];
                    return Obx(() {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSize.width(value: 12),
                        ),
                        child: PostDetailsItemCard(
                          show: item.source == "admin" ? true : false,
                          isLoading:
                              controller.loadingPromotionId.value != null &&
                              controller.loadingPromotionId.value == item.id,
                          promotion: item,
                          onTap: () {
                            controller.addPromotionToWallet(
                              promotionId: item.id ?? "",
                            );
                          },
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
