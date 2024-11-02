// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/create_log_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/create_log_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/remote/vehicle_repository.dart';

part 'create_log_vehicle_event.dart';
part 'create_log_vehicle_state.dart';

class CreateLogVehicleBloc extends Bloc<CreateLogVehicleEvent, CreateLogVehicleState> {
  CreateLogVehicleBloc(AppVehicleReposistory appVehicleReposistory) : super(CreateLogVehicleInitial()) {
    on<CreateLogVehicleEvent>((event, emit) {
      if (event is CreateLogVehicleAction) {
        _createLogVehicleAction(appVehicleReposistory, event);
      }
    });
  }

  Future<void> _createLogVehicleAction(
    AppVehicleReposistory appVehicleReposistory,
    CreateLogVehicleAction event,
  ) async {
    emit(CreateLogVehicleLoading());
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          CreateLogVehicleFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      CreateLogVehicleResponseModel? createLogVehicleResponseModel = await appVehicleReposistory.createLogVehicleData(
        createLogVehicleRequestModel: event.createLogVehicleRequestModel,
        token: userToken,
      );
      if (createLogVehicleResponseModel != null) {
        if (createLogVehicleResponseModel.status == 201) {
          emit(
            CreateLogVehicleSuccess(
              createLogVehicleResponseModel: createLogVehicleResponseModel,
            ),
          );
        } else {
          emit(
            CreateLogVehicleFailed(
              errorMessage: "${createLogVehicleResponseModel.message}",
            ),
          );
        }
      } else {
        emit(
          CreateLogVehicleFailed(
            errorMessage: "Response data is null",
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        CreateLogVehicleFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
