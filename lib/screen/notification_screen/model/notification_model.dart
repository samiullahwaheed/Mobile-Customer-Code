import 'dart:convert';

class NotificationModel {
    bool? success;
    String? message;
    Pagination? pagination;
    NotificationModelData? data;

    NotificationModel({
        this.success,
        this.message,
        this.pagination,
        this.data,
    });

    factory NotificationModel.fromRawJson(String str) => NotificationModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        success: json["success"],
        message: json["message"],
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
        data: json["data"] == null ? null : NotificationModelData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "pagination": pagination?.toJson(),
        "data": data?.toJson(),
    };
}

class NotificationModelData {
    List<NotificationList>? notifications;
    int? unreadCount;

    NotificationModelData({
        this.notifications,
        this.unreadCount,
    });

    factory NotificationModelData.fromRawJson(String str) => NotificationModelData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NotificationModelData.fromJson(Map<String, dynamic> json) => NotificationModelData(
        notifications: json["notifications"] == null ? [] : List<NotificationList>.from(json["notifications"]!.map((x) => NotificationList.fromJson(x))),
        unreadCount: json["unreadCount"],
    );

    Map<String, dynamic> toJson() => {
        "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
        "unreadCount": unreadCount,
    };
}

class NotificationList {
    String? id;
    String? userId;
    String? title;
    String? body;
    String? type;
    bool? isRead;
    List<dynamic>? attachments;
    Channel? channel;
    int? v;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? timeAgo;

    NotificationList({
        this.id,
        this.userId,
        this.title,
        this.body,
        this.type,
        this.isRead,
        this.attachments,
        this.channel,
        this.v,
        this.createdAt,
        this.updatedAt,
        this.timeAgo,
    });

    factory NotificationList.fromRawJson(String str) => NotificationList.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NotificationList.fromJson(Map<String, dynamic> json) => NotificationList(
        id: json["_id"] != null && json["_id"] is String ? json["_id"] : "",
        userId: json["userId"] != null && json["userId"] is String ? json["userId"] : "",
        title: json["title"] != null && json["title"] is String ? json["title"] : "",
        body: json["body"] != null && json["body"] is String ? json["body"] : "",
        type: json["type"] != null && json["type"] is String ? json["type"] : "",
        isRead: json["isRead"] != null && json["isRead"] is bool ? json["isRead"] : false,
        attachments: json["attachments"] != null ? List<dynamic>.from(json["attachments"]!.map((x) => x)) : [],
        channel: json["channel"] != null ? Channel.fromJson(json["channel"]) : null,
        v: json["__v"] != null && json["__v"] is int ? json["__v"] : 0,
        createdAt: json["createdAt"] != null && json["createdAt"] is String ? DateTime.parse(json["createdAt"]) : null,
        updatedAt: json["updatedAt"] != null && json["updatedAt"] is String ? DateTime.parse(json["updatedAt"]) : null,
        timeAgo: json["timeAgo"] != null && json["timeAgo"] is String ? json["timeAgo"] : "",
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "title": title,
        "body": body,
        "type": type,
        "isRead": isRead,
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
        "channel": channel?.toJson(),
        "__v": v,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "timeAgo": timeAgo,
    };
}

class Channel {
    bool? socket;
    bool? push;

    Channel({
        this.socket,
        this.push,
    });

    factory Channel.fromRawJson(String str) => Channel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        socket: json["socket"],
        push: json["push"],
    );

    Map<String, dynamic> toJson() => {
        "socket": socket,
        "push": push,
    };
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

    factory Pagination.fromRawJson(String str) => Pagination.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        limit: json["limit"],
        page: json["page"],
        totalPage: json["totalPage"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "limit": limit,
        "page": page,
        "totalPage": totalPage,
    };
}
