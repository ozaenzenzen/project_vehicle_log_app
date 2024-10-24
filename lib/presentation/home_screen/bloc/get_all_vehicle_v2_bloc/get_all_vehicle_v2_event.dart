part of 'get_all_vehicle_v2_bloc.dart';

@immutable
abstract class GetAllVehicleV2Event {}

class GetAllVehicleV2RemoteAction extends GetAllVehicleV2Event {
  final GetAllVehicleRequestModelV2 reqData;
  final GetAllVehicleActionEnum action;
  
  GetAllVehicleV2RemoteAction({
    required this.reqData,
    required this.action,
  });
}

class GetAllVehicleV2LocalAction extends GetAllVehicleV2Event {
  final GetAllVehicleRequestModelV2 reqData;
  GetAllVehicleV2LocalAction({required this.reqData});
}
