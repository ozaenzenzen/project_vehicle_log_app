import 'package:project_vehicle_log_app/support/app_date_time_helper.dart';

class GetAllVehicleDataResponseModel {
  dynamic status;
  String? message;
  List<DatumVehicle>? data;

  GetAllVehicleDataResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory GetAllVehicleDataResponseModel.fromJson(Map<String, dynamic> json) => GetAllVehicleDataResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : List<DatumVehicle>.from(json["Data"].map((x) => DatumVehicle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumVehicle {
  int? id;
  int? userId;
  String? vehicleName;
  String? vehicleImage;
  String? year;
  String? engineCapacity;
  String? tankCapacity;
  String? color;
  String? machineNumber;
  String? chassisNumber;
  List<VehicleMeasurementLogModel>? vehicleMeasurementLogModels;
  List<CategorizedVehicleLogData>? categorizedData;

  DatumVehicle({
    this.id,
    this.userId,
    this.vehicleName,
    this.vehicleImage,
    this.year,
    this.engineCapacity,
    this.tankCapacity,
    this.color,
    this.machineNumber,
    this.chassisNumber,
    this.vehicleMeasurementLogModels,
    this.categorizedData,
  });

  factory DatumVehicle.fromJson(Map<String, dynamic> json) => DatumVehicle(
        id: json["id"],
        userId: json["user_id"],
        vehicleName: json["vehicle_name"],
        vehicleImage: json["vehicle_image"],
        year: json["year"],
        engineCapacity: json["engine_capacity"],
        tankCapacity: json["tank_capacity"],
        color: json["color"],
        machineNumber: json["machine_number"],
        chassisNumber: json["chassis_number"],
        vehicleMeasurementLogModels: json["measurement_data"] == null
            ? null
            : List<VehicleMeasurementLogModel>.from(
                json["measurement_data"].map(
                  (x) => VehicleMeasurementLogModel.fromJson(x),
                ),
              ),
        // categorizedData: json["categorized_data"],
        categorizedData: (json["categorized_data"] == null)
            ? null
            : List<CategorizedVehicleLogData>.from(
                json["categorized_data"].map(
                  (x) => CategorizedVehicleLogData.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "vehicle_name": vehicleName,
        "vehicle_image": vehicleImage,
        "year": year,
        "engine_capacity": engineCapacity,
        "tank_capacity": tankCapacity,
        "color": color,
        "machine_number": machineNumber,
        "chassis_number": chassisNumber,
        "measurement_data": List<dynamic>.from(vehicleMeasurementLogModels!.map((x) => x.toJson())),
        "categorized_data": categorizedData,
      };
}

class VehicleMeasurementLogModel {
  int? id;
  int? userId;
  int? vehicleId;
  String? measurementTitle;
  String? currentOdo;
  String? estimateOdoChanging;
  String? amountExpenses;
  String? checkpointDate;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  VehicleMeasurementLogModel({
    this.id,
    this.userId,
    this.vehicleId,
    this.measurementTitle,
    this.currentOdo,
    this.estimateOdoChanging,
    this.amountExpenses,
    this.checkpointDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleMeasurementLogModel.fromJson(Map<String, dynamic> json) => VehicleMeasurementLogModel(
        id: json["id"],
        userId: json["user_id"],
        vehicleId: json["vehicle_id"],
        measurementTitle: json["measurement_title"],
        currentOdo: json["current_odo"],
        estimateOdoChanging: json["estimate_odo_changing"],
        amountExpenses: json["amount_expenses"],
        checkpointDate: json["checkpoint_date"],
        notes: json["notes"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(AppDateTimeHelper.processDateTime(json["created_at"])),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(AppDateTimeHelper.processDateTime(json["updated_at"])),
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
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class CategorizedVehicleLogData {
  String? measurementTitle;
  List<VehicleMeasurementLogModel>? vehicleMeasurementLogModels;

  CategorizedVehicleLogData({
    this.measurementTitle,
    this.vehicleMeasurementLogModels,
  });

  factory CategorizedVehicleLogData.fromJson(Map<String, dynamic> json) => CategorizedVehicleLogData(
        measurementTitle: json['measurement_title'],
        vehicleMeasurementLogModels: List<VehicleMeasurementLogModel>.from(
          json["measurement_data"].map(
            (x) => VehicleMeasurementLogModel.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "measurement_title": measurementTitle,
        "measurement_data": List<dynamic>.from(
          vehicleMeasurementLogModels!.map(
            (x) => x.toJson(),
          ),
        ),
      };
}
