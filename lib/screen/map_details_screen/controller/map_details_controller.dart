// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:flutter/widgets.dart' show UniqueKey;
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/screen/home_screen/model/near_by_merchent_model.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/controller/profile_controller.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/model/profile_model.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';

class MapDetailsController extends GetxController {
  final Completer<GoogleMapController> controller =
  Completer<GoogleMapController>();

  final Rx<Set<Marker>> markers = Rx<Set<Marker>>({});
  Rxn<NearByMerchentModelData> selectedMerchant =
  Rxn<NearByMerchentModelData>();
  Rxn<CameraPosition> initialCameraPosition = Rxn<CameraPosition>();

  List<NearByMerchentModelData> merchantList = [];
  late final ProfileController profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null &&
        Get.arguments is List<NearByMerchentModelData>) {
      merchantList = Get.arguments as List<NearByMerchentModelData>;
    }
    AppPrint.appPrint(
      "merchantList: ${merchantList.length}",
      title: "MapDetailsController",
    );
    _initialize();
  }

  Future<void> _initialize() async {
    _createMarkers();
    await _resolveInitialCamera();
    await _resolveReferenceAndApplyDistances();
  }

  // ============== CAMERA ==============

  Future<void> _resolveInitialCamera() async {
    final LatLng? userLocation = await _getUserLocation();

    if (userLocation != null) {
      // Priority 1: open at user's actual location.
      initialCameraPosition.value = CameraPosition(
        target: userLocation,
        zoom: 13,
      );
      return;
    }

    // Priority 2: no user location → fit to merchants if any exist.
    if (markers.value.isNotEmpty) {
      final firstMarker = markers.value.first.position;
      initialCameraPosition.value = CameraPosition(
        target: firstMarker,
        zoom: 12,
      );
      // Slight delay so the GoogleMapController is ready before bounding.
      Future.delayed(const Duration(milliseconds: 500), () {
        _setCameraToMerchants();
      });
      return;
    }

    // Priority 3: no user location and no merchants → neutral world view,
    // no hard-coded country / default city.
    initialCameraPosition.value = const CameraPosition(
      target: LatLng(0, 0),
      zoom: 1,
    );
  }

  Future<LatLng?> _getUserLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      final perm = await _ensureGeolocatorLocationPermission();
      if (!_isGeolocatorLocationGranted(perm)) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      AppPrint.appError(e, title: "MapDetailsController user location");
      return null;
    }
  }

  /// Profile [Location] uses GeoJSON order: [longitude, latitude].
  Future<LatLng?> _getLatLngFromProfile() async {
    try {
      ProfileModelData? data = profileController.profileData.value;
      if (!_hasValidProfileCoordinates(data)) {
        await profileController.fetchProfileData();
        data = profileController.profileData.value;
      }
      final coords = data?.location?.coordinates;
      if (coords == null || coords.length < 2) return null;
      final lng = coords[0];
      final lat = coords[1];
      if (lat == 0.0 && lng == 0.0) return null;
      return LatLng(lat, lng);
    } catch (e) {
      AppPrint.appError(e, title: "MapDetailsController profile location");
      return null;
    }
  }

  bool _hasValidProfileCoordinates(ProfileModelData? data) {
    final c = data?.location?.coordinates;
    return c != null && c.length >= 2;
  }

  Future<void> _resolveReferenceAndApplyDistances() async {
    LatLng? ref = await _getUserLocation();
    ref ??= await _getLatLngFromProfile();
    applyMerchantDistancesFrom(ref);
  }

  /// Updates each merchant [NearByMerchentModelData.distance] in **kilometers**
  /// from [origin]. If [origin] is null, leaves existing values unchanged.
  void applyMerchantDistancesFrom(LatLng? origin) {
    if (origin == null) {
      update();
      return;
    }
    for (final m in merchantList) {
      if (m.lat == null || m.lng == null) continue;
      if (m.lat == 0.0 && m.lng == 0.0) continue;
      final meters = Geolocator.distanceBetween(
        origin.latitude,
        origin.longitude,
        m.lat!,
        m.lng!,
      );
      m.distance = meters / 1000.0;
    }
    update();
  }

  String formattedDistanceKm(NearByMerchentModelData merchant) {
    final km = merchant.distance;
    if (km == null) return '';
    if (km < 1.0) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  /// Location permission via Geolocator (CoreLocation / Play Services), not
  /// [permission_handler]: on iOS, permission_handler needs Podfile
  /// `PERMISSION_LOCATION_WHENINUSE=1`, otherwise location often stays denied.
  Future<LocationPermission> _ensureGeolocatorLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  bool _isGeolocatorLocationGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Taps the my-location control: opens settings when needed, otherwise
  /// animates the camera to the current GPS position.
  Future<void> recenterOnUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackBar.message(
          "Device location is turned off. Enable it in system settings.",
        );
        await Geolocator.openLocationSettings();
        return;
      }

      final perm = await _ensureGeolocatorLocationPermission();
      if (perm == LocationPermission.deniedForever) {
        AppSnackBar.message(
          "Location permission is permanently denied. Enable it in app settings.",
        );
        await Geolocator.openAppSettings();
        return;
      }
      if (!_isGeolocatorLocationGranted(perm)) {
        AppSnackBar.message("Allow location access to move the map to you.");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final userLatLng = LatLng(position.latitude, position.longitude);
      final mapController = await controller.future;
      await mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          userLatLng,
          15,
        ),
      );
      applyMerchantDistancesFrom(userLatLng);
    } catch (e) {
      AppPrint.appError(e, title: "recenterOnUserLocation");
      AppSnackBar.message("Could not get your location. Try again.");
    }
  }

  Future<void> zoomIn() async {
    try {
      final mapController = await controller.future;
      await mapController.animateCamera(CameraUpdate.zoomIn());
    } catch (e) {
      AppPrint.appError(e, title: "map zoomIn");
    }
  }

  Future<void> zoomOut() async {
    try {
      final mapController = await controller.future;
      await mapController.animateCamera(CameraUpdate.zoomOut());
    } catch (e) {
      AppPrint.appError(e, title: "map zoomOut");
    }
  }

  // ============== MARKERS ==============

  void _createMarkers() {
    if (merchantList.isEmpty) {
      markers.value = {};
      return;
    }

    final Set<Marker> tempMarkers = merchantList
        .where(
          (m) =>
      m.lat != null &&
          m.lng != null &&
          !(m.lat == 0.0 && m.lng == 0.0),
    )
        .map((merchant) {
      return Marker(
        markerId: MarkerId(merchant.id ?? UniqueKey().toString()),
        position: LatLng(merchant.lat!, merchant.lng!),
        onTap: () => selectMerchant(merchant),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: merchant.firstName ?? "Merchant",
          snippet: "Tap for details",
        ),
      );
    })
        .toSet();

    markers.value = tempMarkers;

    AppPrint.appPrint(
      "Created ${markers.value.length} markers",
      title: "MapDetailsController",
    );
  }

  Future<void> _setCameraToMerchants() async {
    if (markers.value.isEmpty) return;

    final GoogleMapController mapController = await controller.future;

    if (markers.value.length == 1) {
      final marker = markers.value.first;
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(marker.position, 15),
      );
      return;
    }

    double minLat = 90.0;
    double minLng = 180.0;
    double maxLat = -90.0;
    double maxLng = -180.0;

    for (final marker in markers.value) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng)
        minLng = marker.position.longitude;
      if (marker.position.longitude > maxLng)
        maxLng = marker.position.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  // ============== SELECTION ==============

  void selectMerchant(NearByMerchentModelData merchant) {
    selectedMerchant.value = merchant;
    _updateMarkerColors();
  }

  void _updateMarkerColors() {
    final Set<Marker> updatedMarkers = {};
    for (final marker in markers.value) {
      final isSelected =
          selectedMerchant.value?.id == marker.markerId.value;
      updatedMarkers.add(
        marker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            isSelected
                ? BitmapDescriptor.hueOrange
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }
    markers.value = updatedMarkers;
  }

  Future<void> animateToMerchant(NearByMerchentModelData merchant) async {
    final GoogleMapController mapController = await controller.future;

    Marker? foundMarker;
    for (final marker in markers.value) {
      if (marker.markerId.value == merchant.id) {
        foundMarker = marker;
        break;
      }
    }

    if (foundMarker != null) {
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: foundMarker.position, zoom: 15),
        ),
      );
    }
  }

  // ============== UTILS ==============

  String getMerchantImageUrl(NearByMerchentModelData merchant) {
    if (merchant.profile != null && merchant.profile!.isNotEmpty) {
      return AppApiEndPoint.mediaUrl(merchant.profile);
    }
    return "";
  }

  @override
  void onClose() {
    controller.future.then((mapController) => mapController.dispose());
    super.onClose();
  }
}