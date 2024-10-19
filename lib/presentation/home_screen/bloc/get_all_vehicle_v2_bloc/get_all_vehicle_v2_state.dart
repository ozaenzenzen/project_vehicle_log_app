part of 'get_all_vehicle_v2_bloc.dart';

@immutable
abstract class GetAllVehicleV2State {}

class GetAllVehicleV2Initial extends GetAllVehicleV2State {}

class GetAllVehicleV2Loading extends GetAllVehicleV2State {
  final GetAllVehicleActionEnum action;

  GetAllVehicleV2Loading({
    required this.action,
  });
}

class GetAllVehicleV2Success extends GetAllVehicleV2State {
  final VehicleDataEntity? result;
  final GetAllVehicleActionEnum action;
  
  GetAllVehicleV2Success({
    this.result,
    required this.action,
  });
}

class GetAllVehicleV2Failed extends GetAllVehicleV2State {
  final String errorMessage;

  GetAllVehicleV2Failed({
    required this.errorMessage,
  });
}
