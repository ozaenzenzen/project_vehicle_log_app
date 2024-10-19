// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/get_log_vehicle_data_response_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';


part 'hp2_get_list_log_event.dart';
part 'hp2_get_list_log_state.dart';

class Hp2GetListLogBloc extends Bloc<Hp2GetListLogEvent, Hp2GetListLogState> {
  Hp2GetListLogBloc(AppVehicleReposistory vehicleReposistory) : super(Hp2GetListLogInitial()) {
    on<Hp2GetListLogEvent>((event, emit) {
      if (event is Hp2GetListLogAction) {
        _hp2GetListLog(vehicleReposistory, event);
      }
    });
  }

  Future<void> _hp2GetListLog(
    AppVehicleReposistory vehicleReposistory,
    Hp2GetListLogAction event,
  ) async {
    emit(Hp2GetListLogLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          Hp2GetListLogFailed(
            errorMessage: "Failed To Get Support Data",
          ),
        );
        return;
      }

      GetLogVehicleResponseModelV2? result = await vehicleReposistory.getLogVehicleDataV2(
        userToken,
        event.reqData,
      );
      if (result == null) {
        emit(
          Hp2GetListLogFailed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
        return;
      }
      if (result.status != 200) {
        emit(
          Hp2GetListLogFailed(
            errorMessage: "${result.message}",
          ),
        );
        return;
      }
      if (result.data != null) {
        // AppLogger.debugLog("result.data: ${jsonEncode(result.toJson())}");
        emit(
          Hp2GetListLogSuccess(
            result: result.toLogDataEntity(),
          ),
        );
        return;
      }
    } catch (e) {
      emit(
        Hp2GetListLogFailed(
          errorMessage: "$e",
        ),
      );
    }
  }

  Map<String, List<Map<String, dynamic>>> groupByField(
    List<Map<String, dynamic>> items,
    String field,
  ) {
    var grouped = <String, List<Map<String, dynamic>>>{};

    for (var item in items) {
      var key = item[field] as String;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]?.add(item);
    }

    return grouped;
  }

  void groupByFunc(List<ListDatumGetLogVehicle> logData) {
    Map<String, List<ListDatumGetLogVehicle>> categorizedData = {};
    // List<LocalCategorizedVehicleLogData> categorizedDataAsList = [];
    for (ListDatumGetLogVehicle item in logData) {
      String category = item.measurementTitle!;
      if (!categorizedData.containsKey(category)) {
        categorizedData[category] = [];
      }
      categorizedData[category]!.add(item);
    }
  }
}
