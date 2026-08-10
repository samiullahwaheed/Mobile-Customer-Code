

import 'package:geocoding/geocoding.dart';

/// Get readable location from latitude and longitude.
/// Automatically handles string/double types and invalid/missing values.
Future<String> getLocationFromLatLong(dynamic lat, dynamic long) async {
  try {
    // ✅ Check for null or empty
    if (lat == null || long == null) {
      return "Update address";
    }

    // ✅ Try to convert to double
    double? latitude;
    double? longitude;

    if (lat is String) {
      latitude = double.tryParse(lat);
    } else if (lat is double) {
      latitude = lat;
    }

    if (long is String) {
      longitude = double.tryParse(long);
    } else if (long is double) {
      longitude = long;
    }

    // ✅ Validate parsed values
    if (latitude == null || longitude == null) {
      return "Invalid address";
    }

    // ✅ Check valid coordinate range
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      return "Invalid address";
    }

    // ✅ Get location info
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return "${place.locality}, ${place.country}";
    } else {
      // ✅ Try nearby coordinate fallback
      double nearbyLat = latitude + 0.01; // ~1km north
      double nearbyLong = longitude + 0.01; // ~1km east

      List<Placemark> nearbyPlaces = await placemarkFromCoordinates(
        nearbyLat,
        nearbyLong,
      );
      if (nearbyPlaces.isNotEmpty) {
        final place = nearbyPlaces.first;
        return "${place.locality}, ${place.country} (approx)";
      } else {
        return "Invalid address";
      }
    }
  } catch (e) {
    return "Invalid address";
  }
}
