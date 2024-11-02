class CheckDeviceResponseModel {
  int? status;
  String? message;
  Data? data;

  CheckDeviceResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CheckDeviceResponseModel.fromJson(Map<String, dynamic> json) => CheckDeviceResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class Data {
  String? deviceId;
  String? userStamp;
  String? deviceStamp;
  String? deviceName;
  String? deviceType;
  String? osVersion;
  String? appVersion;
  String? pushToken;
  DateTime? lastActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.deviceId,
    this.userStamp,
    this.deviceStamp,
    this.deviceName,
    this.deviceType,
    this.osVersion,
    this.appVersion,
    this.pushToken,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        deviceId: json["device_id"],
        userStamp: json["user_stamp"],
        deviceStamp: json["device_stamp"],
        deviceName: json["device_name"],
        deviceType: json["device_type"],
        osVersion: json["os_version"],
        appVersion: json["app_version"],
        pushToken: json["push_token"],
        lastActive: json["last_active"] == null ? null : DateTime.parse(json["last_active"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "user_stamp": userStamp,
        "device_stamp": deviceStamp,
        "device_name": deviceName,
        "device_type": deviceType,
        "os_version": osVersion,
        "app_version": appVersion,
        "push_token": pushToken,
        "last_active": lastActive?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
