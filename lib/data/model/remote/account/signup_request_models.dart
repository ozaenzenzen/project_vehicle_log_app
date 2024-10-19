class SignUpRequestModel {
  SignUpRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });

  String name;
  String email;
  String phone;
  String password;
  String confirmPassword;

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) => SignUpRequestModel(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "confirmPassword": confirmPassword,
      };
}
