part of 'signin_bloc.dart';

@immutable
abstract class SigninEvent {}

class SigninAction extends SigninEvent {
  final SignInRequestModel signInRequestModel;
  final AppVehicleReposistory? appVehicleReposistory;
  final VehicleLocalRepository vehicleLocalRepository;

  SigninAction({
    required this.signInRequestModel,
    required this.appVehicleReposistory,
    required this.vehicleLocalRepository,
  });
}
