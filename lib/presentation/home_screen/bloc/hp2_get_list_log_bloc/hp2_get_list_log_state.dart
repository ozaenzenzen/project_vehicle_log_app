part of 'hp2_get_list_log_bloc.dart';

@immutable
abstract class Hp2GetListLogState {}

class Hp2GetListLogInitial extends Hp2GetListLogState {}

class Hp2GetListLogLoading extends Hp2GetListLogState {}

class Hp2GetListLogSuccess extends Hp2GetListLogState {
  final LogDataEntity? result;
  Hp2GetListLogSuccess({this.result});
}

class Hp2GetListLogFailed extends Hp2GetListLogState {
  final String errorMessage;
  Hp2GetListLogFailed({required this.errorMessage});
}
