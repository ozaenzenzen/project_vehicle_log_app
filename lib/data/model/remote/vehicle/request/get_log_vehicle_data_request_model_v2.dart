class GetLogVehicleRequestModelV2 {
  int? limit;
  int? currentPage;
  String? sortOrder;
  String? vehicleId;

  GetLogVehicleRequestModelV2({
    this.limit,
    this.currentPage,
    this.sortOrder,
    this.vehicleId,
  });

  factory GetLogVehicleRequestModelV2.fromJson(Map<String, dynamic> json) => GetLogVehicleRequestModelV2(
        limit: json["limit"],
        currentPage: json["current_page"],
        sortOrder: json["sort_order"],
        vehicleId: json["vehicle_id"],
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "current_page": currentPage,
        "sort_order": sortOrder,
        "vehicle_id": vehicleId,
      };
}
