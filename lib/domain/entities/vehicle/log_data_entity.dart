class LogDataEntity {
  int? currentPage;
  int? nextPage;
  int? totalPages;
  int? totalItems;
  CollectionLogDataEntity? collectionLogData;
  List<ListDatumLogEntity>? listData;

  LogDataEntity({
    this.currentPage,
    this.nextPage,
    this.totalPages,
    this.totalItems,
    this.collectionLogData,
    this.listData,
  });

  factory LogDataEntity.fromJson(Map<String, dynamic> json) => LogDataEntity(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        collectionLogData: json["collection_log_data"] == null ? null : CollectionLogDataEntity.fromJson(json["collection_log_data"]),
        listData: json["list_data"] == null ? [] : List<ListDatumLogEntity>.from(json["list_data"]!.map((x) => ListDatumLogEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "next_page": nextPage,
        "total_pages": totalPages,
        "total_items": totalItems,
        "collection_log_data": collectionLogData?.toJson(),
        "list_data": listData == null ? [] : List<dynamic>.from(listData!.map((x) => x.toJson())),
      };
}

class CollectionLogDataEntity {
  int? totalExpenses;
  DateTime? lastCreatedAt;
  String? avgExpensesPerMeas;
  double? avgOdoChange;
  double? avgServiceFreq;
  String? mostFrequentTitles;
  String? costBreakdown;
  List<String>? measurementTitles;

  CollectionLogDataEntity({
    this.totalExpenses,
    this.lastCreatedAt,
    this.avgExpensesPerMeas,
    this.avgOdoChange,
    this.avgServiceFreq,
    this.mostFrequentTitles,
    this.costBreakdown,
    this.measurementTitles,
  });

  factory CollectionLogDataEntity.fromJson(Map<String, dynamic> json) => CollectionLogDataEntity(
        totalExpenses: json["total_expenses"],
        lastCreatedAt: json["last_created_at"] == null ? null : DateTime.parse(json["last_created_at"]),
        avgExpensesPerMeas: json["avg_expenses_per_meas"],
        avgOdoChange: json["avg_odo_change"]?.toDouble(),
        avgServiceFreq: json["avg_service_freq"]?.toDouble(),
        mostFrequentTitles: json["most_frequent_titles"],
        costBreakdown: json["cost_breakdown"],
        measurementTitles: json["measurement_titles"] == null ? [] : List<String>.from(json["measurement_titles"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "total_expenses": totalExpenses,
        "last_created_at": lastCreatedAt?.toIso8601String(),
        "avg_expenses_per_meas": avgExpensesPerMeas,
        "avg_odo_change": avgOdoChange,
        "avg_service_freq": avgServiceFreq,
        "most_frequent_titles": mostFrequentTitles,
        "cost_breakdown": costBreakdown,
        "measurement_titles": measurementTitles == null ? [] : List<dynamic>.from(measurementTitles!.map((x) => x)),
      };
}

class ListDatumLogEntity {
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

  ListDatumLogEntity({
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

  factory ListDatumLogEntity.fromJson(Map<String, dynamic> json) => ListDatumLogEntity(
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
