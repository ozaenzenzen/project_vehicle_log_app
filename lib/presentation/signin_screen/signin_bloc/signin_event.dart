part of 'signin_bloc.dart';

@immutable
abstract class SigninEvent {}

class SigninAction extends SigninEvent {
  final SignInRequestModel signInRequestModel;

  SigninAction({
    required this.signInRequestModel,
  });
}
