import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/promo_and_reward_screen/widgets/shimmer/reffer_friend_card_shimmer.dart';
import 'package:loyalty_customer/screen/promo_and_reward_screen/widgets/shimmer/rewards_summary_shimmer.dart';
import 'package:loyalty_customer/screen/reffer_friend_list_screen/controller/reffer_friend_list_controller.dart';
import 'package:loyalty_customer/screen/reffer_friend_list_screen/model/referral_summary_model.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class RefferFriendListScreen extends StatelessWidget {
  const RefferFriendListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<RefferFriendListController>(
      init: RefferFriendListController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            text: "Refer Friends",
            appThemeColor: appThemeColor,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: appThemeColor.text2,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: appThemeColor.surfacePrimary,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 16),
                vertical: AppSize.width(value: 24),
              ),
              child: AppButton(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.instance.refferFriendScreen,
                    arguments:
                    controller.referralSummaryData.value?.myReferenceId,
                  );
                },
                borderRadius: BorderRadius.circular(24),
                title: "Refer Friend",
                filColor: appThemeColor.icon,
                titleColor: appThemeColor.text1,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                spacing: AppSize.size.height * 0.01,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (controller.isLoading.value) {
                      return RewardsSummaryShimmer();
                    }

                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: appThemeColor.text2),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        spacing: AppSize.size.height * 0.01,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            data: "Your Rewards",
                            fontSize: AppSize.width(value: 14),
                            fontWeight: FontWeight.w400,
                            color: appThemeColor.text2,
                          ),
                          AppText(
                            data:
                            "Current Balance : ${controller.referralSummaryData.value?.totalPoints}",
                            fontSize: AppSize.width(value: 18),
                            fontWeight: FontWeight.w700,
                            color: appThemeColor.text2,
                          ),
                          AppText(
                            data:
                            "Total Referrals : ${controller.referralSummaryData.value?.totalReferrals}",
                            fontSize: AppSize.width(value: 14),
                            fontWeight: FontWeight.w400,
                            color: appThemeColor.text2,
                          ),
                          AppText(
                            data:
                            "Total Join : ${controller.referralSummaryData.value?.totalJoin}",
                            fontSize: AppSize.width(value: 14),
                            fontWeight: FontWeight.w400,
                            color: appThemeColor.text2,
                          ),
                        ],
                      ),
                    );
                  }),

                  Obx(() {
                    return controller
                        .referralSummaryData
                        .value
                        ?.referrals
                        .isNotEmpty ??
                        false
                        ? AppText(
                      data: "Refer Friends List",
                      fontSize: AppSize.width(value: 18),
                      fontWeight: FontWeight.w700,
                      color: appThemeColor.text2,
                    )
                        : AppText(
                      data: "No Referral Found",
                      fontSize: AppSize.width(value: 18),
                      fontWeight: FontWeight.w700,
                      color: appThemeColor.text2,
                    );
                  }),

                  Obx(() {
                    if (controller.isLoading.value) {
                      // Show shimmer while loading
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5, // Show 5 shimmer items
                        itemBuilder: (context, index) {
                          return RefferFriendCardShimmer();
                        },
                      );
                    } else if (controller
                        .referralSummaryData
                        .value
                        ?.referrals
                        .isNotEmpty ??
                        false) {
                      // Show actual data
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                        controller
                            .referralSummaryData
                            .value
                            ?.referrals
                            .length ??
                            0,
                        itemBuilder: (context, index) {
                          final referral = controller
                              .referralSummaryData
                              .value
                              ?.referrals[index];
                          return RefferFriendCard(
                            appThemeColor: appThemeColor,
                            referral: referral,
                          );
                        },
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RefferFriendCard extends StatelessWidget {
  final ReferralItem? referral;
  const RefferFriendCard({
    super.key,
    required this.appThemeColor,
    this.referral,
  });

  final AppThemeColor appThemeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.width(value: 8)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
          border: Border.all(
            color: AppColor.button1Dark.withValues(alpha: 0.2),
          ),
          color: appThemeColor.button3,
        ),
        padding: EdgeInsets.all(AppSize.width(value: 16)),
        child: Row(
          spacing: AppSize.width(value: 12),
          children: [
            AppImageCircular(
              url: AppApiEndPoint.mediaUrl(referral?.user?.profile),
              width: AppSize.width(value: 56),
              height: AppSize.width(value: 56),
            ),
            Expanded(
              child: Column(
                spacing: AppSize.width(value: 12),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data: referral?.user?.firstName ?? "",
                    fontSize: AppSize.width(value: 18),
                    fontWeight: FontWeight.w700,
                    color: AppColor.text4Light,
                  ),

                  SizedBox(
                    width: AppSize.size.width * 0.38,
                    child: AppText(
                      data: "${referral?.user?.address} | 2.6 km",
                      fontSize: AppSize.width(value: 12),
                      fontWeight: FontWeight.w400,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.text4Light,
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            Column(
              spacing: AppSize.width(value: 4),
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  data: "+${referral?.pointsEarned}",
                  textAlign: TextAlign.end,
                  fontSize: AppSize.width(value: 18),
                  fontWeight: FontWeight.w700,
                  color: AppColor.text4Light,
                ),

                AppText(
                  data: referral?.user?.status ?? "none",
                  fontSize: AppSize.width(value: 16),
                  fontWeight: FontWeight.w600,
                  color: referral?.user?.status == "active"
                      ? Colors.green
                      : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer widget for loading state