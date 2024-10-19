part of 'create_vehicle_bloc.dart';

@immutable
abstract class CreateVehicleState {}

class CreateVehicleInitial extends CreateVehicleState {}

class CreateVehicleSuccess extends CreateVehicleState {
  final CreateVehicleResponseModel createVehicleResponseModel;

  CreateVehicleSuccess({
    required this.createVehicleResponseModel,
  });
}

class CreateVehicleFailed extends CreateVehicleState {
  final String errorMessage;

  CreateVehicleFailed({
    required this.errorMessage,
  });
}

class CreateVehicleLoading extends CreateVehicleState {}
