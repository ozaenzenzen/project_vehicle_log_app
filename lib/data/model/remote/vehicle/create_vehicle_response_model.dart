class CreateVehicleResponseModel {
  dynamic status;
  String message;

  CreateVehicleResponseModel({
    required this.status,
    required this.message,
  });

  factory CreateVehicleResponseModel.fromJson(Map<String, dynamic> json) => CreateVehicleResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
