part of 'validate_otp_forgot_password_bloc.dart';

abstract class ValidateOtpForgotPasswordEvent {}

class ValidateOTPForgotPasswordAction extends ValidateOtpForgotPasswordEvent {
  final String otp;
  ValidateOTPForgotPasswordAction({required this.otp});
}