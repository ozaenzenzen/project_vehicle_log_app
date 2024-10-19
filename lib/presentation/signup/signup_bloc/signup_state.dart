part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupSuccess extends SignupState {
  final SignUpResponseModel signUpResponseModel;

  SignupSuccess({
    required this.signUpResponseModel,
  });
}

class SignupFailed extends SignupState {
  final String errorMessage;

  SignupFailed({
    required this.errorMessage,
  });
}

class SignupLoading extends SignupState {}
