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

part 'get_all_vehicle_v2_event.dart';
part 'get_all_vehicle_v2_state.dart';

class GetAllVehicleV2Bloc extends Bloc<GetAllVehicleV2Event, GetAllVehicleV2State> {
  GetAllVehicleV2Bloc(AppVehicleReposistory appVehicleReposistory) : super(GetAllVehicleV2Initial()) {
    on<GetAllVehicleV2Event>((event, emit) {
      if (event is GetAllVehicleV2RemoteAction) {
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
              GetAllVehicleV2Success(
                result: responseData,
                action: GetAllVehicleActionEnum.loadMore,
              ),
            );
          }
        }
      }
      if (event is GetAllVehicleV2LocalAction) {
        _getAllVehicleLocalActionV2(appVehicleReposistory, event);
      }
    });
  }

  VehicleDataEntity responseData = VehicleDataEntity();
  List<ListDatumVehicleDataEntity>? listResponseData = [];
  int currentPage = 1;

  Future<void> _getAllVehicleRemoteActionV2(
    AppVehicleReposistory appVehicleReposistory,
    GetAllVehicleV2RemoteAction event,
  ) async {
    emit(
      GetAllVehicleV2Loading(
        action: event.action,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          GetAllVehicleV2Failed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      GetAllVehicleRequestModelV2 dataRequest = event.reqData;
      dataRequest.currentPage = currentPage;

      GetAllVehicleResponseModelV2? result = await appVehicleReposistory.getAllVehicleDataV2(
        userToken,
        dataRequest,
      );
      if (result != null) {
        if (result.status == 200) {
          await VehicleLocalRepository().setLocalVehicleDataV2(
            data: result.toVehicleDataEntity()!,
          );
          emit(
            GetAllVehicleV2Success(
              result: result.toVehicleDataEntity(),
              action: event.action,
            ),
          );
        } else {
          emit(
            GetAllVehicleV2Failed(
              errorMessage: result.message.toString(),
            ),
          );
        }
      } else {
        emit(
          GetAllVehicleV2Failed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        GetAllVehicleV2Failed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }

  Future<void> _getAllVehicleLocalActionV2(
    AppVehicleReposistory appVehicleReposistory,
    GetAllVehicleV2LocalAction event,
  ) async {
    emit(
      GetAllVehicleV2Loading(
        action: GetAllVehicleActionEnum.refresh,
      ),
    );
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          GetAllVehicleV2Failed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      VehicleDataEntity? result = await VehicleLocalRepository().getLocalVehicleDataV2();
      if (result != null) {
        emit(
          GetAllVehicleV2Success(
            result: result,
            action: GetAllVehicleActionEnum.refresh,
          ),
        );
      } else {
        emit(
          GetAllVehicleV2Failed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        GetAllVehicleV2Failed(
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
