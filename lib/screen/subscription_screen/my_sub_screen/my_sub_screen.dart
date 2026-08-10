import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/subscription_screen/controller/my_sub_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class MySubScreen extends StatelessWidget {
  const MySubScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final value = Get.arguments['value'];
    return GetBuilder<MySubController>(
      init: MySubController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.surfacePrimaryLight,
            title: AppText(
              data: "My Membership",
              fontSize: AppSize.width(value: 18),
              fontWeight: FontWeight.w700,
              color: AppColor.text1Dark,
            ),
            centerTitle: true,
            actions: [
              if (value != 1)
                TextButton(
                  onPressed: () {
                    controller.storageServices.completeLogout();
                  },
                  child: AppText(
                    data: "Logout",
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w600,
                    color: AppColor.text1Dark,
                  ),
                ),
            ],
            automaticallyImplyLeading: true,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AppImage(
                  path: AssetsPath.arrowBack,
                  iconColor: AppColor.text1Dark,
                  width: AppSize.width(value: 12),
                  height: AppSize.width(value: 12),
                  color: AppColor.text1Dark,
                ),
              ),
            ),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.packageList.isEmpty) {
              return const Center(
                child: AppText(data: "No packages available"),
              );
            }

            // ListView.builder builds its children lazily, i.e. outside this
            // Obx's tracking scope. Reading the subscription state here makes
            // sure the cards re-render (Choose Plan -> Claimed) as soon as a
            // payment is confirmed.
            controller.profileValue.value;
            controller.subSummaryList.value;

            return SizedBox(
              height: AppSize.size.height * 0.9,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.packageList.length,
                itemBuilder: (context, index) {
                  final package = controller.packageList[index];
                  return SizedBox(
                    width: AppSize.size.width * 0.9,
                    child: SubcriptionCard(
                      duration: package.duration,
                      title: package.title,
                      price: package.price.toString(),
                      description: package.description,
                      features: package.features,
                      // isClaimed: false,
                      isClaimed: controller.isPlanClaimed(
                        package.price,
                        package.title,
                        index,
                        packageId: package.id,
                      ),
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              color: Colors.white,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColor.buttonDark.withValues(
                                  alpha: 0.1,
                                ),
                                /* Stoke */
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColor.button5Dark),
                              ),
                              child: Column(
                                spacing: AppSize.size.height * 0.02,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Lock Icon
                                  AppImage(
                                    path: AssetsPath.paymentOption,
                                    width: AppSize.width(value: 62),
                                  ),

                                  // Title
                                  AppText(
                                    data: "Choose Payment Method",
                                    fontSize: AppSize.width(value: 20),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),

                                  AppText(
                                    textAlign: TextAlign.center,
                                    data:
                                    "Select your preferred option to complete the transaction.",
                                    fontSize: AppSize.width(value: 16),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            controller.salesRep(
                                              packageId: package.id,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: AppSize.width(
                                                value: 12,
                                              ),
                                              vertical: AppSize.width(
                                                value: 10,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppColor.buttonDark,
                                              ),
                                            ),
                                            child: Center(
                                              child: AppText(
                                                data: "Sales Agent",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gap(width: AppSize.width(value: 8)),
                                      Expanded(
                                        child: AppButton(
                                          onTap: () async {
                                            // Close bottom sheet first
                                            Get.back();

                                            // Initialize Kuickpay checkout (local payment method)
                                            await controller.paymentPackageKuickpay(
                                              packageId: package.id,
                                            );

                                            // Navigate to WebView screen once it's ready
                                            if (controller.webViewController !=
                                                null) {
                                              Get.toNamed(
                                                AppRoutes
                                                    .instance
                                                    .kuickpayCheckoutWebView,
                                              );
                                            }
                                          },
                                          height: AppSize.width(value: 42),
                                          title: "Online Payment",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          backgroundColor: Colors.white,
                          isDismissible: true,
                          enableDrag: true,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }
}

class SubcriptionCard extends StatelessWidget {
  final VoidCallback? onTap;
  final List<String>? features;
  final String? title;
  final String? price;
  final String? description;
  final String? duration;
  final bool isClaimed;
  const SubcriptionCard({
    super.key,
    this.onTap,
    this.features,
    this.title,
    this.price,
    this.description,
    this.duration,
    this.isClaimed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(AppSize.width(value: 16)),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1), // Shadow color
                  offset: Offset(
                    0,
                    2,
                  ), // Vertical offset, giving shadow on bottom
                  blurRadius: 8, // Blur radius
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1), // Shadow color
                  offset: Offset(
                    0,
                    -2,
                  ), // Vertical offset, giving shadow on top
                  blurRadius: 8, // Blur radius
                ),
              ],
              borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
              color: AppColor.surfacePrimaryLight,
            ),

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.size.height * 0.04,
                    horizontal: AppSize.size.width * 0.1,
                  ),
                  child: Column(
                    spacing: AppSize.size.height * 0.02,
                    children: [
                      AppImage(
                        width: AppSize.width(value: 40),
                        height: AppSize.width(value: 40),
                        path: AssetsPath.icGoldSub,
                      ),
                      AppText(
                        data: title ?? "No Text",
                        fontSize: AppSize.width(value: 18),
                        fontWeight: FontWeight.w700,
                        color: AppColor.buttonLight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            data: "$price / ",
                            fontSize: AppSize.width(value: 30),
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          AppText(
                            data: "$duration",
                            fontSize: AppSize.width(value: 24),
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            color: Colors.black.withValues(alpha: .5),
                          ),
                        ],
                      ),
                      AppText(
                        data: description ?? "Billed annually.",
                        fontSize: AppSize.width(value: 16),
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: features?.length ?? 0,
                        itemBuilder: (context, index) {
                          return SubWidGetRow(
                            text: features?[index] ?? "No Text",
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: AppSize.height(value: 150),
                  width: AppSize.width(value: double.infinity),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSize.width(value: 12)),
                      bottomRight: Radius.circular(AppSize.width(value: 12)),
                    ),
                    color: AppColor.cartLight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(value: 28),
                      vertical: AppSize.width(value: 44),
                    ),
                    child: isClaimed
                        ? AppButton(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(12),
                      title: "Choose Plan",
                    )
                        : AppButton(
                      filColor: AppColor.button5Dark.withValues(
                        alpha: .1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      title: "Claimed",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SubWidGetRow extends StatelessWidget {
  final String? text;
  const SubWidGetRow({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSize.width(value: 8),
      children: [
        AppImage(
          width: AppSize.width(value: 24),
          height: AppSize.width(value: 24),
          path: AssetsPath.icIndicator,
        ),
        Expanded(
          child: AppText(
            data: text ?? "No Text",
            fontSize: AppSize.width(value: 16),
            fontWeight: FontWeight.w400,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}