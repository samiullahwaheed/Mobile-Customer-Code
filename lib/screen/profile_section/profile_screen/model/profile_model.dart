import 'dart:convert';

class ProfileModel {
  bool? success;
  String? message;
  ProfileModelData? data;

  ProfileModel({this.success, this.message, this.data});

  factory ProfileModel.fromRawJson(String str) =>
      ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileModelData {
  Location? location;
  AccountInformation? accountInformation;
  NotificationSettings? notificationSettings;
  String? id;
  String? firstName;
  String? lastName;
  String? referenceId;
  String? role;
  String? email;
  String? phone;
  String? country;
  String? city;
  String? profile;
  dynamic documentVerified;
  dynamic photo;
  bool? verified;
  String? status;
  String? userReport;
  String? subscription;
  dynamic stripeAccountId;
  List<dynamic>? prefreances;
  DateTime? lastActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? about;
  String? appId;
  String? businessName;
  String? service;
  String? fcmToken;
  String? address;
  List<Subscription>? subscriptions;
  int? totalSubscriptions;
  bool? hasUsedFreePlan;
  bool? isUserWaiting;

  ProfileModelData({
    this.location,
    this.accountInformation,
    this.notificationSettings,
    this.id,
    this.firstName,
    this.lastName,
    this.referenceId,
    this.role,
    this.email,
    this.phone,
    this.country,
    this.city,
    this.profile,
    this.documentVerified,
    this.photo,
    this.verified,
    this.status,
    this.userReport,
    this.subscription,
    this.stripeAccountId,
    this.prefreances,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.about,
    this.appId,
    this.businessName,
    this.service,
    this.fcmToken,
    this.subscriptions,
    this.totalSubscriptions,
    this.address,
    this.hasUsedFreePlan,
    this.isUserWaiting,
  });

  factory ProfileModelData.fromRawJson(String str) =>
      ProfileModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModelData.fromJson(
    Map<String, dynamic> json,
  ) => ProfileModelData(
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
    accountInformation: json["accountInformation"] == null
        ? null
        : AccountInformation.fromJson(json["accountInformation"]),
    notificationSettings: json["notificationSettings"] == null
        ? null
        : NotificationSettings.fromJson(json["notificationSettings"]),
    id: json["_id"] != null && json["_id"] is String
        ? json["_id"] as String
        : "",
    firstName: json["firstName"] != null && json["firstName"] is String
        ? json["firstName"] as String
        : "",
    lastName: json["lastName"] != null && json["lastName"] is String
        ? json["lastName"] as String
        : "",
    referenceId: json["referenceId"] != null && json["referenceId"] is String
        ? json["referenceId"] as String
        : "",
    role: json["role"] != null && json["role"] is String
        ? json["role"] as String
        : "",
    email: json["email"] != null && json["email"] is String
        ? json["email"] as String
        : "",
    phone: json["phone"] != null && json["phone"] is String
        ? json["phone"] as String
        : "",
    country: json["country"] != null && json["country"] is String
        ? json["country"] as String
        : "",
    city: json["city"] != null && json["city"] is String
        ? json["city"] as String
        : "",
    profile: json["profile"] != null && json["profile"] is String
        ? json["profile"] as String
        : "",
    documentVerified: json["documentVerified"],
    photo: json["photo"] != null && json["photo"] is String
        ? json["photo"] as String
        : "",
    verified: json["verified"] != null && json["verified"] is bool
        ? json["verified"] as bool
        : false,
    status: json["status"] != null && json["status"] is String
        ? json["status"] as String
        : "",
    address: json["address"] != null && json["address"] is String
        ? json["address"] as String
        : "",
    userReport: json["userReport"] != null && json["userReport"] is String
        ? json["userReport"] as String
        : "",
    subscription: json["subscription"] != null && json["subscription"] is String
        ? json["subscription"] as String
        : "",
    stripeAccountId: json["stripeAccountId"],
    prefreances: json["prefreances"] == null
        ? []
        : List<dynamic>.from(json["prefreances"]!.map((x) => x)),
    lastActive: json["lastActive"] == null
        ? null
        : DateTime.parse(json["lastActive"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    about: json["about"] != null && json["about"] is String
        ? json["about"] as String
        : "",
    appId: json["appId"] != null && json["appId"] is String
        ? json["appId"] as String
        : "",
    businessName: json["businessName"] != null && json["businessName"] is String
        ? json["businessName"] as String
        : "",
    service: json["service"] != null && json["service"] is String
        ? json["service"] as String
        : "",
    fcmToken: json["fcmToken"] != null && json["fcmToken"] is String
        ? json["fcmToken"] as String
        : "",
    subscriptions: json["subscriptions"] == null
        ? []
        : List<Subscription>.from(
            json["subscriptions"]!.map((x) => Subscription.fromJson(x)),
          ),
   
    totalSubscriptions: json["totalSubscriptions"],
    hasUsedFreePlan:
        json["hasUsedFreePlan"] != null && json["hasUsedFreePlan"] is bool
        ? json["hasUsedFreePlan"] as bool
        : false,
    isUserWaiting:
        json["isUserWaiting"] != null && json["isUserWaiting"] is bool
        ? json["isUserWaiting"] as bool
        : false,
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "accountInformation": accountInformation?.toJson(),
    "notificationSettings": notificationSettings?.toJson(),
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "referenceId": referenceId,
    "role": role,
    "email": email,
    "phone": phone,
    "country": country,
    "city": city,
    "profile": profile,
    "documentVerified": documentVerified,
    "photo": photo,
    "verified": verified,
    "status": status,
    "userReport": userReport,
    "subscription": subscription,
    "stripeAccountId": stripeAccountId,
    "address": address,
    "prefreances": prefreances == null
        ? []
        : List<dynamic>.from(prefreances!.map((x) => x)),
    "lastActive": lastActive?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "about": about,
    "appId": appId,
    "businessName": businessName,
    "service": service,
    "fcmToken": fcmToken,
    "subscriptions": subscriptions == null
        ? []
        : List<Subscription>.from(subscriptions!.map((x) => x.toJson())),
    
    "totalSubscriptions": totalSubscriptions,
    "hasUsedFreePlan": hasUsedFreePlan,
    "isUserWaiting": isUserWaiting,
  };
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

  factory AccountInformation.fromRawJson(String str) =>
      AccountInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountInformation.fromJson(Map<String, dynamic> json) =>
      AccountInformation(
        status: json["status"],
        stripeAccountId:
            json["stripeAccountId"] != null && json["stripeAccountId"] is String
            ? json["stripeAccountId"] as String
            : "",
        externalAccountId:
            json["externalAccountId"] != null &&
                json["externalAccountId"] is String
            ? json["externalAccountId"] as String
            : "",
        currency: json["currency"] != null && json["currency"] is String
            ? json["currency"] as String
            : "",
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "stripeAccountId": stripeAccountId,
    "externalAccountId": externalAccountId,
    "currency": currency,
  };
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: json["coordinates"] == null
        ? []
        : List<double>.from(json["coordinates"]!.map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates == null
        ? []
        : List<dynamic>.from(coordinates!.map((x) => x)),
  };
}

class NotificationSettings {
  bool? promotionalEmails;
  bool? appNotifications;
  bool? smsNotifications;
  bool? referralNotifications;
  bool? subscriptionNotifications;
  bool? pushNotifications;

  NotificationSettings({
    this.promotionalEmails,
    this.appNotifications,
    this.smsNotifications,
    this.referralNotifications,
    this.subscriptionNotifications,
    this.pushNotifications,
  });

  factory NotificationSettings.fromRawJson(String str) =>
      NotificationSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationSettings.fromJson(
    Map<String, dynamic> json,
  ) => NotificationSettings(
    promotionalEmails:
        json["promotionalEmails"] != null && json["promotionalEmails"] is bool
        ? json["promotionalEmails"] as bool
        : false,
    appNotifications:
        json["appNotifications"] != null && json["appNotifications"] is bool
        ? json["appNotifications"] as bool
        : false,
    smsNotifications:
        json["smsNotifications"] != null && json["smsNotifications"] is bool
        ? json["smsNotifications"] as bool
        : false,
    referralNotifications:
        json["referralNotifications"] != null &&
            json["referralNotifications"] is bool
        ? json["referralNotifications"] as bool
        : false,
    subscriptionNotifications:
        json["subscriptionNotifications"] != null &&
            json["subscriptionNotifications"] is bool
        ? json["subscriptionNotifications"] as bool
        : false,
    pushNotifications:
        json["pushNotifications"] != null && json["pushNotifications"] is bool
        ? json["pushNotifications"] as bool
        : false,
  );

  Map<String, dynamic> toJson() => {
    "promotionalEmails": promotionalEmails,
    "appNotifications": appNotifications,
    "smsNotifications": smsNotifications,
    "referralNotifications": referralNotifications,
    "subscriptionNotifications": subscriptionNotifications,
    "pushNotifications": pushNotifications,
  };
}

class Subscription {
  String? subscriptionId;
  String? packageId;
  String? packageTitle;
  num? price;
  String? duration;
  String? startDate;
  String? endDate;
  String? status;
  String? trxId;
  String? subscriptionStripeId;

  Subscription({
    this.subscriptionId,
    this.packageId,
    this.packageTitle,
    this.price,
    this.duration,
    this.startDate,
    this.endDate,
    this.status,
    this.trxId,
    this.subscriptionStripeId,
  });

  factory Subscription.fromRawJson(String str) =>
      Subscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    subscriptionId:
        json["subscriptionId"] != null && json["subscriptionId"] is String
        ? json["subscriptionId"] as String
        : "",
    packageId: json["packageId"] != null && json["packageId"] is String
        ? json["packageId"] as String
        : "",
    packageTitle: json["packageTitle"] != null && json["packageTitle"] is String
        ? json["packageTitle"] as String
        : "",
    price: json["price"] != null ? json["price"] as num : 0,
    duration: json["duration"] != null && json["duration"] is String
        ? json["duration"] as String
        : "",
    startDate: json["startDate"] != null
          ? json["startDate"] as String
        : "",
    endDate: json["endDate"] != null && json["endDate"] is String
        ? json["endDate"] as String
        : "",
    status: json["status"] != null && json["status"] is String
        ? json["status"] as String
        : "",
    trxId: json["trxId"] != null && json["trxId"] is String
        ? json["trxId"] as String
        : "",
    subscriptionStripeId:
        json["subscriptionStripeId"] != null &&
            json["subscriptionStripeId"] is String
        ? json["subscriptionStripeId"] as String
        : "",
  );

  Map<String, dynamic> toJson() => {
    "subscriptionId": subscriptionId,
    "packageId": packageId,
    "packageTitle": packageTitle,
    "price": price,
    "duration": duration,
    "startDate": startDate,
    "endDate": endDate,
    "status": status,
    "trxId": trxId,
    "subscriptionStripeId": subscriptionStripeId,
  };
}
