class SendOtpForgotPasswordResponseModel {
  int? status;
  String? message;
  SendOtpForgotPasswordData? data;

  SendOtpForgotPasswordResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory SendOtpForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) => SendOtpForgotPasswordResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : SendOtpForgotPasswordData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class SendOtpForgotPasswordData {
  String? otpKey;
  String? resendOtpKey;
  String? forgotKey;

  SendOtpForgotPasswordData({
    this.otpKey,
    this.resendOtpKey,
    this.forgotKey,
  });

  factory SendOtpForgotPasswordData.fromJson(Map<String, dynamic> json) => SendOtpForgotPasswordData(
        otpKey: json["otp_key"],
        resendOtpKey: json["resend_otp_key"],
        forgotKey: json["forgot_key"],
      );

  Map<String, dynamic> toJson() => {
        "otp_key": otpKey,
        "resend_otp_key": resendOtpKey,
        "forgot_key": forgotKey,
      };
}
