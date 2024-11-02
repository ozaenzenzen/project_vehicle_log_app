import 'package:project_vehicle_log_app/support/app_date_time_helper.dart';

class GetLogVehicleDataResponseModel {
  int status;
  String message;
  List<Datum>? data;

  GetLogVehicleDataResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetLogVehicleDataResponseModel.fromJson(Map<String, dynamic> json) => GetLogVehicleDataResponseModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int userId;
  int vehicleId;
  String measurementTitle;
  String currentOdo;
  String estimateOdoChanging;
  String amountExpenses;
  String checkpointDate;
  String notes;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.measurementTitle,
    required this.currentOdo,
    required this.estimateOdoChanging,
    required this.amountExpenses,
    required this.checkpointDate,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        vehicleId: json["vehicle_id"],
        measurementTitle: json["measurement_title"],
        currentOdo: json["current_odo"],
        estimateOdoChanging: json["estimate_odo_changing"],
        amountExpenses: json["amount_expenses"],
        checkpointDate: json["checkpoint_date"],
        notes: json["notes"],
        createdAt: DateTime.parse(AppDateTimeHelper.processDateTime(json["created_at"])),
        updatedAt: DateTime.parse(AppDateTimeHelper.processDateTime(json["updated_at"])),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "vehicle_id": vehicleId,
        "measurement_title": measurementTitle,
        "current_odo": currentOdo,
        "estimate_odo_changing": estimateOdoChanging,
        "amount_expenses": amountExpenses,
        "checkpoint_date": checkpointDate,
        "notes": notes,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
