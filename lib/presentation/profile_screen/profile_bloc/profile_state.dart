part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileSuccess extends ProfileState {
  // final AccountDataUserModel accountDataUserModel;
  final UserDataEntity userDataModel;
  final Uint8List? dataProfilePicture;

  ProfileSuccess({
    // required this.accountDataUserModel,
    required this.userDataModel,
    required this.dataProfilePicture,
  });
}

class ProfileFailed extends ProfileState {
  final String errorMessage;

  ProfileFailed({
    required this.errorMessage,
  });
}

class ProfileLoading extends ProfileState {}
