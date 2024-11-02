class DeviceInfoDataEntity {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String osVersion;
  final String appVersion;
  final String? pushToken;
  final String registeredAt;

  DeviceInfoDataEntity({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.osVersion,
    required this.appVersion,
    this.pushToken,
    required this.registeredAt,
  });

  // Factory method to create a Device object from a map (useful for parsing JSON)
  factory DeviceInfoDataEntity.fromMap(Map<String, dynamic> map) {
    return DeviceInfoDataEntity(
      deviceId: map['deviceId'] ?? '',
      deviceName: map['deviceName'] ?? '',
      deviceType: map['deviceType'] ?? '',
      osVersion: map['osVersion'] ?? '',
      appVersion: map['appVersion'] ?? '',
      pushToken: map['pushToken'],
      registeredAt: map['registeredAt'] ?? '',
    );
  }

  // Method to convert a Device object to a map (useful for JSON encoding)
  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'osVersion': osVersion,
      'appVersion': appVersion,
      'pushToken': pushToken,
      'registeredAt': registeredAt,
    };
  }
}