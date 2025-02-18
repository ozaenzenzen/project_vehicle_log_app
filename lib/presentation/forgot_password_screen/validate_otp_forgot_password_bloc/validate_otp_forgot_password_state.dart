part of 'validate_otp_forgot_password_bloc.dart';

abstract class ValidateOtpForgotPasswordState {}

class ValidateOtpForgotPasswordInitial extends ValidateOtpForgotPasswordState {}

class ValidateOtpForgotPasswordLoading extends ValidateOtpForgotPasswordState {}

class ValidateOtpForgotPasswordSuccess extends ValidateOtpForgotPasswordState {}

class ValidateOtpForgotPasswordFailed extends ValidateOtpForgotPasswordState {
  final String errorMessage;

  ValidateOtpForgotPasswordFailed({required this.errorMessage});
}
