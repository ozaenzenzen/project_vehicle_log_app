class VehicleDataEntity {
  int? currentPage;
  int? nextPage;
  int? totalPages;
  int? totalItems;
  List<ListDatumVehicleDataEntity>? listData;

  VehicleDataEntity({
    this.currentPage,
    this.nextPage,
    this.totalPages,
    this.totalItems,
    this.listData,
  });

  factory VehicleDataEntity.fromJson(Map<String, dynamic> json) => VehicleDataEntity(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        listData: json["list_data"] == null ? [] : List<ListDatumVehicleDataEntity>.from(json["list_data"]!.map((x) => ListDatumVehicleDataEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_items": totalItems,
        "list_data": listData == null ? [] : List<dynamic>.from(listData!.map((x) => x.toJson())),
      };
}

class ListDatumVehicleDataEntity {
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

  ListDatumVehicleDataEntity({
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

  factory ListDatumVehicleDataEntity.fromJson(Map<String, dynamic> json) => ListDatumVehicleDataEntity(
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
