// ignore_for_file: constant_identifier_names

import 'dart:convert';

class AllMerchantModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<AllMerchantModelData>? data;

  AllMerchantModel({
    this.success,
    this.message,
    this.pagination,
    this.data,
  });

  factory AllMerchantModel.fromJson(Map<String, dynamic> json) =>
      AllMerchantModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        pagination: json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
        data: json["data"] is List
            ? List<AllMerchantModelData>.from(
                json["data"].map((x) => AllMerchantModelData.fromJson(x)))
            : [],
      );
}

class AllMerchantModelData {
  String? id;
  String? firstName;
  String? lastName;
  String? referenceId;
  Role? role;
  String? email;
  String? phone;
  String? profile;
  List<dynamic>? documentVerified;
  String? photo;
  bool? verified;
  Status? status;
  String? approveStatus;
  UserReport? userReport;
  Location? location;
  String? subscription;
  dynamic stripeAccountId;
  AccountInformation? accountInformation;
  List<String>? prefreances;
  DateTime? lastActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? about;
  String? businessName;
  String? city;
  String? country;
  String? service;
  String? website;
  String? address;
  String? appId;
  String? fcmToken;
  bool? emailVerified;
  bool? phoneVerified;
  bool? isFavorite;
  double? rating;

  AllMerchantModelData({
    this.id,
    this.firstName,
    this.lastName,
    this.referenceId,
    this.role,
    this.email,
    this.phone,
    this.profile,
    this.documentVerified,
    this.photo,
    this.verified,
    this.status,
    this.approveStatus,
    this.userReport,
    this.location,
    this.subscription,
    this.stripeAccountId,
    this.accountInformation,
    this.prefreances,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.about,
    this.businessName,
    this.city,
    this.country,
    this.service,
    this.website,
    this.address,
    this.appId,
    this.fcmToken,
    this.emailVerified,
    this.phoneVerified,
    this.isFavorite,
    this.rating,
  });

  factory AllMerchantModelData.fromJson(Map<String, dynamic> json) =>
      AllMerchantModelData(
        id: json["_id"]?.toString() ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        referenceId: json["referenceId"] ?? "",

        // ✅ SAFE ENUM
        role: roleValues.map[json["role"]] ?? Role.MERCENT,

        email: json["email"] ?? "",
        phone: json["phone"] ?? "",
        profile: json["profile"] ?? "",

        // ✅ SAFE LIST
        documentVerified: json["documentVerified"] is List
            ? List<dynamic>.from(json["documentVerified"])
            : [],

        photo: json["photo"] ?? "",
        verified: json["verified"] ?? false,

        // ✅ SAFE ENUM WITH DEFAULT
        status: statusValues.map[json["status"]] ?? Status.UNKNOWN,

        approveStatus: json["approveStatus"] ?? "",
        userReport:
            userReportValues.map[json["userReport"]] ?? UserReport.NO_REPORT,

        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : null,

        subscription: json["subscription"] ?? "",
        stripeAccountId: json["stripeAccountId"],

        accountInformation: json["accountInformation"] != null
            ? AccountInformation.fromJson(json["accountInformation"])
            : null,

        prefreances: json["prefreances"] is List
            ? List<String>.from(json["prefreances"])
            : [],

        lastActive: json["lastActive"] != null
            ? DateTime.tryParse(json["lastActive"])
            : null,

        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,

        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,

        v: json["__v"] ?? 0,
        about: json["about"] ?? "",
        businessName: json["businessName"] ?? "",
        city: json["city"] ?? "",
        country: json["country"] ?? "",
        service: json["service"] ?? "",
        website: json["website"] ?? "",
        address: json["address"] ?? "",
        appId: json["appId"] ?? "",
        fcmToken: json["fcmToken"] ?? "",
        emailVerified: json["emailVerified"] ?? false,
        phoneVerified: json["phoneVerified"] ?? false,
        isFavorite: json["isFavorite"] ?? false,

        // ✅ SAFE DOUBLE
        rating: double.tryParse(json["rating"]?.toString() ?? "0") ?? 0.0,
      );

  /// Display name for merchant listings: prefers the registered business
  /// name and falls back to firstName for older records without one.
  String get displayName {
    if (businessName != null && businessName!.trim().isNotEmpty) {
      return businessName!.trim();
    }
    return firstName ?? "";
  }
}

class AccountInformation {
  bool? status;
  String? stripeAccountId;
  String? externalAccountId;
  String? currency;

  AccountInformation({
    this.status,
    this.stripeAccountId,
    this.externalAccountId,
    this.currency,
  });

  factory AccountInformation.fromJson(Map<String, dynamic> json) =>
      AccountInformation(
        status: json["status"] ?? false,
        stripeAccountId: json["stripeAccountId"] ?? "",
        externalAccountId: json["externalAccountId"] ?? "",
        currency: json["currency"] ?? "",
      );
}

class Location {
  Type? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: typeValues.map[json["type"]] ?? Type.POINT,
        coordinates: json["coordinates"] is List
            ? List<double>.from(
                json["coordinates"].map((x) => (x as num).toDouble()))
            : [],
      );
}

enum Type { POINT }

final typeValues = EnumValues({"Point": Type.POINT});

enum Role { MERCENT }

final roleValues = EnumValues({
  "MERCENT": Role.MERCENT,
});

/// ✅ UPDATED STATUS (IMPORTANT)
enum Status { ACTIV, ACTIVE, INACTIVE, IN_ACTIVE, DELETED, UNKNOWN }

final statusValues = EnumValues({
  "activ": Status.ACTIV,
  "active": Status.ACTIVE,
  "inactive": Status.INACTIVE,
  "inActive": Status.IN_ACTIVE,
  "deleted": Status.DELETED,
});

enum UserReport { NO_REPORT }

final userReportValues = EnumValues({
  "no_report": UserReport.NO_REPORT,
});

class Pagination {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  Pagination({this.total, this.limit, this.page, this.totalPage});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"] ?? 0,
        limit: json["limit"] ?? 0,
        page: json["page"] ?? 0,
        totalPage: json["totalPage"] ?? 0,
      );
}

class EnumValues<T> {
  Map<String, T> map;
  EnumValues(this.map);
}



