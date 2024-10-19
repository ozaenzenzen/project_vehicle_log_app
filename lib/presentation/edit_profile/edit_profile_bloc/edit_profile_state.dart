part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final EditProfileResponseModel editProfileResponseModel;
  EditProfileSuccess({required this.editProfileResponseModel});
}

class EditProfileFailed extends EditProfileState {
  final String? errorMessage;
  EditProfileFailed({this.errorMessage});
}
