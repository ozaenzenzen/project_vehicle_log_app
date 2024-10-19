class AccountDataUserModel {
  AccountDataUserModel({
    this.userId,
    this.name,
    this.email,
    this.phone,
    // this.link,
    // this.typeuser,
    this.token,
  });

  int? userId;
  String? name;
  String? email;
  String? phone;
  // String? link;
  // int? typeuser;
  String? token;

  factory AccountDataUserModel.fromJson(Map<String, dynamic> json) => AccountDataUserModel(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        // link: json["link"],
        // typeuser: json["typeuser"],
        token: json["token"],
        // name: json["name"] ?? "",
        // email: json["email"] ?? "",
        // phone: json["phone"] ?? "",
        // link: json["link"] ?? "",
        // typeuser: json["typeuser"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        // "link": link,
        // "typeuser": typeuser,
        "token": token,
      };
}

// typeuser
// admin: 0
// user/volunteer: 1
// organization: 2