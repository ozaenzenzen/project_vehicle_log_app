part of 'get_all_vehicle_bloc.dart';

@immutable
abstract class GetAllVehicleEvent {}

class GetAllVehicleDataRemoteAction extends GetAllVehicleEvent {
  final String id;
  final VehicleLocalRepository vehicleLocalRepository;

  GetAllVehicleDataRemoteAction({
    required this.id,
    required this.vehicleLocalRepository,
  });
}

class GetAllVehicleDataLocalAction extends GetAllVehicleEvent {
  final VehicleLocalRepository vehicleLocalRepository;

  GetAllVehicleDataLocalAction({
    required this.vehicleLocalRepository,
  });
}

class GetProfileDataVehicleAction extends GetAllVehicleEvent {
  final AccountLocalRepository localRepository;

  GetProfileDataVehicleAction({
    required this.localRepository,
  });
}
