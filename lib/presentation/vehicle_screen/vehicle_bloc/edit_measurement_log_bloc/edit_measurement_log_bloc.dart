// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_measurement_log_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_measurement_log_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';

part 'edit_measurement_log_event.dart';
part 'edit_measurement_log_state.dart';

class EditMeasurementLogBloc extends Bloc<EditMeasurementLogEvent, EditMeasurementLogState> {
  EditMeasurementLogBloc(AppVehicleReposistory  appVehicleReposistory) : super(EditMeasurementLogInitial()) {
    on<EditMeasurementLogEvent>((event, emit) {
      if (event is UpdateMeasurementAction) {
        _updateMeasurementAction(appVehicleReposistory, event);
      }
      if (event is DeleteMeasurementAction) {
        _deleteMeasurementAction(event);
      }
    });
  }

  Future<void> _updateMeasurementAction(
    AppVehicleReposistory  appVehicleReposistory,
    UpdateMeasurementAction event,
  ) async {
    emit(EditMeasurementLogLoading());
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          EditMeasurementLogFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      EditMeasurementLogResponseModel? editMeasurementLogResponseModel = await appVehicleReposistory.editMeasurementLogVehicleData(
        editMeasurementLogRequestModel: event.editMeasurementLogRequestModel,
        token: userToken,
      );
      if (editMeasurementLogResponseModel != null) {
        if (editMeasurementLogResponseModel.status == 202) {
          emit(
            EditMeasurementLogSuccess(
              editMeasurementLogResponseModel: editMeasurementLogResponseModel,
            ),
          );
        } else {
          emit(
            EditMeasurementLogFailed(
              errorMessage: editMeasurementLogResponseModel.message.toString(),
            ),
          );
        }
      } else {
        emit(
          EditMeasurementLogFailed(
            errorMessage: 'Data Empty',
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        EditMeasurementLogFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }

  Future<void> _deleteMeasurementAction(
    DeleteMeasurementAction event,
  ) async {
    //
  }
}
