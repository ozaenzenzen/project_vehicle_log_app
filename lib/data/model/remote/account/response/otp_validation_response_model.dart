class OtpValidationResponseModel {
  int? status;
  String? message;

  OtpValidationResponseModel({
    this.status,
    this.message,
  });

  factory OtpValidationResponseModel.fromJson(Map<String, dynamic> json) => OtpValidationResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
