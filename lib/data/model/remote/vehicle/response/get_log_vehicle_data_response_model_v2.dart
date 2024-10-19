import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';

class GetLogVehicleResponseModelV2 {
  int? status;
  String? message;
  DataGetLogVehicle? data;

  GetLogVehicleResponseModelV2({
    this.status,
    this.message,
    this.data,
  });

  LogDataEntity? toLogDataEntity() {
    if (data != null) {
      return LogDataEntity.fromJson(data!.toJson());
    } else {
      return null;
    }
  }

  factory GetLogVehicleResponseModelV2.fromJson(Map<String, dynamic> json) => GetLogVehicleResponseModelV2(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : DataGetLogVehicle.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class DataGetLogVehicle {
  int? currentPage;
  int? nextPage;
  int? totalPages;
  int? totalItems;
  List<ListDatumGetLogVehicle>? listData;

  DataGetLogVehicle({
    this.currentPage,
    this.nextPage,
    this.totalPages,
    this.totalItems,
    this.listData,
  });

  factory DataGetLogVehicle.fromJson(Map<String, dynamic> json) => DataGetLogVehicle(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        listData: json["list_data"] == null ? [] : List<ListDatumGetLogVehicle>.from(json["list_data"]!.map((x) => ListDatumGetLogVehicle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_items": totalItems,
        "list_data": listData == null ? [] : List<dynamic>.from(listData!.map((x) => x.toJson())),
      };
}

class ListDatumGetLogVehicle {
  int? id;
  int? userId;
  String? userStamp;
  int? vehicleId;
  String? measurementTitle;
  String? currentOdo;
  String? estimateOdoChanging;
  String? amountExpenses;
  String? checkpointDate;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  ListDatumGetLogVehicle({
    this.id,
    this.userId,
    this.userStamp,
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

  factory ListDatumGetLogVehicle.fromJson(Map<String, dynamic> json) => ListDatumGetLogVehicle(
        id: json["id"],
        userId: json["user_id"],
        userStamp: json["user_stamp"],
        vehicleId: json["vehicle_id"],
        measurementTitle: json["measurement_title"],
        currentOdo: json["current_odo"],
        estimateOdoChanging: json["estimate_odo_changing"],
        amountExpenses: json["amount_expenses"],
        checkpointDate: json["checkpoint_date"],
        notes: json["notes"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "user_stamp": userStamp,
        "vehicle_id": vehicleId,
        "measurement_title": measurementTitle,
        "current_odo": currentOdo,
        "estimate_odo_changing": estimateOdoChanging,
        "amount_expenses": amountExpenses,
        "checkpoint_date": checkpointDate,
        "notes": notes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
