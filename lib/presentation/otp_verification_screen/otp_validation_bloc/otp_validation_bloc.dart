// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/otp_validation_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/otp_validation_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/account/user_register_data_entity.dart';

part 'otp_validation_event.dart';
part 'otp_validation_state.dart';

class OtpValidationBloc extends Bloc<OtpValidationEvent, OtpValidationState> {
  OtpValidationBloc(AppAccountRepository accountRepository) : super(OtpValidationInitial()) {
    on<OtpValidationEvent>((event, emit) {
      if (event is OtpValidationAction) {
        _otpValidationAction(accountRepository, event);
      }
    });
  }

  Future<void> _otpValidationAction(
    AppAccountRepository accountRepository,
    OtpValidationAction event,
  ) async {
    emit(OtpValidationLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      UserRegisterDataEntity? registerData = await AccountLocalRepository().getRegisterUserData();
      if (registerData == null) {
        emit(
          OtpValidationFailed(errorMessage: "Data support not found"),
        );
      }

      OtpValidationRequestModel reqData = OtpValidationRequestModel(
        email: registerData!.email!,
        otp: event.otp,
        otpKey: registerData.otpKey!,
      );

      OtpValidationResponseModel? output = await accountRepository.otpValidation(data: reqData);
      if (output == null) {
        emit(
          OtpValidationFailed(
            errorMessage: "Failed Change Password Forgot Password",
          ),
        );
        return;
      }

      if (output.status != 200) {
        emit(
          OtpValidationFailed(
            errorMessage: output.message!,
          ),
        );
        return;
      }

      if (output.status == 200) {
        emit(
          OtpValidationSuccess(),
        );
      }
    } catch (errorMessage) {
      emit(
        OtpValidationFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
