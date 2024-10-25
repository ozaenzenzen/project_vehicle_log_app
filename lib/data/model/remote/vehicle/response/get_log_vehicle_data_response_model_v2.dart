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
  CollectionLogData? collectionLogData;
  List<ListDatumGetLogVehicle>? listData;

  DataGetLogVehicle({
    this.currentPage,
    this.nextPage,
    this.totalPages,
    this.totalItems,
    this.collectionLogData,
    this.listData,
  });

  factory DataGetLogVehicle.fromJson(Map<String, dynamic> json) => DataGetLogVehicle(
        currentPage: json["current_page"],
        nextPage: json["next_page"],
        totalPages: json["total_pages"],
        totalItems: json["total_items"],
        collectionLogData: json["collection_log_data"] == null ? null : CollectionLogData.fromJson(json["collection_log_data"]),
        listData: json["list_data"] == null ? [] : List<ListDatumGetLogVehicle>.from(json["list_data"]!.map((x) => ListDatumGetLogVehicle.fromJson(x))),
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

class CollectionLogData {
  int? totalExpenses;
  DateTime? lastCreatedAt;
  String? avgExpensesPerMeas;
  double? avgOdoChange;
  double? avgServiceFreq;
  String? mostFrequentTitles;
  String? countFrequentTitles;
  String? costBreakdown;
  List<String>? measurementTitles;

  CollectionLogData({
    this.totalExpenses,
    this.lastCreatedAt,
    this.avgExpensesPerMeas,
    this.avgOdoChange,
    this.avgServiceFreq,
    this.mostFrequentTitles,
    this.countFrequentTitles,
    this.costBreakdown,
    this.measurementTitles,
  });

  factory CollectionLogData.fromJson(Map<String, dynamic> json) => CollectionLogData(
        totalExpenses: json["total_expenses"],
        lastCreatedAt: json["last_created_at"] == null ? null : DateTime.parse(json["last_created_at"]),
        avgExpensesPerMeas: json["avg_expenses_per_meas"],
        avgOdoChange: json["avg_odo_change"]?.toDouble(),
        avgServiceFreq: json["avg_service_freq"]?.toDouble(),
        mostFrequentTitles: json["most_frequent_titles"],
        countFrequentTitles: json["count_frequent_titles"],
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
        "count_frequent_titles": countFrequentTitles,
        "cost_breakdown": costBreakdown,
        "measurement_titles": measurementTitles == null ? [] : List<dynamic>.from(measurementTitles!.map((x) => x)),
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
