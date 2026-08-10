import 'dart:convert';

class PromotionModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<Promotion>? data;

  PromotionModel({this.success, this.message, this.pagination, this.data});

  factory PromotionModel.fromRawJson(String str) =>
      PromotionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
    success: json["success"],
    message: json["message"],
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null
        ? []
        : List<Promotion>.from(json["data"]!.map((x) => Promotion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "pagination": pagination?.toJson(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Promotion {
  String? id;
  String? cardId;
  String? name;
  String? customerSegment;
  int? discountPercentage;
  int? ratting;
  String? promotionType;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? availableDays;
  String? image;
  String? status;
  String? source;
  MerchantId? merchantId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isPromotionAdded;
  bool? buy;
  double? averageRating;

  Promotion({
    this.id,
    this.cardId,
    this.name,
    this.customerSegment,
    this.discountPercentage,
    this.promotionType,
    this.startDate,
    this.endDate,
    this.availableDays,
    this.image,
    this.ratting,
    this.status,
    this.merchantId,
    this.source,
    this.createdAt,
    this.updatedAt,
    this.isPromotionAdded,
    this.buy,
    this.averageRating,
  });

  factory Promotion.fromRawJson(String str) =>
      Promotion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
    id: json["_id"] != null && json["_id"] is String ? json["_id"] : "",
    source: json["source"] != null && json["source"] is String
        ? json["source"]
        : "",
    cardId: json["cardId"],
    name: json["name"],
    customerSegment: json["customerSegment"],
    discountPercentage: json["discountPercentage"],
    ratting: json["ratting"] != null && json["ratting"] is int
        ? json["ratting"]
        : 0,
    promotionType: json["promotionType"],
    startDate: json["startDate"] == null
        ? null
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    availableDays: json["availableDays"] == null
        ? []
        : List<String>.from(json["availableDays"]!.map((x) => x)),
    image: json["image"],
    status: json["status"],
    // merchantId can come as an object or just an id string
    merchantId: MerchantId.parse(json["merchantId"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    isPromotionAdded: json["isPromotionAdded"] ?? true,
    buy: json["buy"] ?? false,
    averageRating:
        json["averageRating"] != null && json["averageRating"] is double
        ? json["averageRating"]
        : 0.0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "cardId": cardId,
    "name": name,
    "customerSegment": customerSegment,
    "discountPercentage": discountPercentage,
    "promotionType": promotionType,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "availableDays": availableDays == null
        ? []
        : List<dynamic>.from(availableDays!.map((x) => x)),
    "image": image,
    "status": status,
    "merchantId": merchantId?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "source": source,
    "updatedAt": updatedAt?.toIso8601String(),
    "isPromotionAdded": isPromotionAdded,
    "buy": buy,
  };
}

class MerchantId {
  String? id;
  String? website;

  MerchantId({this.id, this.website});

  factory MerchantId.fromRawJson(String str) =>
      MerchantId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MerchantId.fromJson(Map<String, dynamic> json) =>
      MerchantId(id: json["_id"], website: json["website"]);

  /// Handle both map and plain id string responses.
  static MerchantId? parse(dynamic merchant) {
    if (merchant == null) return null;
    if (merchant is Map<String, dynamic>) {
      return MerchantId.fromJson(merchant);
    }
    if (merchant is String) {
      return MerchantId(id: merchant);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {"_id": id, "website": website};
}

class Pagination {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  Pagination({this.total, this.limit, this.page, this.totalPage});

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    limit: json["limit"],
    page: json["page"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "limit": limit,
    "page": page,
    "totalPage": totalPage,
  };
}
