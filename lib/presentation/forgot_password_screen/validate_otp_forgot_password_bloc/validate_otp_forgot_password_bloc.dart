// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/validate_otp_forgot_password_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/validate_otp_forgot_password_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/account/forgot_password_data_entity.dart';

part 'validate_otp_forgot_password_event.dart';
part 'validate_otp_forgot_password_state.dart';

class ValidateOtpForgotPasswordBloc extends Bloc<ValidateOtpForgotPasswordEvent, ValidateOtpForgotPasswordState> {
  ValidateOtpForgotPasswordBloc(AppAccountRepository accountRepository) : super(ValidateOtpForgotPasswordInitial()) {
    on<ValidateOtpForgotPasswordEvent>((event, emit) {
      if (event is ValidateOTPForgotPasswordAction) {
        _validateOTPAction(accountRepository, event);
      }
    });
  }

  Future<void> _validateOTPAction(
    AppAccountRepository accountRepository,
    ValidateOTPForgotPasswordAction event,
  ) async {
    emit(
      ValidateOtpForgotPasswordLoading(),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      ForgotPasswordDataEntity? forgotPasswordProcessHistoryData = await AccountLocalRepository().getForgotPasswordProcessHistorySingle();
      if (forgotPasswordProcessHistoryData == null) {
        emit(
          ValidateOtpForgotPasswordFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }
      forgotPasswordProcessHistoryData.otp = event.otp;
      await AccountLocalRepository().setForgotPasswordProcessHistorySingle(forgotPasswordProcessHistoryData);

      ValidateOtpForgotPasswordRequestModel reqData = ValidateOtpForgotPasswordRequestModel(
        email: forgotPasswordProcessHistoryData.email!,
        otp: event.otp,
        otpKey: forgotPasswordProcessHistoryData.otpKey!,
        forgotKey: forgotPasswordProcessHistoryData.forgotKey!,
      );

      ValidateOtpForgotPasswordResponseModel? output = await accountRepository.validateOTPForgotPassword(
        data: reqData,
      );
      if (output == null) {
        emit(
          ValidateOtpForgotPasswordFailed(
            errorMessage: "Failed Validate OTP Forgot Password",
          ),
        );
        return;
      }

      if (output.status != 200) {
        emit(
          ValidateOtpForgotPasswordFailed(
            errorMessage: output.message!,
          ),
        );
        return;
      }

      if (output.status == 200) {
        emit(
          ValidateOtpForgotPasswordSuccess(),
        );
      }
    } catch (errorMessage) {
      emit(
        ValidateOtpForgotPasswordFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
