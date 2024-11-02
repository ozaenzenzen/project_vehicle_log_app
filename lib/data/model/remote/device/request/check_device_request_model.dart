class CheckDeviceRequestModel {
  String? deviceId;
  String? deviceName;
  String? deviceType;
  String? osVersion;
  String? appVersion;
  String? pushToken;
  DateTime? lastActive;

  CheckDeviceRequestModel({
    this.deviceId,
    this.deviceName,
    this.deviceType,
    this.osVersion,
    this.appVersion,
    this.pushToken,
    this.lastActive,
  });

  factory CheckDeviceRequestModel.fromJson(Map<String, dynamic> json) => CheckDeviceRequestModel(
        deviceId: json["device_id"],
        deviceName: json["device_name"],
        deviceType: json["device_type"],
        osVersion: json["os_version"],
        appVersion: json["app_version"],
        pushToken: json["push_token"],
        lastActive: json["last_active"] == null ? null : DateTime.parse(json["last_active"]),
      );

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "device_name": deviceName,
        "device_type": deviceType,
        "os_version": osVersion,
        "app_version": appVersion,
        "push_token": pushToken,
        "last_active": lastActive?.toIso8601String(),
      };
}
