part of 'get_list_log_bloc.dart';

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
  // final Map<String, dynamic>? dataCountFrequentTitle;
  // final Map<String, dynamic>? dataCostBreakdown;
  final List<ChartData>? dataCountFrequentTitle;
  final List<ChartData>? dataCostBreakdown;
  GetListLogSuccess({
    this.result,
    required this.actionType,
    this.dataCountFrequentTitle,
    this.dataCostBreakdown,
  });
}

class GetListLogFailed extends GetListLogState {
  final String errorMessage;
  GetListLogFailed({required this.errorMessage});
}
