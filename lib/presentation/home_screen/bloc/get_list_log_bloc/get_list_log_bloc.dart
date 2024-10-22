// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/get_log_vehicle_data_response_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_log_vehicle_action_enum.dart';

part 'get_list_log_event.dart';
part 'get_list_log_state.dart';

class GetListLogBloc extends Bloc<GetListLogEvent, GetListLogState> {
  GetListLogBloc(AppVehicleReposistory vehicleReposistory) : super(GetListLogInitial()) {
    on<GetListLogEvent>((event, emit) {
      if (event is GetListLogAction) {
        if (event.actionType == GetLogVehicleActionEnum.refresh) {
          currentPage = 1;
          responseData.listData = [];
          listResponseData = [];
          _hp2GetListLog(
            vehicleReposistory,
            event,
          );
        } else {
          if (currentPage <= responseData.totalPages!) {
            currentPage++;
            _hp2GetListLog(
              vehicleReposistory,
              event,
            );
          } else {
            emit(
              GetListLogSuccess(
                result: responseData,
                actionType: GetLogVehicleActionEnum.loadMore,
              ),
            );
          }
        }
      }
    });
  }

  LogDataEntity responseData = LogDataEntity();
  List<ListDatumLogEntity>? listResponseData = [];
  int currentPage = 1;

  Future<void> _hp2GetListLog(
    AppVehicleReposistory vehicleReposistory,
    GetListLogAction event,
  ) async {
    emit(
      GetListLogLoading(
        actionType: event.actionType,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          GetListLogFailed(
            errorMessage: "Failed To Get Support Data",
          ),
        );
        return;
      }

      GetLogVehicleRequestModelV2 dataRequest = event.reqData;
      dataRequest.currentPage = currentPage;

      GetLogVehicleResponseModelV2? result = await vehicleReposistory.getLogVehicleDataV2(
        userToken,
        event.reqData,
      );
      if (result == null) {
        emit(
          GetListLogFailed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
        return;
      }
      if (result.status != 200) {
        emit(
          GetListLogFailed(
            errorMessage: "${result.message}",
          ),
        );
        return;
      }
      if (result.data != null) {
        responseData = result.toLogDataEntity()!;
        listResponseData?.addAll(result.toLogDataEntity()!.listData!);
        responseData.listData = listResponseData;
        emit(
          GetListLogSuccess(
            result: responseData,
            actionType: event.actionType,
          ),
        );
        return;
      }
    } catch (errorMessage) {
      emit(
        GetListLogFailed(
          errorMessage: "$errorMessage",
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
