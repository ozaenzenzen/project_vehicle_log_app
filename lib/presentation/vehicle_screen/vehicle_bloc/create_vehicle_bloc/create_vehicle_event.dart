part of 'create_vehicle_bloc.dart';

@immutable
abstract class CreateVehicleEvent {}

class CreateVehicleAction extends CreateVehicleEvent {
  final CreateVehicleRequestModel createVehicleRequestModel;

  CreateVehicleAction({
    required this.createVehicleRequestModel,
  });
}
