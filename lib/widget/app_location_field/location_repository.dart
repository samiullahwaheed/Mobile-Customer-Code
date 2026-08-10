import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:loyalty_customer/const/app_const.dart';

// Add your Google Maps API key here
const String apikey = AppConst.googleMapsApiKey;

class LocationRepository {
  static final LocationRepository _instance = LocationRepository._internal();

  factory LocationRepository() {
    return _instance;
  }

  LocationRepository._internal();

  bool _isLoading = false;
  List<dynamic> _placePredictions = [];

  // Getters for state
  bool get isLoading => _isLoading;
  List<dynamic> get placePredictions => _placePredictions;

  void clearPlacePredictions() {
    _placePredictions = [];
  }

  // Place auto-complete suggestions with debouncing
  Future<List<dynamic>> placeAutoComplete(String query) async {
    if (query.isEmpty) {
      _placePredictions = [];
      return _placePredictions;
    }

    _isLoading = true;

    try {
      final Uri uri = Uri.https(
        'maps.googleapis.com',
        'maps/api/place/autocomplete/json',
        {'input': query, 'key': apikey},
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          _placePredictions = data['predictions'];
        } else {
          debugPrint('API Error: ${data['status']}');
          _placePredictions = [];
        }
      } else {
        debugPrint('HTTP Error: ${response.statusCode}');
        _placePredictions = [];
      }
    } catch (e) {
      debugPrint('Error in place autocomplete: $e');
      _placePredictions = [];
    } finally {
      _isLoading = false;
    }

    return _placePredictions;
  }

  // Get place details including lat/lng from place_id
  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    if (placeId.isEmpty || placeId == 'current_location') {
      return null;
    }

    try {
      final Uri uri =
          Uri.https('maps.googleapis.com', 'maps/api/place/details/json', {
            'place_id': placeId,
            'fields': 'geometry,formatted_address,name',
            'key': apikey,
          });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final result = data['result'];
          final geometry = result['geometry'];
          final location = geometry['location'];

          return {
            'lat': location['lat'],
            'lng': location['lng'],
            'formatted_address': result['formatted_address'],
            'name': result['name'] ?? '',
          };
        } else {
          debugPrint('Place Details API Error: ${data['status']}');
          return null;
        }
      } else {
        debugPrint('Place Details HTTP Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error in place details: $e');
      return null;
    }
  }
}
