part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetProfileLocalAction extends ProfileEvent {}

class GetProfileRemoteAction extends ProfileEvent {
  final AppAccountReposistory accountRepository;
  GetProfileRemoteAction({required this.accountRepository});
}
