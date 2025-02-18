class ChangePasswordRequestModel {
  String oldPassword;
  String newPassword;
  String confirmNewPassword;

  ChangePasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) => ChangePasswordRequestModel(
        oldPassword: json["old_password"],
        newPassword: json["new_password"],
        confirmNewPassword: json["confirm_new_password"],
      );

  Map<String, dynamic> toJson() => {
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_new_password": confirmNewPassword,
      };
}
