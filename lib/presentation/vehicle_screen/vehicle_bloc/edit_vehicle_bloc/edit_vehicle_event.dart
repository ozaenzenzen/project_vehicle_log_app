part of 'edit_vehicle_bloc.dart';

abstract class EditVehicleEvent {}

class EditVehicleAction extends EditVehicleEvent {
  final AppVehicleReposistory appVehicleReposistory;
  final EditVehicleRequestModel editVehicleRequestModel;
  
  EditVehicleAction({
    required this.appVehicleReposistory,
    required this.editVehicleRequestModel,
  });
}
