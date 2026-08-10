import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'controller/prefferance_controller.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrefferanceController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.surfacePrimaryLight,
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: AppButton(
                onTap: () {
                  controller.updatePreferences();
                },
                title: "Continue",
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    data: "Select Your Preferences",
                    fontSize: AppSize.width(value: 30),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  AppText(
                    data:
                        "Choose your preferred types of services or products to personalize your experience.",
                    fontSize: AppSize.width(value: 16),
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.90,
                          ),
                      itemCount: controller.items.length,
                      itemBuilder: (context, index) {
                        final item = controller.items[index];

                        return Obx(
                          () => PreffranceCard(
                            title: item.title,
                            imageUrl: item.imageUrl,
                            index: index,
                            isSelected: controller.isSelected(index),
                            onTap: () => controller.toggleIndex(index),
                            onCheckboxChanged: (val) =>
                                controller.toggleIndex(index),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PreffranceCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;

  const PreffranceCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSize.size.width * 0.5, // Half of the screen width
        height: AppSize.size.height * 0.25,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.button1Dark.withValues(alpha: 0.08)
              : AppColor.cart1Light,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColor.button1Dark
                : AppColor.button1Dark.withValues(alpha: 0.1),
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
                url: imageUrl,
                width: double.infinity,
                height: AppSize.height(
                  value: 150,
                ), // This will make the image take up 2/3 of the container height
              ),
            ),
            // Text widget below the image
            Row(
              spacing: AppSize.width(value: 4),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onCheckboxChanged,
                  ),
                ),
                // Text title next to the radio button
                Expanded(
                  child: AppText(
                    data: title,
                    maxLines: 2,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
