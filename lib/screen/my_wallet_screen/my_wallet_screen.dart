import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/controller/my_wallet_controller.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/widget/digital_card.dart';
import 'package:loyalty_customer/screen/my_wallet_screen/widget/shimmer/wallet_card_shimmer.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<MyWalletController>(
      init: MyWalletController(),
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppbar(
            autoShowLeading: false,
            showLeading: false,
            action: [
              // Icon(Icons.more_vert_outlined, color: appThemeColor.text2)
              PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle the selected option
                  if (value == 'My Gift Card') {
                    // Navigate to the folder or another screen
                    Get.toNamed(AppRoutes.instance.giftCardListScreen);
                  }
                  // Add more options here as needed
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'My Gift Card',
                      child: Row(
                        children: [
                          // Icon(Icons.folder, color: appThemeColor.icon),
                          SizedBox(width: 8),
                          Text('My Gift Card'),
                        ],
                      ),
                    ),
                   
                  ];
                },
                child: Icon(
                  Icons.more_vert_outlined,
                  color: appThemeColor.text2,
                ),
              ),
            ],

            text: "My Wallet",
            appThemeColor: appThemeColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: AppSize.size.height * 0.015,
              children: [
                TextFormField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                  style: TextStyle(color: appThemeColor.text2),
                  cursorColor: appThemeColor.text2,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: appThemeColor.text2.withValues(alpha: 0.5),
                    hintText: 'Search',

                    hintStyle: TextStyle(
                      color: appThemeColor.text2.withValues(alpha: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: appThemeColor.icon,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: appThemeColor.icon,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 10.0,
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     Get.toNamed(AppRoutes.instance.myGIftCardScreen);
                //   },
                //   child: AppImage(path: AssetsPath.creditCatdImg),
                // ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => controller.reloadPage(),
                    child: Obx(() {
                      // If loading for the first time and list is empty
                      if (controller.isLoading.value &&
                          controller.digitalCardList.isEmpty) {
                        return ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return const WalletCardShimmer();
                          },
                        );
                      }

                      // If list is empty and loading is finished
                      if (controller.digitalCardList.isEmpty &&
                          !controller.isLoading.value) {
                        return Center(
                          child: Text(
                            "No Digital Card Found",
                            style: TextStyle(
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                              color: appThemeColor.text2,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: controller.scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.digitalCardList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < controller.digitalCardList.length) {
                            final digitalCard =
                                controller.digitalCardList[index];
                            return WalletCard(
                              digitalCard: digitalCard,
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.instance.myGIftCardScreen,
                                  arguments: {
                                    "digitalCardId": digitalCard.id,
                                    "merchantId": digitalCard.merchantId.id,
                                    "merchantName":
                                        digitalCard.merchantId.businessName,
                                    "cardCode": digitalCard.cardCode,
                                    "image": digitalCard.merchantId.profile,
                                    "point": digitalCard.availablePoints,
                                  },
                                  // arguments: digitalCard,
                                );
                              },
                            );
                          } else {
                            if (controller.isMoreDataAvailable.value) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "No more cards",
                                    style: TextStyle(
                                      fontSize: AppSize.width(value: 16),
                                      fontWeight: FontWeight.w600,
                                      color: appThemeColor.text2,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      );
                    }),
                  ),
                ),
                // WalletCard(),
              ],
            ),
          ),
        );
      },
    );
  }
}
