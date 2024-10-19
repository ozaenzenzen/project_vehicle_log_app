class GetNotificationPaginationEntity {
  int? currentPage;
  int? nextPage;
  int? totalPages;
  int? totalItems;
  List<GetNotificationEntity>? listData;

  GetNotificationPaginationEntity({
    this.currentPage,
    this.nextPage,
    this.totalPages,
    this.totalItems,
    this.listData,
  });

  factory GetNotificationPaginationEntity.fromJson(Map<String, dynamic> json) => GetNotificationPaginationEntity(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        listData: json["list_data"] == null ? [] : List<GetNotificationEntity>.from(json["list_data"]!.map((x) => GetNotificationEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_items": totalItems,
        "list_data": listData == null ? [] : List<dynamic>.from(listData!.map((x) => x.toJson())),
      };
}

class GetNotificationEntity {
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

  GetNotificationEntity({
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

  factory GetNotificationEntity.fromJson(Map<String, dynamic> json) => GetNotificationEntity(
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
