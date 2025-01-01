// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/change_password_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/change_password_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc(AppAccountRepository accountRepository) : super(ChangePasswordInitial()) {
    on<ChangePasswordEvent>((event, emit) {
      if (event is ChangePasswordAction) {
        _changePasswordAction(accountRepository, event);
      }
    });
  }

  Future<void> _changePasswordAction(
    AppAccountRepository accountRepository,
    ChangePasswordAction event,
  ) async {
    emit(
      ChangePasswordLoading(),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          ChangePasswordFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      ChangePasswordResponseModel? output = await accountRepository.changePassword(
        data: event.reqData,
        token: userToken,
      );
      if (output == null) {
        emit(
          ChangePasswordFailed(
            errorMessage: "Failed edit profile",
          ),
        );
        return;
      }

      if (output.status != 200) {
        emit(
          ChangePasswordFailed(
            errorMessage: output.message!,
          ),
        );
        return;
      }

      if (output.status == 200) {
        emit(
          ChangePasswordSuccess(),
        );
      }
    } catch (errorMessage) {
      emit(
        ChangePasswordFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
