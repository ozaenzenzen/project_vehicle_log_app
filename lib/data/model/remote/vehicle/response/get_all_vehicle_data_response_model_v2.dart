import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';

class GetAllVehicleResponseModelV2 {
  int? status;
  String? message;
  DataGetAllVehicle? data;

  GetAllVehicleResponseModelV2({
    this.status,
    this.message,
    this.data,
  });

  VehicleDataEntity? toVehicleDataEntity() {
    if (data != null) {
      return VehicleDataEntity.fromJson(data!.toJson());
    } else {
      return null;
    }
  }

  factory GetAllVehicleResponseModelV2.fromJson(Map<String, dynamic> json) => GetAllVehicleResponseModelV2(
        status: json["status"],
        message: json["message"],
        data: json["Data"] == null ? null : DataGetAllVehicle.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "Data": data?.toJson(),
      };
}

class DataGetAllVehicle {
  int? currentPage;
  int? nextPage;
  int? totalPages;
  int? totalItems;
  List<ListDatumGetAllVehicle>? listData;

  DataGetAllVehicle({
    this.currentPage,
    this.nextPage,
    this.totalPages,
    this.totalItems,
    this.listData,
  });

  factory DataGetAllVehicle.fromJson(Map<String, dynamic> json) => DataGetAllVehicle(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        listData: json["list_data"] == null ? [] : List<ListDatumGetAllVehicle>.from(json["list_data"]!.map((x) => ListDatumGetAllVehicle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_items": totalItems,
        "list_data": listData == null ? [] : List<dynamic>.from(listData!.map((x) => x.toJson())),
      };
}

class ListDatumGetAllVehicle {
  int? id;
  int? userId;
  String? userStamp;
  String? vehicleName;
  String? vehicleImage;
  String? year;
  String? engineCapacity;
  String? tankCapacity;
  String? color;
  String? machineNumber;
  String? chassisNumber;
  List<String>? measurmentTitle;

  ListDatumGetAllVehicle({
    this.id,
    this.userId,
    this.userStamp,
    this.vehicleName,
    this.vehicleImage,
    this.year,
    this.engineCapacity,
    this.tankCapacity,
    this.color,
    this.machineNumber,
    this.chassisNumber,
    this.measurmentTitle,
  });

  factory ListDatumGetAllVehicle.fromJson(Map<String, dynamic> json) => ListDatumGetAllVehicle(
        id: json["id"],
        userId: json["user_id"],
        userStamp: json["user_stamp"],
        vehicleName: json["vehicle_name"],
        vehicleImage: json["vehicle_image"],
        year: json["year"],
        engineCapacity: json["engine_capacity"],
        tankCapacity: json["tank_capacity"],
        color: json["color"],
        machineNumber: json["machine_number"],
        chassisNumber: json["chassis_number"],
        measurmentTitle: json["measurment_title"] == null ? [] : List<String>.from(json["measurment_title"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "user_stamp": userStamp,
        "vehicle_name": vehicleName,
        "vehicle_image": vehicleImage,
        "year": year,
        "engine_capacity": engineCapacity,
        "tank_capacity": tankCapacity,
        "color": color,
        "machine_number": machineNumber,
        "chassis_number": chassisNumber,
        "measurment_title": measurmentTitle == null ? [] : List<dynamic>.from(measurmentTitle!.map((x) => x)),
      };
}
