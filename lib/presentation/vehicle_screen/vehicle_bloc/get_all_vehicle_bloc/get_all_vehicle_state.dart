part of 'get_all_vehicle_bloc.dart';

@immutable
abstract class GetAllVehicleState {}

class GetAllVehicleInitial extends GetAllVehicleState {}

class GetAllVehicleSuccess extends GetAllVehicleState {
  final GetAllVehicleDataResponseModel? getAllVehicleDataResponseModel;

  GetAllVehicleSuccess({
    this.getAllVehicleDataResponseModel,
  });
}

class GetProfileDataVehicleSuccess extends GetAllVehicleState {
  final UserDataEntity accountDataUserModel;

  GetProfileDataVehicleSuccess({
    required this.accountDataUserModel,
  });
}

class GetAllVehicleFailed extends GetAllVehicleState {
  final String errorMessage;

  GetAllVehicleFailed({
    required this.errorMessage,
  });
}

class GetAllVehicleLoading extends GetAllVehicleState {}
