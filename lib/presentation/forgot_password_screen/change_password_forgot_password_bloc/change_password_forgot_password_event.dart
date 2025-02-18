part of 'change_password_forgot_password_bloc.dart';

abstract class ChangePasswordForgotPasswordEvent {}

class ChangePasswordForgotPasswordAction extends ChangePasswordForgotPasswordEvent {
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordForgotPasswordAction({
    required this.newPassword,
    required this.confirmNewPassword,
  });
}
