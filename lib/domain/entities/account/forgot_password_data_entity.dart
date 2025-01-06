class ForgotPasswordListDataMapper {
  List<ForgotPasswordDataEntity> listData;

  ForgotPasswordListDataMapper({
    required this.listData,
  });

  factory ForgotPasswordListDataMapper.fromJson(Map<String, dynamic> json) => ForgotPasswordListDataMapper(
        // listData: List<ForgotPasswordDataEntity>.from(json["listData"].map((x) => ForgotPasswordDataEntity.fromJson(x))),
        // listData: json["listData"] == null ? null : List<ForgotPasswordDataEntity>.from(json["listData"].map((x) => ForgotPasswordDataEntity.fromJson(x))),
        listData: (json["listData"] == null || json["listData"] == []) ? [] : List<ForgotPasswordDataEntity>.from(json["listData"].map((x) => ForgotPasswordDataEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "listData": List<dynamic>.from(listData.map((x) => x.toJson())),
      };
}

class ForgotPasswordDataEntity {
  String? email;
  String? otp;
  String? otpKey;
  String? resendOtpKey;
  String? forgotKey;

  ForgotPasswordDataEntity({
    this.email,
    this.otp,
    this.otpKey,
    this.resendOtpKey,
    this.forgotKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'otp_key': otpKey,
      'resend_otp_key': resendOtpKey,
      'forgot_key': forgotKey,
    };
  }

  factory ForgotPasswordDataEntity.fromJson(Map<String, dynamic> json) {
    // String data = json["notification"];
    return ForgotPasswordDataEntity(
      email: json['email'],
      otp: json['otp'],
      otpKey: json['otp_key'],
      resendOtpKey: json['resend_otp_key'],
      forgotKey: json['forgot_key'],
    );
  }
}
