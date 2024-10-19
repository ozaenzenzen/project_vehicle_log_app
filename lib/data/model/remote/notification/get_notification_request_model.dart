class GetNotificationRequestModel {
  int? limit;
  int? currentPage;
  String? sortOrder;

  GetNotificationRequestModel({
    this.limit,
    this.currentPage,
    this.sortOrder,
  });

  factory GetNotificationRequestModel.fromJson(Map<String, dynamic> json) => GetNotificationRequestModel(
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
