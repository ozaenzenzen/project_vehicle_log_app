// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/request/edit_profile_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/response/edit_profile_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(AppAccountRepository accountRepository) : super(EditProfileInitial()) {
    on<EditProfileEvent>((event, emit) {
      if (event is EditProfileAction) {
        _editProfileAction(accountRepository, event);
      }
    });
  }

  Future<void> _editProfileAction(
    AppAccountRepository accountRepository,
    EditProfileAction editProfileAction,
  ) async {
    emit(EditProfileLoading());
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          EditProfileFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      EditProfileResponseModel? editProfileResponseModel = await accountRepository.editProfile(
        token: userToken,
        data: editProfileAction.editProfileRequestModel,
      );
      if (editProfileResponseModel != null) {
        if (editProfileResponseModel.status == 202) {
          emit(EditProfileSuccess(
            editProfileResponseModel: editProfileResponseModel,
          ));
        } else {
          emit(
            EditProfileFailed(errorMessage: editProfileResponseModel.message),
          );
        }
      } else {
        emit(
          EditProfileFailed(errorMessage: "Failed edit profile"),
        );
      }
    } catch (errorMessage) {
      emit(
        EditProfileFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
