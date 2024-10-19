class CreateLogVehicleResponseModel {
  dynamic status;
  String? message;

  CreateLogVehicleResponseModel({
    this.status,
    this.message,
  });

  factory CreateLogVehicleResponseModel.fromJson(Map<String, dynamic> json) => CreateLogVehicleResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
