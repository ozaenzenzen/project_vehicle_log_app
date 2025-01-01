part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent {}

final class ChangePasswordAction extends ChangePasswordEvent {
  final ChangePasswordRequestModel reqData;

  ChangePasswordAction({
    required this.reqData,
  });
}
