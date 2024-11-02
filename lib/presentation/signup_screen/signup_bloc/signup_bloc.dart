// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/signup_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/signup_response_models.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(AppAccountRepository accountRepository) : super(SignupInitial()) {
    on<SignupEvent>((event, emit) {
      if (event is SignupAction) {
        _signUpAction(accountRepository, event);
      }
    });
  }
  Future<void> _signUpAction(
    AppAccountRepository accountRepository,
    SignupAction event,
  ) async {
    emit(SignupLoading());
    await Future.delayed(const Duration(milliseconds: 1000));
    try {
      SignUpResponseModel? signUpResponseModel = await accountRepository.signup(
        event.signUpRequestModel,
      );
      if (signUpResponseModel != null) {
        if (signUpResponseModel.status == 201) {
          UserDataEntity? data = signUpResponseModel.toUserDataEntityWithoutToken();
          // AccountDataUserModel data = AccountDataUserModel(
          //   userId: signUpResponseModel.data?.userId,
          //   name: signUpResponseModel.data?.name,
          //   email: signUpResponseModel.data?.email,
          //   phone: signUpResponseModel.data?.phone,
          //   // link: signUpResponseModel.accountData?.link,
          //   // typeuser: signUpResponseModel.accountData?.typeuser,
          // );
          await AccountLocalRepository().setLocalAccountData(data: data!);
          await AccountLocalRepository().setIsSignIn();
          emit(
            SignupSuccess(
              signUpResponseModel: signUpResponseModel,
            ),
          );
        } else {
          var errorMessage = "";
          if (signUpResponseModel.message.toString().contains('required')) {
            errorMessage = "terdapat field kosong";
          } else {
            errorMessage = signUpResponseModel.message.toString();
          }
          emit(
            SignupFailed(
              errorMessage: errorMessage,
            ),
          );
        }
      } else {
        emit(
          SignupFailed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        SignupFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
