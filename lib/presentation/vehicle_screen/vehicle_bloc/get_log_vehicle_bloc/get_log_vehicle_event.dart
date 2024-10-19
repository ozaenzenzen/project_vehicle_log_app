part of 'get_log_vehicle_bloc.dart';

@immutable
abstract class GetLogVehicleEvent {}

class GetLogVehicleAction extends GetLogVehicleEvent {
  final String id;

  GetLogVehicleAction({
    required this.id,
  });
}
