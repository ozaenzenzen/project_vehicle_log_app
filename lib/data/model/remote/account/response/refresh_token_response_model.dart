class RefreshTokenResponseModel {
  int? status;
  String? message;
  DataRefreshToken? data;

  RefreshTokenResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) => RefreshTokenResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : DataRefreshToken.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class DataRefreshToken {
  String? accessToken;
  DateTime? accessTokenExpiryTime;
  String? refreshToken;
  DateTime? refreshTokenExpiryTime;

  DataRefreshToken({
    this.accessToken,
    this.accessTokenExpiryTime,
    this.refreshToken,
    this.refreshTokenExpiryTime,
  });

  factory DataRefreshToken.fromJson(Map<String, dynamic> json) => DataRefreshToken(
        accessToken: json["access_token"],
        accessTokenExpiryTime: json["access_token_expiry_time"] == null ? null : DateTime.parse(json["access_token_expiry_time"]),
        refreshToken: json["refresh_token"],
        refreshTokenExpiryTime: json["refresh_token_expiry_time"] == null ? null : DateTime.parse(json["refresh_token_expiry_time"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "access_token_expiry_time": accessTokenExpiryTime?.toIso8601String(),
        "refresh_token": refreshToken,
        "refresh_token_expiry_time": refreshTokenExpiryTime?.toIso8601String(),
      };
}
