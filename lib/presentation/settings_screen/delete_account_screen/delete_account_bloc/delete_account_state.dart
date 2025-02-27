part of 'delete_account_bloc.dart';

abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {
  final DeleteAccountResponseModel response;
  
  DeleteAccountSuccess({
    required this.response,
  });
}

class DeleteAccountFailed extends DeleteAccountState {
  final String errorMessage;

  DeleteAccountFailed({
    required this.errorMessage,
  });
}

class DeleteAccountLoading extends DeleteAccountState {}
