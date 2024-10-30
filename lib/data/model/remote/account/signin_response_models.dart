import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';

class SignInResponseModel {
  int? status;
  String? message;
  SignInData? data;

  SignInResponseModel({
    this.status,
    this.message,
    this.data,
  });

  UserDataEntity? toUserDataEntity() {
    if (data != null) {
      return UserDataEntity.fromJson(data!.toJson());
    } else {
      return null;
    }
  }

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) => SignInResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : SignInData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class SignInData {
  int? id;
  String? userStamp;
  String? name;
  String? email;
  String? phone;
  String? accessToken;
  DateTime? accessTokenExpiryTime;
  String? refreshToken;
  DateTime? refreshTokenExpiryTime;

  SignInData({
    this.id,
    this.userStamp,
    this.name,
    this.email,
    this.phone,
    this.accessToken,
    this.accessTokenExpiryTime,
    this.refreshToken,
    this.refreshTokenExpiryTime,
  });

  factory SignInData.fromJson(Map<String, dynamic> json) => SignInData(
        id: json["id"],
        userStamp: json["user_stamp"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        accessToken: json["access_token"],
        accessTokenExpiryTime: json["access_token_expiry_time"] == null ? null : DateTime.parse(json["access_token_expiry_time"]),
        refreshToken: json["refresh_token"],
        refreshTokenExpiryTime: json["refresh_token_expiry_time"] == null ? null : DateTime.parse(json["refresh_token_expiry_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_stamp": userStamp,
        "name": name,
        "email": email,
        "phone": phone,
        "access_token": accessToken,
        "access_token_expiry_time": accessTokenExpiryTime?.toIso8601String(),
        "refresh_token": refreshToken,
        "refresh_token_expiry_time": refreshTokenExpiryTime?.toIso8601String(),
      };
}
