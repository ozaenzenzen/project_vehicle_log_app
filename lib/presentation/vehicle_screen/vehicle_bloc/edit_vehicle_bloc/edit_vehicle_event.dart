part of 'edit_vehicle_bloc.dart';

abstract class EditVehicleEvent {}

class EditVehicleAction extends EditVehicleEvent {
  final EditVehicleRequestModel editVehicleRequestModel;

  EditVehicleAction({
    required this.editVehicleRequestModel,
  });
}
