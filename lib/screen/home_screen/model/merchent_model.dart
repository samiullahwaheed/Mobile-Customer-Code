import 'dart:convert';

class MerchantModel {
    bool? success;
    String? message;
    List<MerchantModelData>? data;

    MerchantModel({
        this.success,
        this.message,
        this.data,
    });

    factory MerchantModel.fromRawJson(String str) => MerchantModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MerchantModel.fromJson(Map<String, dynamic> json) => MerchantModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<MerchantModelData>.from(json["data"]!.map((x) => MerchantModelData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class MerchantModelData {
    String? id;
    int? totalRatings;
    double? avgRating;
    String? firstName;
    String? businessName;
    String? email;
    String? profile;

    MerchantModelData({
        this.id,
        this.totalRatings,
        this.avgRating,
        this.firstName,
        this.businessName,
        this.email,
        this.profile,
    });

    factory MerchantModelData.fromRawJson(String str) => MerchantModelData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MerchantModelData.fromJson(Map<String, dynamic> json) => MerchantModelData(
        id: json["_id"],
        totalRatings: json["totalRatings"],
        avgRating: json["avgRating"]?.toDouble(),
        firstName: json["firstName"],
        businessName: json["businessName"],
        email: json["email"],
        profile: json["profile"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "totalRatings": totalRatings,
        "avgRating": avgRating,
        "firstName": firstName,
        "businessName": businessName,
        "email": email,
        "profile": profile,
    };

    /// Display name for merchant listings: prefers the registered business
    /// name and falls back to firstName for older records without one.
    String get displayName {
        if (businessName != null && businessName!.trim().isNotEmpty) {
            return businessName!.trim();
        }
        return firstName ?? "";
    }
}


