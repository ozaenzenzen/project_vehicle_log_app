part of 'create_log_vehicle_bloc.dart';

@immutable
abstract class CreateLogVehicleState {}

class CreateLogVehicleInitial extends CreateLogVehicleState {}

class CreateLogVehicleLoading extends CreateLogVehicleState {}

class CreateLogVehicleSuccess extends CreateLogVehicleState {
  final CreateLogVehicleResponseModel createLogVehicleResponseModel;

  CreateLogVehicleSuccess({
    required this.createLogVehicleResponseModel,
  });
}

class CreateLogVehicleFailed extends CreateLogVehicleState {
  final String errorMessage;

  CreateLogVehicleFailed({
    required this.errorMessage,
  });
}
