import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowGoogleMap extends StatelessWidget {
  const ShowGoogleMap({
    super.key,
    this.latitude = 0,
    this.longitude = 0,
    this.marker = const [],
    required this.onTapLatLong,
  });

  final double latitude;

  final List<Marker> marker;

  final double longitude;
  final Function(LatLng value) onTapLatLong;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShowGoogleMapController>(
      builder: (controller) {
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: (latitude != 0 && longitude != 0)
              ? CameraPosition(target: LatLng(latitude, longitude), zoom: 14)
              : controller.kGooglePlex ??
                    const CameraPosition(
                      target: LatLng(37.42796133580664, -122.085749655962),
                      zoom: 14,
                    ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          cameraTargetBounds: CameraTargetBounds.unbounded,
          onTap: (LatLng latLng) {
            onTapLatLong(latLng);
            // controller.setMarker(latLng);
          },
          markers: {
            if (latitude != 0 && longitude != 0)
              Marker(
                markerId: MarkerId(latitude.toInt().toString()),
                position: LatLng(latitude, longitude),
              ),
            ...marker,
          },
          onMapCreated: (GoogleMapController googleMapController) {
            if (!controller.controller.isCompleted) {
              controller.controller.complete(googleMapController);
            }
          },
        );
      },
    );
  }
}

class ShowGoogleMapController extends GetxController {
  List<Marker> marker = [];

  num latitude = 0;
  num longitude = 0;

  Position? positions;

  static ShowGoogleMapController get instance =>
      Get.put(ShowGoogleMapController());

  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  CameraPosition? kGooglePlex;

  Future<Marker> setMarker(LatLng latLng) async {
    Marker newMarker = Marker(
      markerId: const MarkerId("1"),
      position: LatLng(latLng.latitude, latLng.longitude),
    );

    update();

    return newMarker;
  }

  getCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        // Permission denied, use default location
        _setDefaultLocation();
        return;
      }

      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setDefaultLocation();
        return;
      }

      // Get current position
      positions = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      if (positions != null) {
        latitude = positions!.latitude;
        longitude = positions!.longitude;

        kGooglePlex = CameraPosition(
          target: LatLng(positions!.latitude, positions!.longitude),
          zoom: 10,
        );
        CameraPosition newCameraPosition = CameraPosition(
          target: LatLng(positions!.latitude, positions!.longitude),
          zoom: 10,
        );

        setMarker(LatLng(positions!.latitude, positions!.longitude));

        if (controller.isCompleted) {
          final GoogleMapController googleMapController =
              await controller.future;
          await googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(newCameraPosition),
          );
        }
        update();
      }
    } catch (e) {
      // Handle error silently or log it
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    kGooglePlex = const CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 10,
    );
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }
}
