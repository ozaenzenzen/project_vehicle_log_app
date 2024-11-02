class SignInRequestModel {
  SignInRequestModel({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  factory SignInRequestModel.fromJson(Map<String, dynamic> json) => SignInRequestModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
