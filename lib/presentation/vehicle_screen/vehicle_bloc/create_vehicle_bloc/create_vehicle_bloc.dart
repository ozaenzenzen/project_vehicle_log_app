// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/create_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/create_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/remote/vehicle_repository.dart';

part 'create_vehicle_event.dart';
part 'create_vehicle_state.dart';

class CreateVehicleBloc extends Bloc<CreateVehicleEvent, CreateVehicleState> {
  CreateVehicleBloc(AppVehicleRepository appVehicleRepository) : super(CreateVehicleInitial()) {
    on<CreateVehicleEvent>((event, emit) {
      if (event is CreateVehicleAction) {
        _createVehicleAction(appVehicleRepository, event);
      }
    });
  }

  Future<void> _createVehicleAction(
    AppVehicleRepository appVehicleRepository,
    CreateVehicleAction event,
  ) async {
    emit(CreateVehicleLoading());
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          CreateVehicleFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      CreateVehicleResponseModel? createVehicleResponseModel = await appVehicleRepository.createVehicleData(
        createVehicleRequestModel: event.createVehicleRequestModel,
        token: userToken,
      );
      if (createVehicleResponseModel != null) {
        if (createVehicleResponseModel.status == 201) {
          emit(
            CreateVehicleSuccess(
              createVehicleResponseModel: createVehicleResponseModel,
            ),
          );
        } else {
          emit(
            CreateVehicleFailed(
              errorMessage: createVehicleResponseModel.message.toString(),
            ),
          );
        }
      } else {
        emit(
          CreateVehicleFailed(
            errorMessage: 'Data Empty',
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        CreateVehicleFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
