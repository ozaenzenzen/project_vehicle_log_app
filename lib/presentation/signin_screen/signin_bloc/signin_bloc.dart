// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signin_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signin_response_models.dart';
import 'package:project_vehicle_log_app/data/repository/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/token_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc(AppAccountReposistory accountReposistory) : super(SigninInitial()) {
    on<SigninEvent>((event, emit) {
      if (event is SigninAction) {
        _signInAction(accountReposistory, event);
      }
    });
  }

  Future<void> _signInAction(
    AppAccountReposistory accountReposistory,
    SigninAction event,
  ) async {
    emit(SigninLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      SignInResponseModel? signInResponseModel = await accountReposistory.signin(
        event.signInRequestModel,
      );
      if (signInResponseModel != null) {
        if (signInResponseModel.status == 200) {
          UserDataEntity? entity = signInResponseModel.toUserDataEntity();
          await AccountLocalRepository().setLocalAccountData(
            data: entity!,
          );
          await AccountLocalRepository().setDataToken(
            data: TokenDataEntity(
              userStamp: signInResponseModel.data!.userStamp!,
              accessToken: signInResponseModel.data!.accessToken!,
              accessTokenExpiryTime: signInResponseModel.data!.accessTokenExpiryTime!,
              refreshToken: signInResponseModel.data!.refreshToken!,
              refreshTokenExpiryTime: signInResponseModel.data!.refreshTokenExpiryTime!,
            ),
          );
          await AccountLocalRepository().setUserToken(data: signInResponseModel.data!.accessToken!);
          await AccountLocalRepository().setRefreshToken(data: signInResponseModel.data!.refreshToken!);
          await AccountLocalRepository().setIsSignIn();
          emit(
            SigninSuccess(
              userdata: entity,
            ),
          );
        } else {
          emit(
            SigninFailed(
              errorMessage: signInResponseModel.message.toString(),
            ),
          );
        }
      } else {
        emit(
          SigninFailed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        SigninFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
