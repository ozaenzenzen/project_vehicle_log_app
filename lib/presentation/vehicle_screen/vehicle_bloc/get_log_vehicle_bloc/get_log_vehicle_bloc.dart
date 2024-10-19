// // ignore_for_file: invalid_use_of_visible_for_testing_member

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_log_vehicle_data_response_model.dart';
// import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';

// part 'get_log_vehicle_event.dart';
// part 'get_log_vehicle_state.dart';

// class GetLogVehicleBloc extends Bloc<GetLogVehicleEvent, GetLogVehicleState> {
//   GetLogVehicleBloc(AppVehicleReposistory appVehicleReposistory) : super(GetLogVehicleInitial()) {
//     on<GetLogVehicleEvent>((event, emit) {
//       if (event is GetLogVehicleAction) {
//         _getLogVehicleAction(appVehicleReposistory, event);
//       }
//     });
//   }
  
//   Future<void> _getLogVehicleAction(
//     AppVehicleReposistory appVehicleReposistory,
//     GetLogVehicleAction event,
//   ) async {
//     emit(GetLogVehicleLoading());
//     await Future.delayed(const Duration(milliseconds: 1000));
//     try {
//       GetLogVehicleDataResponseModel getLogVehicleDataResponseModel = await appVehicleReposistory.getLogVehicleData(
//         event.id,
//       );
//       if (getLogVehicleDataResponseModel.status == 200) {
//         emit(
//           GetLogVehicleSuccess(
//             getLogVehicleDataResponseModel: getLogVehicleDataResponseModel,
//           ),
//         );
//       } else {
//         emit(
//           GetLogVehicleFailed(
//             errorMessage: getLogVehicleDataResponseModel.message.toString(),
//           ),
//         );
//       }
//     } catch (errorMessage) {
//       emit(
//         GetLogVehicleFailed(
//           errorMessage: errorMessage.toString(),
//         ),
//       );
//     }
//   }
// }
