part of 'hp2_get_list_log_bloc.dart';

@immutable
abstract class Hp2GetListLogEvent {}

class Hp2GetListLogAction extends Hp2GetListLogEvent {
  final GetLogVehicleRequestModelV2 reqData;
  Hp2GetListLogAction({required this.reqData});
}
