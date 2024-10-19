class GetAllVehicleRequestModelV2 {
  int? limit;
  int? currentPage;
  String? sortOrder;

  GetAllVehicleRequestModelV2({
    this.limit,
    this.currentPage,
    this.sortOrder,
  });

  factory GetAllVehicleRequestModelV2.fromJson(Map<String, dynamic> json) => GetAllVehicleRequestModelV2(
        limit: json["limit"],
        currentPage: json["current_page"],
        sortOrder: json["sort_order"],
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "current_page": currentPage,
        "sort_order": sortOrder,
      };
}
