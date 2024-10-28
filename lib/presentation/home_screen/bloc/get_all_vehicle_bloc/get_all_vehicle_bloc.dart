// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/get_all_vehicle_data_response_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/vehicle/vehicle_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/get_all_vehicle_action_enum.dart';
import 'package:project_vehicle_log_app/support/app_logger.dart';

part 'get_all_vehicle_event.dart';
part 'get_all_vehicle_state.dart';

class GetAllVehicleBloc extends Bloc<GetAllVehicleEvent, GetAllVehicleState> {
  GetAllVehicleBloc(AppVehicleReposistory appVehicleReposistory) : super(GetAllVehicleInitial()) {
    on<GetAllVehicleEvent>((event, emit) {
      AppLogger.debugLog("event in: $event");
      if (event is GetAllVehicleLocalAction) {
        _getAllVehicleLocalActionV2(
          appVehicleReposistory,
          event,
        );
      }
      if (event is GetAllVehicleRemoteAction) {
        if (event.action == GetAllVehicleActionEnum.refresh) {
          currentPage = 1;
          responseData.listData = [];
          listResponseData = [];
          _getAllVehicleRemoteActionV2(
            appVehicleReposistory,
            event,
          );
        } else {
          if (currentPage <= responseData.totalPages!) {
            currentPage++;
            _getAllVehicleRemoteActionV2(
              appVehicleReposistory,
              event,
            );
          } else {
            emit(
              GetAllVehicleSuccess(
                result: responseData,
                action: GetAllVehicleActionEnum.loadMore,
              ),
            );
          }
        }
      }
    });
  }

  VehicleDataEntity responseData = VehicleDataEntity();
  List<ListDatumVehicleDataEntity>? listResponseData = [];
  int currentPage = 1;

  Future<void> _getAllVehicleRemoteActionV2(
    AppVehicleReposistory appVehicleReposistory,
    GetAllVehicleRemoteAction event,
  ) async {
    emit(
      GetAllVehicleLoading(
        action: event.action,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          GetAllVehicleFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      GetAllVehicleRequestModelV2 dataRequest = event.reqData;
      dataRequest.currentPage = currentPage;

      GetAllVehicleResponseModelV2? result = await AppVehicleReposistory().getAllVehicleDataV2(
        userToken,
        dataRequest,
      );
      if (result == null) {
        emit(
          GetAllVehicleFailed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
        return;
      }
      if (result.status != 200) {
        emit(
          GetAllVehicleFailed(
            errorMessage: "${result.message}",
          ),
        );
        return;
      }
      if (result.data != null) {
        responseData = result.toVehicleDataEntity()!;
        listResponseData?.addAll(result.toVehicleDataEntity()!.listData!);
        responseData.listData = listResponseData;
        await VehicleLocalRepository().setLocalVehicleDataV2(
          data: responseData,
        );
        // await VehicleLocalRepository().setLocalVehicleDataV2(
        //   data: result.toVehicleDataEntity()!,
        // );
        emit(
          GetAllVehicleSuccess(
            result: responseData,
            action: event.action,
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        GetAllVehicleFailed(
          errorMessage: "$errorMessage",
        ),
      );
    }
  }

  Future<void> _getAllVehicleLocalActionV2(
    AppVehicleReposistory appVehicleReposistory,
    GetAllVehicleLocalAction event,
  ) async {
    emit(
      GetAllVehicleLoading(
        action: GetAllVehicleActionEnum.refresh,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 3000));
    try {
      // VehicleDataEntity? result = await event.vehicleLocalRepository.getLocalVehicleDataV2();
      VehicleDataEntity? result = await VehicleLocalRepository().getLocalVehicleDataV2();
      if (result != null) {
        emit(
          GetAllVehicleSuccess(
            result: result,
            action: GetAllVehicleActionEnum.refresh,
          ),
        );
      } else {
        emit(
          GetAllVehicleFailed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        GetAllVehicleFailed(
          errorMessage: errorMessage.toString(),
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
}
