import 'dart:convert';

class SellRequistModel {
    bool? success;
    String? message;
    Data? data;

    SellRequistModel({
        this.success,
        this.message,
        this.data,
    });

    factory SellRequistModel.fromRawJson(String str) => SellRequistModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SellRequistModel.fromJson(Map<String, dynamic> json) => SellRequistModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String? id;
    String? merchantId;
    String? userId;
    String? digitalCardId;
    List<PromotionId>? promotionIds;
    int? totalBill;
    int? discountedBill;
    double? pointsEarned;
    int? pointRedeemed;
    String? status;
    String? sellId;
    String? digitalCardCode;
    DateTime? approvalExpiresAt;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    Data({
        this.id,
        this.merchantId,
        this.userId,
        this.digitalCardId,
        this.promotionIds,
        this.totalBill,
        this.discountedBill,
        this.pointsEarned,
        this.pointRedeemed,
        this.status,
        this.approvalExpiresAt,
        this.createdAt,
        this.updatedAt,
        this.sellId,
        this.digitalCardCode,
        this.v,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        merchantId: json["merchantId"],
        userId: json["userId"],
        digitalCardId: json["digitalCardId"],
        promotionIds: json["promotionIds"] == null ? [] : List<PromotionId>.from(json["promotionIds"]!.map((x) => PromotionId.fromJson(x))),
        totalBill: json["totalBill"],
        discountedBill: json["discountedBill"],
        pointsEarned: json["pointsEarned"]?.toDouble(),
        pointRedeemed: json["pointRedeemed"],
        status: json["status"],
        sellId: json["sellId"],
        digitalCardCode: json["digitalCardCode"],
        approvalExpiresAt: json["approvalExpiresAt"] == null ? null : DateTime.parse(json["approvalExpiresAt"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "merchantId": merchantId,
        "userId": userId,
        "digitalCardId": digitalCardId,
        "promotionIds": promotionIds == null ? [] : List<dynamic>.from(promotionIds!.map((x) => x.toJson())),
        "totalBill": totalBill,
        "discountedBill": discountedBill,
        "pointsEarned": pointsEarned,
        "pointRedeemed": pointRedeemed,
        "status": status,
        "sellId": sellId,
        "digitalCardCode": digitalCardCode,
        "approvalExpiresAt": approvalExpiresAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}

class PromotionId {
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
    int? grossValue;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    PromotionId({
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
        this.grossValue,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory PromotionId.fromRawJson(String str) => PromotionId.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PromotionId.fromJson(Map<String, dynamic> json) => PromotionId(
        id: json["_id"],
        cardId: json["cardId"],
        name: json["name"],
        customerSegment: json["customerSegment"],
        discountPercentage: json["discountPercentage"],
        promotionType: json["promotionType"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        availableDays: json["availableDays"] == null ? [] : List<String>.from(json["availableDays"]!.map((x) => x)),
        image: json["image"],
        status: json["status"],
        merchantId: json["merchantId"],
        grossValue: json["grossValue"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
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
        "availableDays": availableDays == null ? [] : List<dynamic>.from(availableDays!.map((x) => x)),
        "image": image,
        "status": status,
        "merchantId": merchantId,
        "grossValue": grossValue,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}
