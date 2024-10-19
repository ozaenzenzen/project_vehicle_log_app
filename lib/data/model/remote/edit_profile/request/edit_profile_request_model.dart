class EditProfileRequestModel {
  String profilePicture;
  String name;

  EditProfileRequestModel({
    required this.profilePicture,
    required this.name,
  });

  factory EditProfileRequestModel.fromJson(Map<String, dynamic> json) => EditProfileRequestModel(
        profilePicture: json["profile_picture"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
        "name": name,
      };
}
