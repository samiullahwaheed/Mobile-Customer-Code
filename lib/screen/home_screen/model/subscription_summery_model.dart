import 'dart:convert';

class UserSummaryModel {
  final bool success;
  final String message;
  final UserSummaryData? data;

  const UserSummaryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserSummaryModel.fromRawJson(String source) =>
      UserSummaryModel.fromJson(json.decode(source));

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? UserSummaryData.fromJson(json['data'])
          : null,
    );
  }
}

class UserSummaryData {
  final int totalSpent;
  final int totalDigitalCards;
  final int totalPromotions;
  final List<String> subscriptionTitles;

  const UserSummaryData({
    required this.totalSpent,
    required this.totalDigitalCards,
    required this.totalPromotions,
    required this.subscriptionTitles,
  });

  factory UserSummaryData.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? defaultValue;
    }

    return UserSummaryData(
      totalSpent: _toInt(json['totalSpent']),
      totalDigitalCards: _toInt(json['totalDigitalCards']),
      totalPromotions: _toInt(json['totalPromotions']),
      subscriptionTitles: json['subscriptionTitles'] is List
          ? List<String>.from(
              json['subscriptionTitles'].map((e) => e?.toString() ?? ''),
            )
          : <String>[],
    );
  }
}

