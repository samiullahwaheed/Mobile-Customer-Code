import 'dart:convert';

class TransactionHistoryModel {
  bool? success;
  String? message;
  List<TransactionHistoryModelData>? data;

  TransactionHistoryModel({this.success, this.message, this.data});

  factory TransactionHistoryModel.fromRawJson(String str) =>
      TransactionHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<TransactionHistoryModelData>.from(
                json["data"]!.map(
                  (x) => TransactionHistoryModelData.fromJson(x),
                ),
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

class TransactionHistoryModelData {
  String? id;
  String? type;
  String? merchantId;
  String? digitalCardId;
  bool? isEarn;
  double? points;
  int? totalBill;
  int? discountedBill;
  double? rating;
  DateTime? date;
  String? promotionId;
  String? merchant;
  String? merchantProfile;

  TransactionHistoryModelData({
    this.id,
    this.type,
    this.merchantId,
    this.digitalCardId,
    this.points,
    this.totalBill,
    this.discountedBill,
    this.rating,
    this.date,
    this.promotionId,
    this.merchant,
    this.merchantProfile,
    this.isEarn,
  });

  factory TransactionHistoryModelData.fromRawJson(String str) =>
      TransactionHistoryModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionHistoryModelData.fromJson(
    Map<String, dynamic> json,
  ) => TransactionHistoryModelData(
    id: json["id"] != null && json["id"] is String ? json["id"] : "",
    isEarn: json["isEarn"] != null && json["isEarn"] is bool
        ? json["isEarn"]
        : false,
    merchantProfile:
        json["merchantProfile"] != null && json["merchantProfile"] is String
        ? json["merchantProfile"]
        : "",
    type: json["type"] != null && json["type"] is String ? json["type"] : "",
    digitalCardId:
        json["digitalCardId"] != null && json["digitalCardId"] is String
        ? json["digitalCardId"]
        : "",
    merchantId: json["merchantId"] != null && json["merchantId"] is String
        ? json["merchantId"]
        : "",
    points: double.tryParse(json["points"]?.toString() ?? "0"),
    rating: double.tryParse(json["rating"]?.toString() ?? "0"),
    totalBill: json["totalBill"] != null && json["totalBill"] is int
        ? json["totalBill"]
        : 0,
    discountedBill:
        json["discountedBill"] != null && json["discountedBill"] is int
        ? json["discountedBill"]
        : 0,
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    promotionId: json["promotionIds"] != null && json["promotionIds"] is String
        ? json["promotionIds"]
        : "",
    merchant: json["merchant"] != null && json["merchant"] is String
        ? json["merchant"]
        : "",
  );

  Map<String, dynamic> toJson() => {
    "isEarn": isEarn,
    "merchantProfile": merchantProfile,
    "id": id,
    "type": type,
    "points": points,
    "totalBill": totalBill,
    "discountedBill": discountedBill,
    "date": date?.toIso8601String(),
    "promotionId": promotionId,
    "merchant": merchant,
  };
}
