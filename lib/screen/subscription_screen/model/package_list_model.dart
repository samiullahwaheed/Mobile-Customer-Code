import 'dart:convert';

class PackageListModel {
  final bool success;
  final String message;
  final List<PackageModel> data;

  PackageListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PackageListModel.fromRawJson(String str) =>
      PackageListModel.fromJson(json.decode(str));

  factory PackageListModel.fromJson(Map<String, dynamic> json) {
    return PackageListModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? List<PackageModel>.from(
              json['data'].map((x) => PackageModel.fromJson(x)),
            )
          : [],
    );
  }
}

class PackageModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String duration;
  final String paymentType;
  final List<String> features;
  final String productId;
  final String priceId;
  final double loginLimit;
  final String status;
  final String admin;
  final bool isFreeTrial;
  final String createdAt;
  final String updatedAt;

  PackageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.paymentType,
    required this.features,
    required this.productId,
    required this.priceId,
    required this.loginLimit,
    required this.status,
    required this.admin,
    required this.isFreeTrial,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? defaultValue;
    }

    return PackageModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _toDouble(json['price']),
      duration: json['duration']?.toString() ?? '',
      paymentType: json['paymentType']?.toString() ?? '',
      features: json['features'] is List
          ? List<String>.from(
              json['features'].map((x) => x.toString()),
            )
          : [],
      productId: json['productId']?.toString() ?? '',
      priceId: json['priceId']?.toString() ?? '',
      loginLimit: _toDouble(json['loginLimit']),
      status: json['status']?.toString() ?? '',
      admin: json['admin']?.toString() ?? '',
      isFreeTrial: json['isFreeTrial'] == true,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}
