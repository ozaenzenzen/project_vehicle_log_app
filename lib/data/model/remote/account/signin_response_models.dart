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
  String? token;
  String? refreshToken;

  SignInData({
    this.id,
    this.userStamp,
    this.name,
    this.email,
    this.phone,
    this.token,
    this.refreshToken,
  });

  factory SignInData.fromJson(Map<String, dynamic> json) => SignInData(
        id: json["id"],
        userStamp: json["user_stamp"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        token: json["token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_stamp": userStamp,
        "name": name,
        "email": email,
        "phone": phone,
        "token": token,
        "refresh_token": refreshToken,
      };
}
