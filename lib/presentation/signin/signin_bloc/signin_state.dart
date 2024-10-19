part of 'signin_bloc.dart';

@immutable
abstract class SigninState {}

class SigninInitial extends SigninState {}

class SigninSuccess extends SigninState {
  final UserDataEntity userdata;
  
  SigninSuccess({
    required this.userdata,
  });
}

class SigninFailed extends SigninState {
  final String errorMessage;

  SigninFailed({
    required this.errorMessage,
  });
}

class SigninLoading extends SigninState {}
