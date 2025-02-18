part of 'change_password_forgot_password_bloc.dart';

abstract class ChangePasswordForgotPasswordState {}

class ChangePasswordForgotPasswordInitial extends ChangePasswordForgotPasswordState {}

class ChangePasswordForgotPasswordLoading extends ChangePasswordForgotPasswordState {}

class ChangePasswordForgotPasswordSuccess extends ChangePasswordForgotPasswordState {}

class ChangePasswordForgotPasswordFailed extends ChangePasswordForgotPasswordState {
  final String errorMessage;
  ChangePasswordForgotPasswordFailed({required this.errorMessage});
}
