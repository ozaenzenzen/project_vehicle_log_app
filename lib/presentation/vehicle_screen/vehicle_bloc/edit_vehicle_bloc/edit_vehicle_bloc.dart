// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/remote/vehicle_repository.dart';

part 'edit_vehicle_event.dart';
part 'edit_vehicle_state.dart';

class EditVehicleBloc extends Bloc<EditVehicleEvent, EditVehicleState> {
  EditVehicleBloc(AppVehicleReposistory appVehicleReposistory) : super(EditVehicleInitial()) {
    on<EditVehicleEvent>((event, emit) {
      if (event is EditVehicleAction) {
        _editVehicleAction(appVehicleReposistory, event);
      }
    });
  }

  Future<void> _editVehicleAction(
    AppVehicleReposistory appVehicleReposistory,
    EditVehicleAction event,
  ) async {
    emit(EditVehicleLoading());
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          EditVehicleFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      EditVehicleResponseModel? editVehicleResponseModel = await appVehicleReposistory.editVehicleData(
        editVehicleRequestModel: event.editVehicleRequestModel,
        token: userToken,
      );
      if (editVehicleResponseModel != null) {
        if (editVehicleResponseModel.status == 201) {
          emit(
            EditVehicleSuccess(
              editVehicleResponseModel: editVehicleResponseModel,
            ),
          );
        } else {
          emit(
            EditVehicleFailed(
              errorMessage: editVehicleResponseModel.message.toString(),
            ),
          );
        }
      } else {
        emit(
          EditVehicleFailed(
            errorMessage: 'Data Empty',
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        EditVehicleFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
