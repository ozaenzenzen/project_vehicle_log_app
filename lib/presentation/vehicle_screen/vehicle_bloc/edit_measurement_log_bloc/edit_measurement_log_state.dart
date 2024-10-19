part of 'edit_measurement_log_bloc.dart';

abstract class EditMeasurementLogState {}

class EditMeasurementLogInitial extends EditMeasurementLogState {}

class EditMeasurementLogLoading extends EditMeasurementLogState {}

class EditMeasurementLogSuccess extends EditMeasurementLogState {
  EditMeasurementLogResponseModel editMeasurementLogResponseModel;
  EditMeasurementLogSuccess({required this.editMeasurementLogResponseModel});
}

class EditMeasurementLogFailed extends EditMeasurementLogState {
  final String errorMessage;
  EditMeasurementLogFailed({required this.errorMessage});
}
