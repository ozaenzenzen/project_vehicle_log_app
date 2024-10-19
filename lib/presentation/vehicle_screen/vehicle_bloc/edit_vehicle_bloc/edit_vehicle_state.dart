part of 'edit_vehicle_bloc.dart';

abstract class EditVehicleState {}

class EditVehicleInitial extends EditVehicleState {}

class EditVehicleLoading extends EditVehicleState {}

class EditVehicleSuccess extends EditVehicleState {
  final EditVehicleResponseModel editVehicleResponseModel;
  EditVehicleSuccess({required this.editVehicleResponseModel});
}

class EditVehicleFailed extends EditVehicleState {
  final String errorMessage;

  EditVehicleFailed({
    required this.errorMessage,
  });
}
