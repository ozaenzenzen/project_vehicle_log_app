part of 'otp_validation_bloc.dart';

abstract class OtpValidationEvent {}

class OtpValidationAction extends OtpValidationEvent {
  final String otp;

  OtpValidationAction({required this.otp});
}
