import 'dart:convert';

class DigitalCardModel {
  final bool success;
  final String message;
  final Pagination pagination;
  final DigitalCardModelData data;

  DigitalCardModel({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory DigitalCardModel.fromRawJson(String str) =>
      DigitalCardModel.fromJson(json.decode(str));

  factory DigitalCardModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return DigitalCardModel(
      success: json["success"] is bool ? json["success"] : false,
      message: json["message"]?.toString() ?? "",
      pagination: Pagination.fromJson(json["pagination"]),
      data: DigitalCardModelData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "pagination": pagination.toJson(),
        "data": data.toJson(),
      };
}

/* ---------------- DATA ---------------- */

class DigitalCardModelData {
  final int totalDigitalCards;
  final List<DigitalCard> digitalCards;

  DigitalCardModelData({
    required this.totalDigitalCards,
    required this.digitalCards,
  });

  factory DigitalCardModelData.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return DigitalCardModelData(
        totalDigitalCards: 0,
        digitalCards: [],
      );
    }

    return DigitalCardModelData(
      totalDigitalCards: _parseInt(json["totalDigitalCards"]),
      digitalCards: (json["digitalCards"] is List)
          ? (json["digitalCards"] as List)
              .map((e) => DigitalCard.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "totalDigitalCards": totalDigitalCards,
        "digitalCards": digitalCards.map((e) => e.toJson()).toList(),
      };
}

/* ---------------- DIGITAL CARD ---------------- */

class DigitalCard {
  final String id;
  final String userId;
  final MerchantId merchantId;
  final String cardCode;
  final double availablePoints;
  final List<String> promotions;
  final DateTime createdAt;
  final DateTime updatedAt;

  DigitalCard({
    required this.id,
    required this.userId,
    required this.merchantId,
    required this.cardCode,
    required this.availablePoints,
    required this.promotions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DigitalCard.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return DigitalCard.empty();
    }

    return DigitalCard(
      id: json["_id"]?.toString() ?? "",
      userId: json["userId"]?.toString() ?? "",
      merchantId: MerchantId.fromJson(json["merchantId"]),
      cardCode: json["cardCode"]?.toString() ?? "",
      availablePoints: _parseDouble(json["availablePoints"]),
      promotions: (json["promotions"] is List)
          ? List<String>.from(json["promotions"].map((e) => e.toString()))
          : [],
      createdAt: _parseDate(json["createdAt"]),
      updatedAt: _parseDate(json["updatedAt"]),
    );
  }

  factory DigitalCard.empty() => DigitalCard(
        id: "",
        userId: "",
        merchantId: MerchantId.empty(),
        cardCode: "",
        availablePoints: 0.0,
        promotions: [],
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "merchantId": merchantId.toJson(),
        "cardCode": cardCode,
        "availablePoints": availablePoints,
        "promotions": promotions,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

/* ---------------- MERCHANT ---------------- */

class MerchantId {
  final String id;
  final String firstName;
  final String businessName;
  final String profile;

  MerchantId({
    required this.id,
    required this.firstName,
    required this.businessName,
    required this.profile,
  });

  factory MerchantId.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return MerchantId.empty();
    }

    return MerchantId(
      id: json["_id"]?.toString() ?? "",
      firstName: json["firstName"]?.toString() ?? "",
      businessName: json["businessName"]?.toString() ?? "",
      profile: json["profile"]?.toString() ?? "",
    );
  }

  factory MerchantId.empty() => MerchantId(
        id: "",
        firstName: "",
        businessName: "",
        profile: "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "businessName": businessName,
        "profile": profile,
      };
}

/* ---------------- PAGINATION ---------------- */

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPage;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPage,
  });

  factory Pagination.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return Pagination.empty();
    }

    return Pagination(
      total: _parseInt(json["total"]),
      page: _parseInt(json["page"]),
      limit: _parseInt(json["limit"]),
      totalPage: _parseInt(json["totalPage"]),
    );
  }

  factory Pagination.empty() => Pagination(
        total: 0,
        page: 1,
        limit: 10,
        totalPage: 0,
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "totalPage": totalPage,
      };
}

/* ---------------- HELPERS ---------------- */

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

DateTime _parseDate(dynamic value) {
  if (value == null) {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.tryParse(value.toString()) ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
 

