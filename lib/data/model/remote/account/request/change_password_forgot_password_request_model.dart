class ChangePasswordForgotPasswordRequestModel {
  String forgotKey;
  String newPassword;
  String confirmNewPassword;

  ChangePasswordForgotPasswordRequestModel({
    required this.forgotKey,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  factory ChangePasswordForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) => ChangePasswordForgotPasswordRequestModel(
        forgotKey: json["forgot_key"],
        newPassword: json["new_password"],
        confirmNewPassword: json["confirm_new_password"],
      );

  Map<String, dynamic> toJson() => {
        "forgot_key": forgotKey,
        "new_password": newPassword,
        "confirm_new_password": confirmNewPassword,
      };
}
