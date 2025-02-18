import 'package:project_vehicle_log_app/domain/entities/account/user_data_entity.dart';

class SignUpResponseModel {
  int? status;
  String? message;
  SignUpData? data;

  SignUpResponseModel({
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

  UserDataEntity? toUserDataEntityWithoutToken() {
    if (data != null) {
      return UserDataEntity(
        id: data?.id,
        userStamp: data?.userStamp,
        name: data?.name,
        email: data?.email,
        phone: data?.phone,
      );
    } else {
      return null;
    }
  }

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) => SignUpResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : SignUpData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class SignUpData {
  int? id;
  String? userStamp;
  String? name;
  String? email;
  String? phone;
  String? otpKey;
  String? resendOtpKey;

  SignUpData({
    this.id,
    this.userStamp,
    this.name,
    this.email,
    this.phone,
    this.otpKey,
    this.resendOtpKey,
  });

  factory SignUpData.fromJson(Map<String, dynamic> json) => SignUpData(
        id: json["id"],
        userStamp: json["user_stamp"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        otpKey: json["otp_key"],
        resendOtpKey: json["resend_otp_key"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_stamp": userStamp,
        "name": name,
        "email": email,
        "phone": phone,
        "otp_key": otpKey,
        "resend_otp_key": resendOtpKey,
      };
}
