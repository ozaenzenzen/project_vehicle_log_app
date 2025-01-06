class OtpResendResponseModel {
  int? status;
  String? message;
  OtpResendData? data;

  OtpResendResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory OtpResendResponseModel.fromJson(Map<String, dynamic> json) => OtpResendResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : OtpResendData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class OtpResendData {
  String? otpKey;
  String? resendOtpKey;

  OtpResendData({
    this.otpKey,
    this.resendOtpKey,
  });

  factory OtpResendData.fromJson(Map<String, dynamic> json) => OtpResendData(
        otpKey: json["otp_key"],
        resendOtpKey: json["resend_otp_key"],
      );

  Map<String, dynamic> toJson() => {
        "otp_key": otpKey,
        "resend_otp_key": resendOtpKey,
      };
}
