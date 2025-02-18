part of 'send_otp_forgot_password_bloc.dart';

abstract class SendOtpForgotPasswordState {}

class SendOtpForgotPasswordInitial extends SendOtpForgotPasswordState {}

class SendOtpForgotPasswordLoading extends SendOtpForgotPasswordState {}

class SendOtpForgotPasswordSuccess extends SendOtpForgotPasswordState {}

class SendOtpForgotPasswordFailed extends SendOtpForgotPasswordState {
  final String errorMessage;

  SendOtpForgotPasswordFailed({required this.errorMessage});
}
