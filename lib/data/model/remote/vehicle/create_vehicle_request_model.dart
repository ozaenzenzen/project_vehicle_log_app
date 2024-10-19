class CreateVehicleRequestModel {
  int userId;
  String vehicleName;
  String vehicleImage;
  String year;
  String engineCapacity;
  String tankCapacity;
  String color;
  String machineNumber;
  String chassisNumber;

  CreateVehicleRequestModel({
    required this.userId,
    required this.vehicleName,
    required this.vehicleImage,
    required this.year,
    required this.engineCapacity,
    required this.tankCapacity,
    required this.color,
    required this.machineNumber,
    required this.chassisNumber,
  });

  factory CreateVehicleRequestModel.fromJson(Map<String, dynamic> json) => CreateVehicleRequestModel(
        userId: json["user_id"],
        vehicleName: json["vehicle_name"],
        vehicleImage: json["vehicle_image"],
        year: json["year"],
        engineCapacity: json["engine_capacity"],
        tankCapacity: json["tank_capacity"],
        color: json["color"],
        machineNumber: json["machine_number"],
        chassisNumber: json["chassis_number"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "vehicle_name": vehicleName,
        "vehicle_image": vehicleImage,
        "year": year,
        "engine_capacity": engineCapacity,
        "tank_capacity": tankCapacity,
        "color": color,
        "machine_number": machineNumber,
        "chassis_number": chassisNumber,
      };
}
