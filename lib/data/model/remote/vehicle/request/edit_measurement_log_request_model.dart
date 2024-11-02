class EditMeasurementLogRequestModel {
  int? id;
  int? vehicleId;
  String? measurementTitle;
  String? currentOdo;
  String? estimateOdoChanging;
  String? amountExpenses;
  String? checkpointDate;
  String? notes;

  EditMeasurementLogRequestModel({
    this.id,
    this.vehicleId,
    this.measurementTitle,
    this.currentOdo,
    this.estimateOdoChanging,
    this.amountExpenses,
    this.checkpointDate,
    this.notes,
  });

  factory EditMeasurementLogRequestModel.fromJson(Map<String, dynamic> json) => EditMeasurementLogRequestModel(
        id: json["id"],
        vehicleId: json["vehicle_id"],
        measurementTitle: json["measurement_title"],
        currentOdo: json["current_odo"],
        estimateOdoChanging: json["estimate_odo_changing"],
        amountExpenses: json["amount_expenses"],
        checkpointDate: json["checkpoint_date"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_id": vehicleId,
        "measurement_title": measurementTitle,
        "current_odo": currentOdo,
        "estimate_odo_changing": estimateOdoChanging,
        "amount_expenses": amountExpenses,
        "checkpoint_date": checkpointDate,
        "notes": notes,
      };
}
