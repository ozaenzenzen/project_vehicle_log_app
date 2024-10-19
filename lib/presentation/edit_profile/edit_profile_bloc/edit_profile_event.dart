part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class EditProfileAction extends EditProfileEvent {
  final EditProfileRequestModel editProfileRequestModel;
  EditProfileAction({required this.editProfileRequestModel});
}
