import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';

class GetUserDataResponseModel {
  int? status;
  String? message;
  DataGetUserData? data;

  GetUserDataResponseModel({
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
        profilePicture: data?.profilePicture,
      );
    } else {
      return null;
    }
  }

  factory GetUserDataResponseModel.fromJson(Map<String, dynamic> json) => GetUserDataResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : DataGetUserData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class DataGetUserData {
  int? id;
  String? userStamp;
  String? name;
  String? email;
  String? phone;
  String? profilePicture;

  DataGetUserData({
    this.id,
    this.userStamp,
    this.name,
    this.email,
    this.phone,
    this.profilePicture,
  });

  factory DataGetUserData.fromJson(Map<String, dynamic> json) => DataGetUserData(
        id: json["id"],
        userStamp: json["user_stamp"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_stamp": userStamp,
        "name": name,
        "email": email,
        "phone": phone,
        "profile_picture": profilePicture,
      };
}
