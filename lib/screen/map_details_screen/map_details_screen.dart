import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/app_theme_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/home_screen/model/near_by_merchent_model.dart';
import 'package:loyalty_customer/screen/map_details_screen/controller/map_details_controller.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_image/app_image_circular.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_log/gap.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

class MapDetailsScreen extends StatelessWidget {
  const MapDetailsScreen({super.key});

  static String _addressWithDistance(
    MapDetailsController controller,
    NearByMerchentModelData merchant,
  ) {
    final address = merchant.address ?? "Location not found";
    final dist = controller.formattedDistanceKm(merchant);
    if (dist.isEmpty) return address;
    return "$address · ($dist)";
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeColor color = Theme.of(context).extension<AppThemeColor>()!;

    return GetBuilder<MapDetailsController>(
      init: MapDetailsController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              // Google Map
              Obx(() {
                if (controller.initialCameraPosition.value == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition:
                      controller.initialCameraPosition.value!,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: controller.markers.value,
                  onMapCreated: (GoogleMapController mapController) {
                    if (!controller.controller.isCompleted) {
                      controller.controller.complete(mapController);
                    }
                  },
                );
              }),

              // My location (above zoom) + custom zoom — stacked bottom-right
              Obx(() {
                if (controller.initialCameraPosition.value == null) {
                  return const SizedBox.shrink();
                }
                final bottomInset =
                    MediaQuery.of(context).padding.bottom +
                    AppSize.width(value: 48);
                return Positioned(
                  right: AppSize.width(value: 12),
                  bottom: bottomInset,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MapCircleIconButton(
                        icon: Icons.my_location_rounded,
                        backgroundColor: color.text1,
                        iconColor: color.icon,
                        onTap: () => controller.recenterOnUserLocation(),
                      ),
                      Gap(height: AppSize.width(value: 8)),
                      _MapCircleIconButton(
                        icon: Icons.add_rounded,
                        backgroundColor: color.text1,
                        iconColor: color.text2,
                        onTap: () => controller.zoomIn(),
                      ),
                      Gap(height: AppSize.width(value: 4)),
                      _MapCircleIconButton(
                        icon: Icons.remove_rounded,
                        backgroundColor: color.text1,
                        iconColor: color.text2,
                        onTap: () => controller.zoomOut(),
                      ),
                    ],
                  ),
                );
              }),

              // Back Button
              Positioned(
                top: AppSize.size.height * 0.05,
                left: 16,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.text1,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: color.text2,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Sheet with Merchant Details
          bottomNavigationBar: Obx(() {
            final merchant = controller.selectedMerchant.value;

            if (merchant == null) {
              return Container(
                decoration: BoxDecoration(
                  color: color.text1,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.all(AppSize.width(value: 16)),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        data: "Tap on a marker to view merchant details",
                        fontSize: AppSize.width(value: 14),
                        fontWeight: FontWeight.w500,
                        color: color.text2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: color.text1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(AppSize.width(value: 16)),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSize.width(value: 12),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: color.text2.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Gap(height: AppSize.width(value: 8)),

                    // Merchant Info with Image
                    Row(
                      children: [
                        AppImageCircular(
                          width: AppSize.width(value: 60),
                          height: AppSize.width(value: 60),
                          url: controller.getMerchantImageUrl(merchant),
                        ),
                        Gap(width: AppSize.width(value: 12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                // data: merchant.id ?? "Merchant",
                                data: merchant.firstName ?? "Merchant",
                                fontSize: AppSize.width(value: 18),
                                fontWeight: FontWeight.w700,
                                color: color.text2,
                              ),
                              Gap(height: AppSize.width(value: 4)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Gap(width: AppSize.width(value: 4)),
                                  AppText(
                                    data:
                                        "${merchant.avgRating?.toStringAsFixed(1) ?? "0.0"} ",
                                    fontSize: AppSize.width(value: 12),
                                    fontWeight: FontWeight.w400,
                                    color: color.text2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Location Info
                    Row(
                      children: [
                        AppImage(
                          path: AssetsPath.icLocationIcon,
                          iconColor: color.icon,
                          width: AppSize.width(value: 16),
                        ),
                        Gap(width: AppSize.width(value: 8)),
                        Expanded(
                          child: AppText(
                            data: _addressWithDistance(controller, merchant),
                            fontSize: AppSize.width(value: 12),
                            fontWeight: FontWeight.w400,
                            // color: color.text2,
                            color: AppColor.button4Dark,
                          ),
                        ),
                      ],
                    ),

                    // Action Button
                    AppButton(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.instance.showDetailsScreen,
                          arguments: merchant.id,
                        );
                        AppPrint.apiResponse(merchant.id);
                      },
                      borderRadius: BorderRadius.circular(30),
                      title: "View Details",
                      filColor: color.icon,
                      titleColor: color.text1,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _MapCircleIconButton extends StatelessWidget {
  const _MapCircleIconButton({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: onTap,
        radius: 28,
        child: Container(
          width: AppSize.width(value: 46),
          height: AppSize.width(value: 46),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(
              color: Colors.white.withOpacity(0.15), // subtle glass border
              width: 1,
            ),
            boxShadow: [
              // soft outer shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              // light top highlight (depth feel)
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Center(
            child: AnimatedScale(
              duration: const Duration(milliseconds: 120),
              scale: 1.0,
              child: Icon(icon, color: iconColor, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
