class DeleteAccountResponseModel {
  int? status;
  String? message;

  DeleteAccountResponseModel({
    this.status,
    this.message,
  });

  factory DeleteAccountResponseModel.fromJson(Map<String, dynamic> json) => DeleteAccountResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
