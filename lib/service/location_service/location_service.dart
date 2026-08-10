import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  LocationService._internal();
  static final LocationService _instance = LocationService._internal();
  static LocationService get instance => _instance;

  String? userAddress;
  String? latitude;
  String? longitude;

  /// Main method to request location permission & get current location
  Future<void> requestLocationPermission() async {
    try {
      // -----------------------------
      // 1️⃣ Check Location Service
      // -----------------------------
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // Open device settings (non-blocking)
        Geolocator.openLocationSettings();
        return; // exit, wait for user to enable
      }

      // -----------------------------
      // 2️⃣ Check Permission
      // -----------------------------
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return; // silently return, user can retry
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Open app settings
        Geolocator.openAppSettings();
        return; // exit, user can retry
      }

      // -----------------------------
      // 3️⃣ Get Current Position
      // -----------------------------
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude.toString();
      longitude = position.longitude.toString();

      // -----------------------------
      // 4️⃣ Reverse Geocoding
      // -----------------------------
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          userAddress = '${place.street}, ${place.locality}, ${place.country}';
        } else {
          userAddress = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
        }
      } catch (_) {
        userAddress = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
      }
    } catch (e) {
      // Reset on error
      latitude = null;
      longitude = null;
      userAddress = null;
      rethrow;
    }
  }
}


