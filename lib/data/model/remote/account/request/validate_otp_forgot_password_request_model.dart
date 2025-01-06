class ValidateOtpForgotPasswordRequestModel {
  String email;
  String otp;
  String otpKey;
  String forgotKey;

  ValidateOtpForgotPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.otpKey,
    required this.forgotKey,
  });

  factory ValidateOtpForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) => ValidateOtpForgotPasswordRequestModel(
        email: json["email"],
        otp: json["otp"],
        otpKey: json["otp_key"],
        forgotKey: json["forgot_key"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
        "otp_key": otpKey,
        "forgot_key": forgotKey,
      };
}
