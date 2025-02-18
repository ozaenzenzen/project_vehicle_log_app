part of 'send_otp_forgot_password_bloc.dart';

abstract class SendOtpForgotPasswordEvent {}

class SendOTPForgotPasswordAction extends SendOtpForgotPasswordEvent {
  final String email;

  SendOTPForgotPasswordAction({required this.email});
}
