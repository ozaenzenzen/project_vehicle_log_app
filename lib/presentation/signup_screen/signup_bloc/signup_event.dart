part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupAction extends SignupEvent {
  final SignUpRequestModel signUpRequestModel;

  SignupAction({
    required this.signUpRequestModel,
  });
}
