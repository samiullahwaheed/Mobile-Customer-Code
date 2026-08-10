import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loyalty_customer/screen/auth/location_screen/controller/location_controller.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class ChnageProfileController extends GetxController {
  PostRepository postRepository = PostRepository.instance;

  //text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  ProfileController profileController = Get.find<ProfileController>();
  LocationController locationController = Get.put(LocationController());

  RxDouble selectedLatitude = 0.0.obs;
  RxDouble selectedLongitude = 0.0.obs;
  //loading state
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    _controllerDefultValue();
    super.onInit();
  }

  //profile update function
  void updateProfile() async {
    isLoading.value = true;
    final response = await postRepository.updateUserProfile(
      profile: cameraImage.value,
      firstName: nameController.text,
      address: userAddress.value,
      latitude: selectedLatitude.value.toString(),
      longitude: selectedLongitude.value.toString(),
      country: countryController.text,
      city: cityController.text,
    );
    profileController.fetchProfileData();
    Get.back();
    if (response) {
      AppSnackBar.success("Profile updated successfully");
    } else {
      AppSnackBar.error("Failed to update profile");
    }
    isLoading.value = false;
  }

  ///////////////////////// image ////////////////////////////////////////
  RxString cameraImage = ''.obs;

  void removeImage() {
    cameraImage.value = "";
  }

  Future<void> getImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // ---------- ANDROID FLOW ----------
    if (Platform.isAndroid) {
      Permission cameraPermission = Permission.camera;

      if (await cameraPermission.isDenied) {
        final result = await cameraPermission.request();

        if (result.isGranted) {
          _showImagePickerDialog(context, picker);
        } else if (result.isDenied) {
          return;
        } else if (result.isPermanentlyDenied) {
          _showSettingsDialog(context);
        }
      } else if (await cameraPermission.isGranted) {
        _showImagePickerDialog(context, picker);
      } else if (await cameraPermission.isPermanentlyDenied) {
        _showSettingsDialog(context);
      }
    }
    // ---------- iOS FLOW ----------
    else {
      // iOS: DO NOT REQUEST PERMISSION HERE
      // Camera open korlei iOS nijer permission popup dekhabe
      _showImagePickerDialog(context, picker);
    }
  }

  void _showImagePickerDialog(BuildContext context, ImagePicker picker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose Option".tr),
        content: Text("Select where you want to pick the image from:".tr),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // CAMERA
              final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
                imageQuality: 5,
              );

              if (image != null) {
                File file = File(image.path);
                cameraImage.value = file.path;
                AppPrint.appPrint("Image: ${cameraImage.value}");
              }
            },
            child: Text('Camera'.tr),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // GALLERY
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 5,
              );

              if (image != null) {
                File file = File(image.path);
                cameraImage.value = file.path;
                AppPrint.appPrint("Image: ${cameraImage.value}");
              }
            },
            child: Text('Gallery'.tr),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied".tr),
        content: Text(
          "Camera permission is required to take a photo. Please enable it from the app settings."
              .tr,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'.tr),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////

  void _controllerDefultValue() {
    final profile = profileController.profileData.value;
    nameController.text = profile?.firstName ?? '';
    phoneController.text = profile?.phone ?? '';
    emailController.text = profile?.email ?? '';
    countryController.text = profile?.country ?? '';
    cityController.text = profile?.city ?? '';
    // Check if user has an existing address
    if (profile?.address != null && profile!.address!.isNotEmpty) {
      userAddress.value = profile.address!;
      locationController.searchController.text = profile.address!;
      locationController.selectedAddress.value = profile.address!;

      // Attempt to retrieve lat/long if available in the profile data
      if (profile.location?.coordinates != null &&
          profile.location!.coordinates!.length >= 2) {
        // GeoJSON uses [longitude, latitude] usually, verify if reversed
        // Assuming [long, lat] based on standard usage
        selectedLongitude.value = profile.location!.coordinates![0];
        selectedLatitude.value = profile.location!.coordinates![1];

        locationController.selectedLatitude.value = selectedLatitude.value;
        locationController.selectedLongitude.value = selectedLongitude.value;
      }
    } else {
      // If no address, fetch current location
      _fetchCurrentLocation();
    }
  }

  Future<void> _fetchCurrentLocation() async {
    await locationController.fetchUserLocation();
    if (locationController.isCurrentLocation.value) {
      userAddress.value = locationController.selectedAddress.value;
      selectedLatitude.value = locationController.selectedLatitude.value;
      selectedLongitude.value = locationController.selectedLongitude.value;
    }
  }

  //---------------Location Function----------------
  RxString userAddress = ''.obs;

  

  Future<void> _initializeForm() async {
    // Wait for profile data to be available
    if (profileController.profileData.value == null) {
      await profileController.fetchProfileData();
    }
    // appInit();
  }

  // Update location when new place is selected
  void updateLocation(double lat, double lng, String address) {
    selectedLatitude.value = lat;
    selectedLongitude.value = lng;
    userAddress.value = address;
    AppPrint.appLog(
      "Location updated - Lat: $lat, Lng: $lng, Address: $address",
    );
  }
}
