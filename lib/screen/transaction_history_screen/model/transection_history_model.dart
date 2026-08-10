import 'dart:convert';

class SubscriptionHistoryModel {
  bool? success;
  String? message;
  List<SubscriptionHistoryModelData>? data;

  SubscriptionHistoryModel({this.success, this.message, this.data});

  factory SubscriptionHistoryModel.fromRawJson(String str) =>
      SubscriptionHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionHistoryModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<SubscriptionHistoryModelData>.from(
                json["data"]!.map(
                  (x) => SubscriptionHistoryModelData.fromJson(x),
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

class SubscriptionHistoryModelData {
  String? id;
  String? customerId;
  int? price;
  String? user;
  Package? package;
  String? trxId;
  String? subscriptionId;
  String? currentPeriodStart;
  String? currentPeriodEnd;
  int? remaining;
  String? status;
  String? source;
  String? createdAt;
  String? updatedAt;
  int? v;

  SubscriptionHistoryModelData({
    this.id,
    this.customerId,
    this.price,
    this.user,
    this.package,
    this.trxId,
    this.subscriptionId,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.remaining,
    this.status,
    this.source,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SubscriptionHistoryModelData.fromRawJson(String str) =>
      SubscriptionHistoryModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionHistoryModelData.fromJson(
    Map<String, dynamic> json,
  ) => SubscriptionHistoryModelData(
    id: json["_id"] != null && json["_id"] is String ? json["_id"] : "",
    customerId: json["customerId"] != null && json["customerId"] is String
        ? json["customerId"]
        : "",
    price: json["price"] != null && json["price"] is int ? json["price"] : 0,
    user: json["user"] != null && json["user"] is String ? json["user"] : "",
    package: json["package"] == null ? null : Package.fromJson(json["package"]),
    trxId: json["trxId"] != null && json["trxId"] is String
        ? json["trxId"]
        : "",
    subscriptionId:
        json["subscriptionId"] != null && json["subscriptionId"] is String
        ? json["subscriptionId"]
        : "",
    currentPeriodStart:
        json["currentPeriodStart"] != null &&
            json["currentPeriodStart"] is String
        ? json["currentPeriodStart"]
        : "",
    currentPeriodEnd:
        json["currentPeriodEnd"] != null && json["currentPeriodEnd"] is String
        ? json["currentPeriodEnd"]
        : "",
    remaining: json["remaining"] != null && json["remaining"] is int
        ? json["remaining"]
        : 0,
    status: json["status"] != null && json["status"] is String
        ? json["status"]
        : "inActive",
    source: json["source"] != null && json["source"] is String
        ? json["source"]
        : "",
    createdAt: json["createdAt"] != null && json["createdAt"] is String
        ? json["createdAt"]
        : "",
    updatedAt: json["updatedAt"] != null && json["updatedAt"] is String
        ? json["updatedAt"]
        : "",
    v: json["__v"] != null && json["__v"] is int ? json["__v"] : 0,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "customerId": customerId,
    "price": price,
    "user": user,
    "package": package?.toJson(),
    "trxId": trxId,
    "subscriptionId": subscriptionId,
    "currentPeriodStart": currentPeriodStart,
    "currentPeriodEnd": currentPeriodEnd,
    "remaining": remaining,
    "status": status,
    "source": source,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
}

class Package {
  String? id;
  String? title;

  Package({this.id, this.title});

  factory Package.fromRawJson(String str) => Package.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Package.fromJson(Map<String, dynamic> json) =>
      Package(id: json["_id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"_id": id, "title": title};
}

