part of 'get_all_vehicle_bloc.dart';

@immutable
abstract class GetAllVehicleEvent {}

class GetAllVehicleRemoteAction extends GetAllVehicleEvent {
  final GetAllVehicleRequestModelV2 reqData;
  final GetAllVehicleActionEnum action;
  
  GetAllVehicleRemoteAction({
    required this.reqData,
    required this.action,
  });
}

class GetAllVehicleLocalAction extends GetAllVehicleEvent {
  final GetAllVehicleRequestModelV2 reqData;
  GetAllVehicleLocalAction({required this.reqData});
}
