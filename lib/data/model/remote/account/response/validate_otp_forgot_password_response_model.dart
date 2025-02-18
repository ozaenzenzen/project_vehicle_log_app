class ValidateOtpForgotPasswordResponseModel {
  int? status;
  String? message;

  ValidateOtpForgotPasswordResponseModel({
    this.status,
    this.message,
  });

  factory ValidateOtpForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) => ValidateOtpForgotPasswordResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
