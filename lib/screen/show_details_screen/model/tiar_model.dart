import 'dart:convert';

class TiarModel {
    bool? success;
    String? message;
    Pagination? pagination;
    List<TiarDataModel>? data;

    TiarModel({
        this.success,
        this.message,
        this.pagination,
        this.data,
    });

    factory TiarModel.fromRawJson(String str) =>
        TiarModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TiarModel.fromJson(Map<String, dynamic> json) => TiarModel(
        success: json["success"],
        message: json["message"],
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        data: json["data"] == null
            ? []
            : List<TiarDataModel>.from(
            json["data"]!.map((x) => TiarDataModel.fromJson(x))),
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

class TiarDataModel {
    String? id;
    String? name;
    int? pointsThreshold;

    // Backend returns `reward` as a Number (schema: { type: Number, default: 0 }),
    // so it must be parsed as a number, not a String. Parsing it as String was
    // throwing a type error and making the whole tier list fail to load, which
    // hid the "View Point & Tiers" button.
    num? reward;

    int? accumulationRule;
    int? redemptionRule;
    int? minTotalSpend;
    bool? isActive;
    String? admin;
    DateTime? createdAt;
    DateTime? updatedAt;

    TiarDataModel({
        this.id,
        this.name,
        this.pointsThreshold,
        this.reward,
        this.accumulationRule,
        this.redemptionRule,
        this.minTotalSpend,
        this.isActive,
        this.admin,
        this.createdAt,
        this.updatedAt,
    });

    factory TiarDataModel.fromRawJson(String str) =>
        TiarDataModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TiarDataModel.fromJson(Map<String, dynamic> json) => TiarDataModel(
        id: json["_id"]?.toString(),
        name: json["name"]?.toString(),
        pointsThreshold: _toInt(json["pointsThreshold"]),
        reward: _toNum(json["reward"]),
        accumulationRule: _toInt(json["accumulationRule"]),
        redemptionRule: _toInt(json["redemptionRule"]),
        minTotalSpend: _toInt(json["minTotalSpend"]),
        isActive: json["isActive"],
        admin: json["admin"]?.toString(),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "pointsThreshold": pointsThreshold,
        "reward": reward,
        "accumulationRule": accumulationRule,
        "redemptionRule": redemptionRule,
        "minTotalSpend": minTotalSpend,
        "isActive": isActive,
        "admin": admin,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}

/// Safely converts a dynamic JSON value (int, double, or numeric String)
/// into an int, without throwing. Returns null if it cannot be parsed.
int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
}

/// Safely converts a dynamic JSON value (int, double, or numeric String)
/// into a num, without throwing. Returns null if it cannot be parsed.
num? _toNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
}

class Pagination {
    int? total;
    int? limit;
    int? page;
    int? totalPage;

    Pagination({
        this.total,
        this.limit,
        this.page,
        this.totalPage,
    });

    factory Pagination.fromRawJson(String str) =>
        Pagination.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: _toInt(json["total"]),
        limit: _toInt(json["limit"]),
        page: _toInt(json["page"]),
        totalPage: _toInt(json["totalPage"]),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "limit": limit,
        "page": page,
        "totalPage": totalPage,
    };
}