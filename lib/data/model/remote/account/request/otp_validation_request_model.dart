class OtpValidationRequestModel {
  String email;
  String otp;
  String otpKey;

  OtpValidationRequestModel({
    required this.email,
    required this.otp,
    required this.otpKey,
  });

  factory OtpValidationRequestModel.fromJson(Map<String, dynamic> json) => OtpValidationRequestModel(
        email: json["email"],
        otp: json["otp"],
        otpKey: json["otp_key"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
        "otp_key": otpKey,
      };
}
