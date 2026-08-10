import 'dart:convert';

class MerchantTiarModel {
  bool? success;
  String? message;
  MerchantTiarModelData? data;

  MerchantTiarModel({this.success, this.message, this.data});

  factory MerchantTiarModel.fromRawJson(String str) =>
      MerchantTiarModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MerchantTiarModel.fromJson(Map<String, dynamic> json) =>
      MerchantTiarModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : MerchantTiarModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class MerchantTiarModelData {
  double? availablePoints;
  String? tierName;
  String? rewardText;

  MerchantTiarModelData({this.availablePoints, this.tierName, this.rewardText});

  factory MerchantTiarModelData.fromRawJson(String str) =>
      MerchantTiarModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MerchantTiarModelData.fromJson(Map<String, dynamic> json) =>
      MerchantTiarModelData(
        availablePoints:
            double.tryParse(json["availablePoints"].toString()) ?? 0.0,
        tierName: json["tierName"],
        rewardText: json["rewardText"],
      );

  Map<String, dynamic> toJson() => {
    "availablePoints": availablePoints,
    "tierName": tierName,
    "rewardText": rewardText,
  };
}
