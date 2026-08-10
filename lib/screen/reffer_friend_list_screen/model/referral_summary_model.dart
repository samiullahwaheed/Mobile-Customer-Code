import 'dart:convert';

class ReferralSummaryModel {
  final bool success;
  final String message;
  final ReferralSummaryData? data;

  const ReferralSummaryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReferralSummaryModel.fromRawJson(String source) =>
      ReferralSummaryModel.fromJson(json.decode(source));

  factory ReferralSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReferralSummaryModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? ReferralSummaryData.fromJson(json['data'])
          : null,
    );
  }
}

/* -------------------- DATA -------------------- */

class ReferralSummaryData {
  final List<ReferralItem> referrals;
  final int totalReferrals;
  final double totalPoints; // ✅ double
  final int totalJoin;
  final String myReferenceId;

  const ReferralSummaryData({
    required this.referrals,
    required this.totalReferrals,
    required this.totalPoints,
    required this.totalJoin,
    required this.myReferenceId,
  });

  factory ReferralSummaryData.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? defaultValue;
    }

    double _toDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? defaultValue;
    }

    return ReferralSummaryData(
      referrals: json['referrals'] is List
          ? List<ReferralItem>.from(
              json['referrals'].map(
                (e) => ReferralItem.fromJson(e),
              ),
            )
          : <ReferralItem>[],
      totalReferrals: _toInt(json['totalReferrals']),
      totalPoints: _toDouble(json['totalPoints']), // ✅
      totalJoin: _toInt(json['totalJoin']),
      myReferenceId: json['myReferenceId']?.toString() ?? '',
    );
  }
}

/* -------------------- REFERRAL ITEM -------------------- */

class ReferralItem {
  final String id;
  final ReferralUser? user;
  final double pointsEarned; // ✅ double
  final double distance; // ✅ double

  const ReferralItem({
    required this.id,
    required this.user,
    required this.pointsEarned,
    required this.distance,
  });

  factory ReferralItem.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? defaultValue;
    }

    return ReferralItem(
      id: json['_id']?.toString() ?? '',
      user: json['user'] is Map<String, dynamic>
          ? ReferralUser.fromJson(json['user'])
          : null,
      pointsEarned: _toDouble(json['pointsEarned']), // ✅
      distance: _toDouble(json['distance']), // ✅
    );
  }
}

/* -------------------- USER -------------------- */

class ReferralUser {
  final String id;
  final String firstName;
  final String profile;
  final String status;
  final String address;

  const ReferralUser({
    required this.id,
    required this.firstName,
    required this.profile,
    required this.status,
    required this.address,
  });

  factory ReferralUser.fromJson(Map<String, dynamic> json) {
    return ReferralUser(
      id: json['_id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      profile: json['profile']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }
}
