part of 'otp_validation_bloc.dart';

abstract class OtpValidationState {}

class OtpValidationInitial extends OtpValidationState {}

class OtpValidationLoading extends OtpValidationState {}

class OtpValidationSuccess extends OtpValidationState {}

class OtpValidationFailed extends OtpValidationState {
  final String errorMessage;

  OtpValidationFailed({required this.errorMessage});
}
