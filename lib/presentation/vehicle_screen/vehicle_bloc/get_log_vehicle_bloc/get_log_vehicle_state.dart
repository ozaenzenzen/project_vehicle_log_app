part of 'get_log_vehicle_bloc.dart';

@immutable
abstract class GetLogVehicleState {}

class GetLogVehicleInitial extends GetLogVehicleState {}

class GetLogVehicleSuccess extends GetLogVehicleState {
  final GetLogVehicleDataResponseModel getLogVehicleDataResponseModel;

  GetLogVehicleSuccess({
    required this.getLogVehicleDataResponseModel,
  });
}

class GetLogVehicleFailed extends GetLogVehicleState {
  final String errorMessage;

  GetLogVehicleFailed({
    required this.errorMessage,
  });
}

class GetLogVehicleLoading extends GetLogVehicleState {}
