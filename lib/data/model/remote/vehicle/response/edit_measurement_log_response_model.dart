class EditMeasurementLogResponseModel {
  dynamic status;
  String message;

  EditMeasurementLogResponseModel({
    required this.status,
    required this.message,
  });

  factory EditMeasurementLogResponseModel.fromJson(Map<String, dynamic> json) => EditMeasurementLogResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
