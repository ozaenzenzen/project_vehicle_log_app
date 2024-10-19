part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileSuccess extends ProfileState {
  // final AccountDataUserModel accountDataUserModel;
  final UserDataEntity userDataModel;

  ProfileSuccess({
    // required this.accountDataUserModel,
    required this.userDataModel,
  });
}

class ProfileFailed extends ProfileState {
  final String errorMessage;

  ProfileFailed({
    required this.errorMessage,
  });
}

class ProfileLoading extends ProfileState {}
