class TokenDataEntity {
  String? userStamp;
  String? accessToken;
  DateTime? accessTokenExpiryTime;
  String? refreshToken;
  DateTime? refreshTokenExpiryTime;

  TokenDataEntity({
    this.userStamp,
    this.accessToken,
    this.accessTokenExpiryTime,
    this.refreshToken,
    this.refreshTokenExpiryTime,
  });

  factory TokenDataEntity.fromJson(Map<String, dynamic> json) => TokenDataEntity(
        userStamp: json["user_stamp"],
        accessToken: json["access_token"],
        accessTokenExpiryTime: json["access_token_expiry_time"] == null ? null : DateTime.parse(json["access_token_expiry_time"]),
        refreshToken: json["refresh_token"],
        refreshTokenExpiryTime: json["refresh_token_expiry_time"] == null ? null : DateTime.parse(json["refresh_token_expiry_time"]),
      );

  Map<String, dynamic> toJson() => {
        "user_stamp": userStamp,
        "access_token": accessToken,
        "access_token_expiry_time": accessTokenExpiryTime?.toIso8601String(),
        "refresh_token": refreshToken,
        "refresh_token_expiry_time": refreshTokenExpiryTime?.toIso8601String(),
      };
}
