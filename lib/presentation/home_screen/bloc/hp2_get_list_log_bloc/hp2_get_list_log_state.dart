part of 'hp2_get_list_log_bloc.dart';

@immutable
abstract class GetListLogState {}

class GetListLogInitial extends GetListLogState {}

class GetListLogLoading extends GetListLogState {
  final GetLogVehicleActionEnum actionType;
  GetListLogLoading({
    required this.actionType,
  });
}

class GetListLogSuccess extends GetListLogState {
  final LogDataEntity? result;
  final GetLogVehicleActionEnum actionType;
  GetListLogSuccess({
    this.result,
    required this.actionType,
  });
}

class GetListLogFailed extends GetListLogState {
  final String errorMessage;
  GetListLogFailed({required this.errorMessage});
}
