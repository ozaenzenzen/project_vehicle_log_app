part of 'edit_measurement_log_bloc.dart';

abstract class EditMeasurementLogEvent {}

class UpdateMeasurementAction extends EditMeasurementLogEvent {
  EditMeasurementLogRequestModel editMeasurementLogRequestModel;
  UpdateMeasurementAction({required this.editMeasurementLogRequestModel});
}

class DeleteMeasurementAction extends EditMeasurementLogEvent {}
