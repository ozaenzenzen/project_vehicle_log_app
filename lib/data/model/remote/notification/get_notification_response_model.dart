import 'package:project_vehicle_log_app/support/app_date_time_helper.dart';

class GetNotificationResponseModel {
  dynamic status;
  String? message;
  List<Notification>? notification;

  GetNotificationResponseModel({
    this.status,
    this.message,
    this.notification,
  });

  factory GetNotificationResponseModel.fromJson(Map<String, dynamic> json) => GetNotificationResponseModel(
        status: json["status"],
        message: json["message"],
        notification: json["notification"] == null ? null : List<Notification>.from(json["notification"].map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "notification": List<dynamic>.from(notification!.map((x) => x.toJson())),
      };
}

class Notification {
  int? notificationId;
  int? userId;
  String? notificationTitle;
  String? notificationDescription;
  int? notificationStatus;
  int? notificationType;
  DateTime? createdAt;
  DateTime? updatedAt;

  Notification({
    this.notificationId,
    this.userId,
    this.notificationTitle,
    this.notificationDescription,
    this.notificationStatus,
    this.notificationType,
    this.createdAt,
    this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json["notification_id"],
      userId: json["user_id"],
      notificationTitle: json["notification_title"],
      notificationDescription: json["notification_description"],
      notificationStatus: json["notification_status"],
      notificationType: json["notification_type"],
      createdAt: json["created_at"] == null ? null : DateTime.parse(AppDateTimeHelper.processDateTime(json["created_at"])),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(AppDateTimeHelper.processDateTime(json["updated_at"])),
    );
  }

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "user_id": userId,
        "notification_title": notificationTitle,
        "notification_description": notificationDescription,
        "notification_status": notificationStatus,
        "notification_type": notificationType,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
