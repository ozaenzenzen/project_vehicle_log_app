part of 'hp2_get_list_log_bloc.dart';

@immutable
abstract class GetListLogEvent {}

class GetListLogAction extends GetListLogEvent {
  final GetLogVehicleRequestModelV2 reqData;
  final GetLogVehicleActionEnum actionType;
  
  GetListLogAction({
    required this.reqData,
    required this.actionType,
  });
}
