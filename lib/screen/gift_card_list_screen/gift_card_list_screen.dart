import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/controller/gift_card_list_controller.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/widget/gift_list_item_card.dart';
import 'package:loyalty_customer/screen/gift_card_list_screen/widget/shimmer/gift_list_item_card_shimmer.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class GiftCardListScreen extends StatelessWidget {
  const GiftCardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;
    return GetBuilder<GiftCardListController>(
      init: GiftCardListController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomAppbar(
            text: "My Gift Card",
            appThemeColor: color,
            // action: [Icon(Icons.more_vert_outlined, color: color.text2)],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              spacing: AppSize.size.height * 0.015,
              children: [
                TextFormField(
                  controller: controller.searchController,
                  onChanged: controller.onSearchChanged,
                  style: TextStyle(color: color.text2),
                  cursorColor: color.text2,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: color.text2.withValues(alpha: 0.5),
                    hintText: 'Search',

                    hintStyle: TextStyle(
                      color: color.text2.withValues(alpha: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: color.icon, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: color.icon, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 10.0,
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => controller.reloadPage(),
                    child: Obx(() {
                      // If loading for the first time and list is empty
                      if (controller.isLoading.value &&
                          controller.myGiftCardList.isEmpty) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const GiftListItemCardShimmer();
                          },
                        );
                      }

                      // If list is empty and loading is finished
                      if (controller.myGiftCardList.isEmpty &&
                          !controller.isLoading.value) {
                        return Center(
                          child: Text(
                            "No Gift Card Found",
                            style: TextStyle(
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                              color: color.text2,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: controller.scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.myGiftCardList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < controller.myGiftCardList.length) {
                            final myGiftCard = controller.myGiftCardList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: GiftListItemCard(myGiftCard: myGiftCard),
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
                                    "No more gift cards",
                                    style: TextStyle(
                                      fontSize: AppSize.width(value: 16),
                                      fontWeight: FontWeight.w600,
                                      color: color.text2,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
