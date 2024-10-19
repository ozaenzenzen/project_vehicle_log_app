part of 'hp2_get_list_log_bloc.dart';

@immutable
abstract class Hp2GetListLogState {}

class Hp2GetListLogInitial extends Hp2GetListLogState {}

class Hp2GetListLogLoading extends Hp2GetListLogState {
  final GetLogVehicleActionEnum actionType;
  Hp2GetListLogLoading({
    required this.actionType,
  });
}

class Hp2GetListLogSuccess extends Hp2GetListLogState {
  final LogDataEntity? result;
  final GetLogVehicleActionEnum actionType;
  Hp2GetListLogSuccess({
    this.result,
    required this.actionType,
  });
}

class Hp2GetListLogFailed extends Hp2GetListLogState {
  final String errorMessage;
  Hp2GetListLogFailed({required this.errorMessage});
}
