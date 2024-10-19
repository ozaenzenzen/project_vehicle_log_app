part of 'signout_bloc.dart';

@immutable
abstract class SignoutState {}

class SignoutInitial extends SignoutState {}

class SignoutSuccess extends SignoutState {}

class SignoutFailed extends SignoutState {
  final String errorMessage;
  
  SignoutFailed({
    required this.errorMessage,
  });
}

class SignoutLoading extends SignoutState {}
