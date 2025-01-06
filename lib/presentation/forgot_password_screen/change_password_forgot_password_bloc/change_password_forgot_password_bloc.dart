// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/change_password_forgot_password_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/change_password_forgot_password_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/account/forgot_password_data_entity.dart';

part 'change_password_forgot_password_event.dart';
part 'change_password_forgot_password_state.dart';

class ChangePasswordForgotPasswordBloc extends Bloc<ChangePasswordForgotPasswordEvent, ChangePasswordForgotPasswordState> {
  ChangePasswordForgotPasswordBloc(AppAccountRepository accountRepository) : super(ChangePasswordForgotPasswordInitial()) {
    on<ChangePasswordForgotPasswordEvent>((event, emit) {
      if (event is ChangePasswordForgotPasswordAction) {
        _changePasswordForgotPasswordAction(accountRepository, event);
      }
    });
  }

  Future<void> _changePasswordForgotPasswordAction(
    AppAccountRepository accountRepository,
    ChangePasswordForgotPasswordAction event,
  ) async {
    emit(
      ChangePasswordForgotPasswordLoading(),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      ForgotPasswordDataEntity? dataForgotPassword = await AccountLocalRepository().getForgotPasswordProcessHistorySingle();
      if (dataForgotPassword == null) {
        emit(
          ChangePasswordForgotPasswordFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      ChangePasswordForgotPasswordRequestModel reqData = ChangePasswordForgotPasswordRequestModel(
        forgotKey: dataForgotPassword.forgotKey!,
        newPassword: event.newPassword,
        confirmNewPassword: event.confirmNewPassword,
      );

      ChangePasswordForgotPasswordResponseModel? output = await accountRepository.changePasswordForgotPassword(
        data: reqData,
      );
      if (output == null) {
        emit(
          ChangePasswordForgotPasswordFailed(
            errorMessage: "Failed Change Password Forgot Password",
          ),
        );
        return;
      }

      if (output.status != 200) {
        emit(
          ChangePasswordForgotPasswordFailed(
            errorMessage: output.message!,
          ),
        );
        return;
      }

      if (output.status == 200) {
        emit(
          ChangePasswordForgotPasswordSuccess(),
        );
      }
    } catch (errorMessage) {
      emit(
        ChangePasswordForgotPasswordFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
