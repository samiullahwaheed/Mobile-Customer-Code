import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/profile_section/chnage_profile_info/controller/chnage_profile_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_input/app_input_widget_two.dart';
import 'package:loyalty_customer/widget/app_input/country_city_dropdown.dart';
import 'package:loyalty_customer/widget/app_location_field/places_suggation.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';
import 'package:loyalty_customer/widget/appbar/custom_appbar.dart';

class ChnageProfileScreen extends StatelessWidget {
  const ChnageProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColor appThemeColor = Theme.of(
      context,
    ).extension<AppThemeColor>()!;
    return GetBuilder<ChnageProfileController>(
      init: ChnageProfileController(),

      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppbar(
            text: "Change Profile Information",
            appThemeColor: appThemeColor,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  return Stack(
                    children: [
                      Container(
                        width: AppSize.size.width * 0.30,
                        height: AppSize.size.height * 0.135,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: appThemeColor.button,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            child: controller.cameraImage.value.isNotEmpty
                                ? AppImageCircular(
                              filePath: controller.cameraImage.value,
                            )
                                : AppImageCircular(
                              borderColor: appThemeColor.icon,
                              url:
                              AppApiEndPoint.mediaUrl(controller.profileController.profileData.value?.profile),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            AppPrint.appPrint("Camera Clicked");
                            controller.getImage(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: appThemeColor.stroke2),
                              borderRadius: BorderRadius.circular(
                                AppSize.width(value: 24),
                              ),
                              color: appThemeColor.surfacePrimary,
                            ),
                            padding: EdgeInsets.all(AppSize.width(value: 8)),
                            child: AppImage(
                              path: AssetsPath.icCamera,
                              iconColor: appThemeColor.icon,
                              width: AppSize.width(value: 18),
                              height: AppSize.width(value: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Padding(
                  padding: EdgeInsets.all(AppSize.width(value: 16)),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: .1,
                          ), // Shadow color
                          offset: Offset(
                            0,
                            2,
                          ), // Vertical offset, giving shadow on bottom
                          blurRadius: 8, // Blur radius
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: .1,
                          ), // Shadow color
                          offset: Offset(
                            0,
                            -2,
                          ), // Vertical offset, giving shadow on top
                          blurRadius: 8, // Blur radius
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                        AppSize.width(value: 12),
                      ),
                      color: AppColor.surfacePrimaryLight,
                    ),
                    padding: EdgeInsets.all(AppSize.width(value: 20)),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSize.size.height * 0.01,
                          children: [
                            AppInputWidgetTwo(
                              controller: controller.nameController,
                              isOptional: true,
                              title: "Full Name",
                              hintText: "Enter NAme",
                            ),

                            AppText(
                              data: "Email",
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                              color: appThemeColor.text2,
                            ),
                            GestureDetector(
                              onTap: () {
                                AppSnackBar.message("Email Not Editible");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  border: Border.all(
                                    color: appThemeColor.stroke2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSize.width(value: 12),
                                  ),
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  AppSize.width(value: 16),
                                ),
                                child: AppText(
                                  data:
                                  controller
                                      .profileController
                                      .profileData
                                      .value
                                      ?.email ??
                                      '',
                                  fontSize: AppSize.width(value: 16),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                            AppText(
                              data: "Phone Number",
                              fontSize: AppSize.width(value: 16),
                              fontWeight: FontWeight.w600,
                              color: appThemeColor.text2,
                            ),
                            GestureDetector(
                              onTap: () {
                                AppSnackBar.message(
                                  "Phone Number Not Editible",
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  border: Border.all(
                                    color: appThemeColor.stroke2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSize.width(value: 12),
                                  ),
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  AppSize.width(value: 16),
                                ),
                                child: AppText(
                                  data:
                                  controller
                                      .profileController
                                      .profileData
                                      .value
                                      ?.phone ??
                                      '',
                                  fontSize: AppSize.width(value: 16),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                            //--------------Address section----------------
                            AppText(
                              data: "Address",
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: AppColor.button1Dark,
                            ),
                            Obx(
                                  () => PlaceAutocompleteWidget(
                                borderColor: AppColor.button1Dark,
                                contentPadding: EdgeInsets.all(
                                  AppSize.height(value: 14),
                                ),
                                hintColor: AppColor.button1Dark.withValues(
                                  alpha: 0.4,
                                ),
                                textColor: AppColor.button1Dark,
                                borderRadius: AppSize.width(value: 12),
                                controller: controller
                                    .locationController
                                    .searchController,
                                hintText:
                                controller.userAddress.value.isNotEmpty
                                    ? controller.userAddress.value
                                    : "Enter Address",
                                borderWidth: 0.9,
                                showCurrentLocation: true,
                                currentLocationAddress:
                                controller.userAddress.value.isNotEmpty
                                    ? controller.userAddress.value
                                    : null,
                                currentLocationLat:
                                controller.selectedLatitude.value != 0.0
                                    ? controller.selectedLatitude.value
                                    : null,
                                currentLocationLng:
                                controller.selectedLongitude.value != 0.0
                                    ? controller.selectedLongitude.value
                                    : null,
                                onPlaceSelected:
                                    (
                                    placeId,
                                    description, {
                                  isCurrentLocation = false,
                                  lat,
                                  lng,
                                }) {
                                  // Update location in both controllers
                                  if (lat != null && lng != null) {
                                    controller.updateLocation(
                                      lat,
                                      lng,
                                      description,
                                    );
                                    controller.locationController
                                        .onPlaceSelected(
                                      placeId,
                                      description,
                                      isCurrentLocation:
                                      isCurrentLocation,
                                      lat: lat,
                                      lng: lng,
                                    );
                                  }
                                },
                              ),
                            ),

                            CountryCityDropdown(
                              initialCountry:
                              controller
                                  .profileController
                                  .profileData
                                  .value
                                  ?.country ??
                                  "",
                              initialCity:
                              controller
                                  .profileController
                                  .profileData
                                  .value
                                  ?.city ??
                                  "",
                              fillColor: Colors.white,
                              textColor: Colors.black,
                              borderColor: Colors.black,
                              borderRadius: AppSize.width(value: 12),
                              height: AppSize.height(value: 56),
                              width: double.infinity,

                              onCountryChanged: (country) {
                                controller.countryController.text =
                                    country ?? "";
                              },
                              onCityChanged: (city) {
                                controller.cityController.text = city ?? "";
                              },
                            ),
                          ],
                        ),
                        if (controller.isLoading.value)
                          Positioned.fill(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(value: 16),
                vertical: AppSize.width(value: 20),
              ),
              child: AppButton(
                onTap: () {
                  controller.updateProfile();
                },
                filColor: appThemeColor.icon,
                titleColor: appThemeColor.text3,
                title: "Save",
                titleSize: AppSize.width(value: 18),
                borderRadius: BorderRadius.circular(AppSize.width(value: 24)),
              ),
            ),
          ),
        );
      },
    );
  }
}