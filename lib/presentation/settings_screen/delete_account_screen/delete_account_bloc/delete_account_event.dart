part of 'delete_account_bloc.dart';

abstract class DeleteAccountEvent {}

class DeleteAccountAction extends DeleteAccountEvent {
  final String? reason;

  DeleteAccountAction({
    this.reason,
  });
}
