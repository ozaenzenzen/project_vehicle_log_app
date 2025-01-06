class ChangePasswordForgotPasswordResponseModel {
  int? status;
  String? message;

  ChangePasswordForgotPasswordResponseModel({
    this.status,
    this.message,
  });

  factory ChangePasswordForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) => ChangePasswordForgotPasswordResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
