class CreateLogVehicleRequestModel {
  // int userId;
  int vehicleId;
  String measurementTitle;
  String currentOdo;
  String estimateOdoChanging;
  String amountExpenses;
  String checkpointDate;
  String notes;

  CreateLogVehicleRequestModel({
    // required this.userId,
    required this.vehicleId,
    required this.measurementTitle,
    required this.currentOdo,
    required this.estimateOdoChanging,
    required this.amountExpenses,
    required this.checkpointDate,
    required this.notes,
  });

  factory CreateLogVehicleRequestModel.fromJson(Map<String, dynamic> json) => CreateLogVehicleRequestModel(
        // userId: json["user_id"],
        vehicleId: json["vehicle_id"],
        measurementTitle: json["measurement_title"],
        currentOdo: json["current_odo"],
        estimateOdoChanging: json["estimate_odo_changing"],
        amountExpenses: json["amount_expenses"],
        checkpointDate: json["checkpoint_date"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        // "user_id": userId,
        "vehicle_id": vehicleId,
        "measurement_title": measurementTitle,
        "current_odo": currentOdo,
        "estimate_odo_changing": estimateOdoChanging,
        "amount_expenses": amountExpenses,
        "checkpoint_date": checkpointDate,
        "notes": notes,
      };
}
