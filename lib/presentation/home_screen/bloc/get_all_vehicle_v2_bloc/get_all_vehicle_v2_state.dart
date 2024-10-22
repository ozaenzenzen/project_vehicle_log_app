part of 'get_all_vehicle_v2_bloc.dart';

@immutable
abstract class GetAllVehicleState {}

class GetAllVehicleInitial extends GetAllVehicleState {}

class GetAllVehicleLoading extends GetAllVehicleState {
  final GetAllVehicleActionEnum action;

  GetAllVehicleLoading({
    required this.action,
  });
}

class GetAllVehicleSuccess extends GetAllVehicleState {
  final VehicleDataEntity? result;
  final GetAllVehicleActionEnum action;
  
  GetAllVehicleSuccess({
    this.result,
    required this.action,
  });
}

class GetAllVehicleFailed extends GetAllVehicleState {
  final String errorMessage;

  GetAllVehicleFailed({
    required this.errorMessage,
  });
}
