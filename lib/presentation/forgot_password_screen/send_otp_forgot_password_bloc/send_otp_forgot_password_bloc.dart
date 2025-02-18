// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/send_otp_forgot_password_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/account/forgot_password_data_entity.dart';

part 'send_otp_forgot_password_event.dart';
part 'send_otp_forgot_password_state.dart';

class SendOtpForgotPasswordBloc extends Bloc<SendOtpForgotPasswordEvent, SendOtpForgotPasswordState> {
  SendOtpForgotPasswordBloc(AppAccountRepository accountRepository) : super(SendOtpForgotPasswordInitial()) {
    on<SendOtpForgotPasswordEvent>((event, emit) {
      if (event is SendOTPForgotPasswordAction) {
        _sendOTPAction(accountRepository, event);
      }
    });
  }

  Future<void> _sendOTPAction(
    AppAccountRepository accountRepository,
    SendOTPForgotPasswordAction event,
  ) async {
    emit(
      SendOtpForgotPasswordLoading(),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      SendOtpForgotPasswordResponseModel? output = await accountRepository.sendOTPForgotPassword(
        email: event.email,
      );
      if (output == null) {
        emit(
          SendOtpForgotPasswordFailed(
            errorMessage: "Failed edit profile",
          ),
        );
        return;
      }

      if (output.status != 200) {
        emit(
          SendOtpForgotPasswordFailed(
            errorMessage: output.message!,
          ),
        );
        return;
      }

      if (output.status == 200) {
        ForgotPasswordDataEntity dataToLocal = ForgotPasswordDataEntity(
          email: event.email,
          otpKey: output.data?.otpKey,
          resendOtpKey: output.data?.resendOtpKey,
          forgotKey: output.data?.forgotKey,
        );
        await AccountLocalRepository().setForgotPasswordProcessHistorySingle(dataToLocal);

        emit(
          SendOtpForgotPasswordSuccess(),
        );
      }
    } catch (errorMessage) {
      emit(
        SendOtpForgotPasswordFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
