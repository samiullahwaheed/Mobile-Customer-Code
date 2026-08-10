import 'dart:convert';

class MyGiftCardModel {
  bool? success;
  String? message;
  Pagination? pagination;
  MyGiftCardModelData? data;

  MyGiftCardModel({this.success, this.message, this.pagination, this.data});

  factory MyGiftCardModel.fromRawJson(String str) =>
      MyGiftCardModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyGiftCardModel.fromJson(Map<String, dynamic> json) =>
      MyGiftCardModel(
        success: json["success"],
        message: json["message"],
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        data: json["data"] == null
            ? null
            : MyGiftCardModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "pagination": pagination?.toJson(),
    "data": data?.toJson(),
  };
}

class MyGiftCardModelData {
  int? totalPromotions;
  List<PromotionElement>? promotions;

  MyGiftCardModelData({this.totalPromotions, this.promotions});

  factory MyGiftCardModelData.fromRawJson(String str) =>
      MyGiftCardModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyGiftCardModelData.fromJson(Map<String, dynamic> json) =>
      MyGiftCardModelData(
        totalPromotions: json["totalPromotions"],
        promotions: json["promotions"] == null
            ? []
            : List<PromotionElement>.from(
                json["promotions"]!.map((x) => PromotionElement.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "totalPromotions": totalPromotions,
    "promotions": promotions == null
        ? []
        : List<dynamic>.from(promotions!.map((x) => x.toJson())),
  };
}

class PromotionElement {
  String? cardCode;
  String? status;
  String? promoCode;
  DateTime? usedAt;
  PromotionPromotion? promotion;

  PromotionElement({
    this.cardCode,
    this.status,
    this.usedAt,
    this.promoCode,
    this.promotion,
  });

  factory PromotionElement.fromRawJson(String str) =>
      PromotionElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PromotionElement.fromJson(Map<String, dynamic> json) =>
      PromotionElement(
        cardCode: json["cardCode"],
        status: json["status"],
        promoCode: json["promoCode"],
        usedAt: json["usedAt"] == null ? null : DateTime.parse(json["usedAt"]),
        promotion: json["promotion"] == null
            ? null
            : PromotionPromotion.fromJson(json["promotion"]),
      );

  Map<String, dynamic> toJson() => {
    "cardCode": cardCode,
    "status": status,
    "promoCode": promoCode,
    "usedAt": usedAt?.toIso8601String(),
    "promotion": promotion?.toJson(),
  };
}

class PromotionPromotion {
  String? id;
  String? cardId;
  String? name;
  String? customerSegment;
  int? discountPercentage;
  String? promotionType;
  DateTime? startDate;
  DateTime? endDate;
  List<String>? availableDays;
  String? image;
  String? status;
  String? merchantId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PromotionPromotion({
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
    this.status,
    this.merchantId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PromotionPromotion.fromRawJson(String str) =>
      PromotionPromotion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PromotionPromotion.fromJson(Map<String, dynamic> json) =>
      PromotionPromotion(
        id: json["_id"],
        cardId: json["cardId"],
        name: json["name"],
        customerSegment: json["customerSegment"],
        discountPercentage: json["discountPercentage"],
        promotionType: json["promotionType"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null
            ? null
            : DateTime.parse(json["endDate"]),
        availableDays: json["availableDays"] == null
            ? []
            : List<String>.from(json["availableDays"]!.map((x) => x)),
        image: json["image"],
        status: json["status"],
        merchantId: json["merchantId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
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
    "merchantId": merchantId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPage;

  Pagination({this.total, this.page, this.limit, this.totalPage});

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPage": totalPage,
  };
}
