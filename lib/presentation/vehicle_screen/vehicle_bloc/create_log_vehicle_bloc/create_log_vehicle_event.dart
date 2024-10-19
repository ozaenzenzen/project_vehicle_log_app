part of 'create_log_vehicle_bloc.dart';

@immutable
abstract class CreateLogVehicleEvent {}

class CreateLogVehicleAction extends CreateLogVehicleEvent {
  final CreateLogVehicleRequestModel createLogVehicleRequestModel;

  CreateLogVehicleAction({
    required this.createLogVehicleRequestModel,
  });
}
