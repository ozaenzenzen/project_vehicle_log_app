// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/delete_account_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc(AppAccountRepository accountRepository) : super(DeleteAccountInitial()) {
    on<DeleteAccountEvent>((event, emit) {
      if (event is DeleteAccountAction) {
        _deleteAccountAction(accountRepository, event);
      }
    });
  }

  Future<void> _deleteAccountAction(
    AppAccountRepository accountRepository,
    DeleteAccountAction event,
  ) async {
    emit(
      DeleteAccountLoading(),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          DeleteAccountFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      DeleteAccountResponseModel? output = await accountRepository.deleteAccount(
        token: userToken,
        reason: event.reason,
      );
      if (output == null) {
        emit(
          DeleteAccountFailed(
            errorMessage: "Failed delete account",
          ),
        );
        return;
      }

      if (output.status != 200) {
        emit(
          DeleteAccountFailed(
            errorMessage: output.message!,
          ),
        );
        return;
      }

      if (output.status == 200) {
        emit(
          DeleteAccountSuccess(
            response: output,
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        DeleteAccountFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
