import 'package:project_vehicle_log_app/domain/entities/notification/notification_data_entity.dart';

class GetNotificationResponseModelV2 {
  int? status;
  String? message;
  GetNotificationPaginationData? data;

  GetNotificationResponseModelV2({
    this.status,
    this.message,
    this.data,
  });

  GetNotificationPaginationEntity? toGetNotificationEntity() {
    if (data != null) {
      GetNotificationPaginationEntity result = GetNotificationPaginationEntity.fromJson(data!.toJson());
      return result;
    } else {
      return null;
    }
  }

  factory GetNotificationResponseModelV2.fromJson(Map<String, dynamic> json) => GetNotificationResponseModelV2(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : GetNotificationPaginationData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class GetNotificationPaginationData {
  int? currentPage;
  int? nextPage;
  int? totalPages;
  int? totalItems;
  List<GetNotificationListData>? listData;

  GetNotificationPaginationData({
    this.currentPage,
    this.nextPage,
    this.totalPages,
    this.totalItems,
    this.listData,
  });

  factory GetNotificationPaginationData.fromJson(Map<String, dynamic> json) => GetNotificationPaginationData(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        listData: json["list_data"] == null ? [] : List<GetNotificationListData>.from(json["list_data"]!.map((x) => GetNotificationListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_items": totalItems,
        "list_data": listData == null ? [] : List<dynamic>.from(listData!.map((x) => x.toJson())),
      };
}

class GetNotificationListData {
  int? notificationId;
  int? userId;
  String? userStamp;
  String? notificationTitle;
  String? notificationDescription;
  int? notificationStatus;
  int? notificationType;
  String? notificationStamp;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetNotificationListData({
    this.notificationId,
    this.userId,
    this.userStamp,
    this.notificationTitle,
    this.notificationDescription,
    this.notificationStatus,
    this.notificationType,
    this.notificationStamp,
    this.createdAt,
    this.updatedAt,
  });

  factory GetNotificationListData.fromJson(Map<String, dynamic> json) => GetNotificationListData(
        notificationId: json["notification_id"],
        userId: json["user_id"],
        userStamp: json["user_stamp"]!,
        notificationTitle: json["notification_title"]!,
        notificationDescription: json["notification_description"]!,
        notificationStatus: json["notification_status"],
        notificationType: json["notification_type"],
        notificationStamp: json["notification_stamp"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "user_id": userId,
        "user_stamp": userStamp,
        "notification_title": notificationTitle,
        "notification_description": notificationDescription,
        "notification_status": notificationStatus,
        "notification_type": notificationType,
        "notification_stamp": notificationStamp,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
