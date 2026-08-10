import 'dart:convert';

class NearByMerchentModel {
  bool? success;
  String? message;
  List<NearByMerchentModelData>? data;

  NearByMerchentModel({this.success, this.message, this.data});

  factory NearByMerchentModel.fromRawJson(String str) =>
      NearByMerchentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearByMerchentModel.fromJson(Map<String, dynamic> json) =>
      NearByMerchentModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<NearByMerchentModelData>.from(
                json["data"]!.map((x) => NearByMerchentModelData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NearByMerchentModelData {
  String? id;
  String? firstName;
  String? profile;
  String? address;
  double? distance;
  double? lng;
  double? lat;
  List<dynamic>? ratings;
  double? totalRatings;
  double? avgRating;

  NearByMerchentModelData({
    this.id,
    this.firstName,
    this.profile,
    this.distance,
    this.address,
    this.lng,
    this.lat,
    this.ratings,
    this.totalRatings,
    this.avgRating,
  });

  factory NearByMerchentModelData.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? defaultValue;
    }

    return NearByMerchentModelData(
      id: json["_id"]?.toString() ?? "",
      firstName: json["firstName"]?.toString() ?? "",
      profile: json["profile"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      distance: toDouble(json["distance"]),
      lng: toDouble(json["lng"]),
      lat: toDouble(json["lat"]),

      ratings: json["ratings"] is List
          ? List<dynamic>.from(json["ratings"])
          : [],

      totalRatings: toDouble(json["totalRatings"]),
      avgRating: toDouble(json["avgRating"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "profile": profile,
    "distance": distance,
    "lng": lng,
    "lat": lat,
    "address": address,
    "ratings": ratings == null
        ? []
        : List<dynamic>.from(ratings!.map((x) => x)),
    "totalRatings": totalRatings,
    "avgRating": avgRating,
  };
}
