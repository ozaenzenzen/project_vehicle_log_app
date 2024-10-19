class EditVehicleResponseModel {
  int status;
  String message;

  EditVehicleResponseModel({
    required this.status,
    required this.message,
  });

  factory EditVehicleResponseModel.fromJson(Map<String, dynamic> json) => EditVehicleResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
