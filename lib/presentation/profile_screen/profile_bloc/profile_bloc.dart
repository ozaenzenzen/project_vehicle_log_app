// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/get_userdata_response_models.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';
import 'package:project_vehicle_log_app/support/app_base64converter_helper.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    AppAccountRepository accountRepository,
    AccountLocalRepository localRepository,
  ) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      if (event is GetProfileLocalAction) {
        _getProfileLocalAction(localRepository);
      }
      if (event is GetProfileRemoteAction) {
        _getProfileRemoteAction(accountRepository);
      }
    });
  }
  
  Future<void> _getProfileRemoteAction(
    AppAccountRepository accountRepository,
  ) async {
    emit(ProfileLoading());
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          ProfileFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      GetUserDataResponseModel? getUserDataResponseModel = await accountRepository.getUserdata(
        token: userToken,
      );
      if (getUserDataResponseModel != null) {
        if (getUserDataResponseModel.status == 200) {
          UserDataEntity? dataEntity = getUserDataResponseModel.toUserDataEntityWithoutToken();
          await AccountLocalRepository().setLocalAccountData(data: dataEntity!);
          Uint8List? dataProfilePicture;
          if (dataEntity.profilePicture != null && dataEntity.profilePicture!.length > 40) {
            dataProfilePicture = await AppBase64ConverterHelper().decodeBase64(dataEntity.profilePicture.toString());
          }
          emit(
            ProfileSuccess(
              userDataModel: dataEntity,
              dataProfilePicture: dataProfilePicture,
            ),
          );
        } else {
          emit(
            ProfileFailed(errorMessage: getUserDataResponseModel.message!),
          );
        }
      } else {
        emit(
          ProfileFailed(errorMessage: "Profile Data Empty"),
        );
      }
    } catch (errorMessage) {
      emit(
        ProfileFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }

  Future<void> _getProfileLocalAction(
    AccountLocalRepository localRepository,
  ) async {
    emit(ProfileLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      UserDataEntity? dataEntity = await localRepository.getLocalAccountData();
      if (dataEntity != null) {
        Uint8List? dataProfilePicture;
        if (dataEntity.profilePicture != null && dataEntity.profilePicture!.length > 40) {
          dataProfilePicture = await AppBase64ConverterHelper().decodeBase64(dataEntity.profilePicture.toString());
        }
        emit(ProfileSuccess(
          userDataModel: dataEntity,
          dataProfilePicture: dataProfilePicture,
        ));
      } else {
        emit(
          ProfileFailed(errorMessage: "Failed To Get Profile Data"),
        );
      }
    } catch (errorMessage) {
      emit(
        ProfileFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
