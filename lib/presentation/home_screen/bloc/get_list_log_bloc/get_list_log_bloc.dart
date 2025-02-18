// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/get_log_vehicle_data_response_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/remote/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/log_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_log_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/presentation/home_screen/home_page.dart';

part 'get_list_log_event.dart';
part 'get_list_log_state.dart';

class GetListLogBloc extends Bloc<GetListLogEvent, GetListLogState> {
  GetListLogBloc(AppVehicleRepository vehicleRepository) : super(GetListLogInitial()) {
    on<GetListLogEvent>((event, emit) {
      if (event is GetListLogAction) {
        if (event.actionType == GetLogVehicleActionEnum.refresh) {
          currentPage = 1;
          responseData.listData = [];
          listResponseData = [];
          _hp2GetListLog(
            vehicleRepository,
            event,
          );
        } else {
          if (currentPage <= responseData.totalPages!) {
            currentPage++;
            _hp2GetListLog(
              vehicleRepository,
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
    AppVehicleRepository vehicleRepository,
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

      GetLogVehicleResponseModelV2? result = await vehicleRepository.getLogVehicleDataV2(
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

        Map<String, dynamic> dataCountFrequentTitle = jsonDecode(responseData.collectionLogData!.countFrequentTitles!);
        Map<String, dynamic> dataCostBreakdown = jsonDecode(responseData.collectionLogData!.costBreakdown!);
        // AppLoggerCS.debugLog("dataCountFrequentTitle: $dataCountFrequentTitle");
        // AppLoggerCS.debugLog("dataCostBreakdown: $dataCostBreakdown");

        List<ChartData> dataListCountFrequentTitle = dataCountFrequentTitle.entries.map((e) => ChartData(e.key, e.value)).toList();
        List<ChartData> dataListCostBreakdown = dataCostBreakdown.entries.map((e) => ChartData(e.key, e.value)).toList();
        // AppLoggerCS.debugLog("dataListCountFrequentTitle: $dataListCountFrequentTitle");
        // AppLoggerCS.debugLog("dataListCostBreakdown: $dataListCostBreakdown");

        emit(
          GetListLogSuccess(
            result: responseData,
            actionType: event.actionType,
            // dataCountFrequentTitle: dataCountFrequentTitle,
            // dataCostBreakdown: dataCostBreakdown,
            dataCountFrequentTitle: dataListCountFrequentTitle,
            dataCostBreakdown: dataListCostBreakdown,
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
