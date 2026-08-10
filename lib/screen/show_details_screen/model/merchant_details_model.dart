import 'dart:convert';
import '../../home_screen/model/promotion_model.dart';

class MerchantDetailsModel {
  final bool success;
  final String message;
  final MerchantDetailsModelData? data;

  MerchantDetailsModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory MerchantDetailsModel.fromRawJson(String str) =>
      MerchantDetailsModel.fromJson(json.decode(str));

  factory MerchantDetailsModel.fromJson(Map<String, dynamic> json) {
    return MerchantDetailsModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? MerchantDetailsModelData.fromJson(json['data'])
          : null,
    );
  }
}

class MerchantDetailsModelData {
  final Merchant? merchant;
  final List<Promotion> promotions;

  MerchantDetailsModelData({this.merchant, required this.promotions});

  factory MerchantDetailsModelData.fromJson(Map<String, dynamic> json) {
    return MerchantDetailsModelData(
      merchant: json['merchant'] is Map<String, dynamic>
          ? Merchant.fromJson(json['merchant'])
          : null,
      promotions: json['promotions'] is List
          ? List<Promotion>.from(
              json['promotions'].map((x) => Promotion.fromJson(x)),
            )
          : [],
    );
  }
}

class Merchant {
  final String id;
  final String firstName;
  final String profile;
  final String photo;
  final String address;
  final Location? location;
  final String website;
  final String about;
  final String? businessName;
   String? digitalCardId;
  final String? cardCode;
  final double? availablePoints;

  Merchant({
    required this.id,
    required this.firstName,
    required this.profile,
    required this.photo,
    required this.address,
    this.location,
    required this.website,
    required this.about,
    this.digitalCardId,
    this.cardCode,
    this.availablePoints,
    this.businessName,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['_id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      profile: json['profile']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      location: json['location'] is Map<String, dynamic>
          ? Location.fromJson(json['location'])
          : null,
      website: json['website']?.toString() ?? '',
      about: json['about']?.toString() ?? '',
      digitalCardId: json['digitalCardId']?.toString() ?? '',
      cardCode: json['cardCode']?.toString() ?? '',
      availablePoints:
          double.tryParse(json['availablePoints']?.toString() ?? '0') ?? 0,
      businessName: json['businessName']?.toString() ?? '',
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? defaultValue;
    }

    return Location(
      type: json['type']?.toString() ?? '',
      coordinates: json['coordinates'] is List
          ? List<double>.from(json['coordinates'].map((x) => toDouble(x)))
          : [],
    );
  }
}

