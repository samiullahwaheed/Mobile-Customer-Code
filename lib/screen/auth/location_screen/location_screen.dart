import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/screen/auth/location_screen/controller/location_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_location_field/places_suggation.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.surfacePrimaryLight,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    AppImage(path: AssetsPath.backgroundImage),

                    Positioned(
                      top: AppSize.size.height * 0.07,
                      left: 0,
                      right: 0, // Ensure that it's horizontally centered
                      child: Center(
                        // Center the text horizontally
                        child: AppImage(
                          width: AppSize.width(value: 230),
                          height: AppSize.width(value: 230),
                          path: AssetsPath.authImg4,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(height: AppSize.width(value: 12)),

                AppText(
                  data: "Use Current Location",
                  fontSize: AppSize.width(value: 30),
                  fontWeight: FontWeight.w700,
                  color: AppColor.button4Dark,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.width(value: 12),
                    horizontal: AppSize.width(value: 40),
                  ),
                  child: AppText(
                    data:
                        "Enter your location or allow access to your location to find shop near you.",
                    textAlign: TextAlign.center,
                    fontSize: AppSize.width(value: 16),
                    fontWeight: FontWeight.w400,
                    color: AppColor.button4Dark,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSize.width(value: 12)),

                  child: Column(
                    spacing: AppSize.size.height * 0.01,
                    children: [
                      Obx(() {
                        return controller.isLoading.value
                            ? CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () async {
                                  await controller.fetchUserLocation();
                                },
                                child: Container(
                                  width: AppSize.width(value: double.infinity),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      width: 1.5,
                                      color: AppColor.button5Dark,
                                    ),

                                    color: AppColor.button5Light.withValues(
                                      alpha: .3,
                                    ),
                                  ),
                                  child: Center(
                                    child: AppText(
                                      data: "Use Current Location",
                                      fontSize: AppSize.width(value: 12),
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.button2Light,
                                    ),
                                  ),
                                ),
                              );
                      }),
                      Obx(
                        () => PlaceAutocompleteWidget(
                          controller: controller.searchController,
                          hintText: 'Enter location',
                          hintColor: AppColor.button2Light.withValues(
                            alpha: 0.5,
                          ),
                          borderWidth: 0.9,
                          borderRadius: 30,
                          borderColor: AppColor.button1Dark,
                          textColor: AppColor.button1Dark,
                          showCurrentLocation: controller.hasLocationData,
                          currentLocationAddress:
                              controller.selectedAddress.value.isNotEmpty
                              ? controller.selectedAddress.value
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
                                controller.onPlaceSelected(
                                  placeId,
                                  description,
                                  isCurrentLocation: isCurrentLocation,
                                  lat: lat,
                                  lng: lng,
                                );
                              },
                        ),
                      ),

                      Gap(height: 16),
                      Obx(() {
                        return controller.isLoadingForUpdate.value
                            ? Center(child: CircularProgressIndicator())
                            : AppButton(
                                onTap: () {
                                  controller.updateProfileData();
                                },
                                title: "Continue",
                                borderRadius: BorderRadius.circular(30),
                              );
                      }),
                    ],
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
