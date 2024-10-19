part of 'signout_bloc.dart';

@immutable
abstract class SignoutEvent {}

class SignoutAction extends SignoutEvent {
  final AccountLocalRepository accountLocalRepository;
  final VehicleLocalRepository vehicleLocalRepository;

  SignoutAction({
    required this.accountLocalRepository,
    required this.vehicleLocalRepository,
  });
}