// // ignore_for_file: invalid_use_of_visible_for_testing_member

// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
// import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
// import 'package:project_vehicle_log_app/data/model/local/vehicle_local_data_model.dart';
// import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
// import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
// import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';

// part 'get_all_vehicle_event.dart';
// part 'get_all_vehicle_state.dart';

// class GetAllVehicleBloc extends Bloc<GetAllVehicleEvent, GetAllVehicleState> {
//   GetAllVehicleBloc(AppVehicleReposistory appVehicleReposistory) : super(GetAllVehicleInitial()) {
//     on<GetAllVehicleEvent>((event, emit) {
//       if (event is GetAllVehicleDataRemoteAction) {
//         _getAllVehicleRemoteAction(appVehicleReposistory, event);
//       } else if (event is GetAllVehicleDataLocalAction) {
//         _getAllVehicleLocalAction(event.vehicleLocalRepository);
//       } else if (event is GetProfileDataVehicleAction) {
//         _getProfileDataAction(event.localRepository);
//       }
//     });
//   }

//   List<LocalCategorizedVehicleLogData> _helperCategorizeFromRemoteToLocal(List<VehicleMeasurementLogModel> vehicleMeasurementLogModels) {
//     Map<String, List<VehicleMeasurementLogModel>> categorizedData = {};
//     List<LocalCategorizedVehicleLogData> categorizedDataAsList = [];
//     for (VehicleMeasurementLogModel item in vehicleMeasurementLogModels) {
//       String category = item.measurementTitle!;
//       if (!categorizedData.containsKey(category)) {
//         categorizedData[category] = [];
//       }
//       categorizedData[category]!.add(item);
//     }

//     // categorizedData.forEach((category, items) {
//     //   debugPrint('Category: $category');
//     //   debugPrint('Items: $items');
//     //   debugPrint('--------');
//     // });

//     // categorizedDataAsList = categorizedData.entries.map((e) => e.value).toList();
//     categorizedDataAsList = categorizedData.entries.map((e) {
//       return LocalCategorizedVehicleLogData(
//         measurementTitle: e.key,
//         vehicleMeasurementLogModels: e.value.map((e) {
//           return LocalVehicleMeasurementLogModel(
//             id: e.id,
//             userId: e.userId,
//             vehicleId: e.vehicleId,
//             measurementTitle: e.measurementTitle,
//             currentOdo: e.currentOdo,
//             estimateOdoChanging: e.estimateOdoChanging,
//             amountExpenses: e.amountExpenses,
//             checkpointDate: e.checkpointDate,
//             notes: e.notes,
//             createdAt: e.createdAt,
//             updatedAt: e.updatedAt,
//           );
//         }).toList(),
//       );
//     }).toList();
//     return categorizedDataAsList;
//   }

//   List<CategorizedVehicleLogData> _helperCategorizeFromLocalToRemote(List<LocalVehicleMeasurementLogModel> vehicleMeasurementLogModels) {
//     Map<String, List<LocalVehicleMeasurementLogModel>> categorizedDataLocal = {};
//     List<CategorizedVehicleLogData> categorizedDataLocalAsList = [];
//     for (LocalVehicleMeasurementLogModel item in vehicleMeasurementLogModels) {
//       String category = item.measurementTitle!;
//       if (!categorizedDataLocal.containsKey(category)) {
//         categorizedDataLocal[category] = [];
//       }
//       categorizedDataLocal[category]!.add(item);
//     }
//     // debugPrint("categorizedDataLocal $categorizedDataLocal");

//     // categorizedDataLocal.forEach((category, items) {
//     //   debugPrint('Category: $category');
//     //   debugPrint('Items: $items');
//     //   debugPrint('--------');
//     // });

//     // categorizedDataLocalAsList = categorizedDataLocal.entries.map((e) => e.value).toList();
//     categorizedDataLocalAsList = categorizedDataLocal.entries.map((e) {
//       return CategorizedVehicleLogData(
//         measurementTitle: e.key,
//         vehicleMeasurementLogModels: e.value.map((en) {
//           return VehicleMeasurementLogModel(
//             id: en.id!,
//             userId: en.userId!,
//             vehicleId: en.vehicleId!,
//             measurementTitle: en.measurementTitle!,
//             currentOdo: en.currentOdo!,
//             estimateOdoChanging: en.estimateOdoChanging!,
//             amountExpenses: en.amountExpenses!,
//             checkpointDate: en.checkpointDate!,
//             notes: en.notes!,
//             createdAt: en.createdAt!,
//             updatedAt: en.updatedAt!,
//           );
//         }).toList(),
//       );
//     }).toList();

//     return categorizedDataLocalAsList;
//   }

//   Future<void> _getAllVehicleRemoteAction(
//     AppVehicleReposistory appVehicleReposistory,
//     GetAllVehicleDataRemoteAction event,
//   ) async {
//     emit(GetAllVehicleLoading());
//     // await Future.delayed(const Duration(milliseconds: 500));
//     try {
//       String? userToken = await AccountLocalRepository().getUserToken();
//       if (userToken == null) {
//         emit(
//           GetAllVehicleFailed(errorMessage: "Failed To Get Support Data"),
//         );
//         return;
//       }

//       GetAllVehicleDataResponseModel? getAllVehicleDataResponseModel = await appVehicleReposistory.getAllVehicleData(
//         userToken,
//       );
//       if (getAllVehicleDataResponseModel != null) {
//         if (getAllVehicleDataResponseModel.status == 200) {
//           VehicleLocalDataModel localData = VehicleLocalDataModel(
//             listVehicleData: getAllVehicleDataResponseModel.data!.map((e) {
//               return VehicleDatam(
//                 id: e.id,
//                 userId: e.userId,
//                 vehicleName: e.vehicleName,
//                 vehicleImage: e.vehicleImage,
//                 year: e.year,
//                 engineCapacity: e.engineCapacity,
//                 tankCapacity: e.tankCapacity,
//                 color: e.color,
//                 machineNumber: e.machineNumber,
//                 chassisNumber: e.chassisNumber,
//                 categorizedLog: _helperCategorizeFromRemoteToLocal(e.vehicleMeasurementLogModels!),
//                 vehicleMeasurementLogModels: e.vehicleMeasurementLogModels!.map((e) {
//                   return LocalVehicleMeasurementLogModel(
//                     id: e.id,
//                     userId: e.userId,
//                     vehicleId: e.vehicleId,
//                     measurementTitle: e.measurementTitle,
//                     currentOdo: e.currentOdo,
//                     estimateOdoChanging: e.estimateOdoChanging,
//                     amountExpenses: e.amountExpenses,
//                     checkpointDate: e.checkpointDate,
//                     notes: e.notes,
//                     createdAt: e.createdAt,
//                     updatedAt: e.updatedAt,
//                   );
//                 }).toList(),
//               );
//             }).toList(),
//           );
//           await event.vehicleLocalRepository.saveLocalVehicleData(data: localData);
//           GetAllVehicleDataResponseModel output = GetAllVehicleDataResponseModel(
//             status: getAllVehicleDataResponseModel.status,
//             message: getAllVehicleDataResponseModel.message,
//             data: localData.listVehicleData!.map((e) {
//               return DatumVehicle(
//                 id: e.id!,
//                 userId: e.userId!,
//                 vehicleName: e.vehicleName!,
//                 vehicleImage: e.vehicleImage!,
//                 year: e.year!,
//                 engineCapacity: e.engineCapacity!,
//                 tankCapacity: e.tankCapacity!,
//                 color: e.color!,
//                 machineNumber: e.machineNumber!,
//                 chassisNumber: e.chassisNumber!,
//                 categorizedData: _helperCategorizeFromLocalToRemote(e.vehicleMeasurementLogModels!),
//                 vehicleMeasurementLogModels: e.vehicleMeasurementLogModels!.map((e) {
//                   return VehicleMeasurementLogModel(
//                     id: e.id!,
//                     userId: e.userId!,
//                     vehicleId: e.vehicleId!,
//                     measurementTitle: e.measurementTitle!,
//                     currentOdo: e.currentOdo!,
//                     estimateOdoChanging: e.estimateOdoChanging!,
//                     amountExpenses: e.amountExpenses!,
//                     checkpointDate: e.checkpointDate!,
//                     notes: e.notes!,
//                     createdAt: e.createdAt!,
//                     updatedAt: e.updatedAt!,
//                   );
//                 }).toList(),
//               );
//             }).toList(),
//           );
//           if (output.data!.isEmpty) {
//             emit(
//               GetAllVehicleFailed(
//                 errorMessage: "Data is empty",
//               ),
//             );
//           } else {
//             emit(
//               GetAllVehicleSuccess(
//                 getAllVehicleDataResponseModel: output,
//               ),
//             );
//           }
//         } else {
//           emit(
//             GetAllVehicleFailed(
//               errorMessage: getAllVehicleDataResponseModel.message.toString(),
//             ),
//           );
//         }
//       } else {
//         emit(
//           GetAllVehicleFailed(
//             errorMessage: "Terjadi kesalahan, data kosong",
//           ),
//         );
//       }
//     } catch (errorMessage) {
//       emit(
//         GetAllVehicleFailed(
//           errorMessage: errorMessage.toString(),
//         ),
//       );
//     }
//   }

//   Future<void> _getAllVehicleLocalAction(
//     VehicleLocalRepository vehicleLocalRepository,
//   ) async {
//     emit(GetAllVehicleLoading());
//     // await Future.delayed(const Duration(milliseconds: 500));
//     try {
//       VehicleLocalDataModel? vehicleLocalDataModel = await vehicleLocalRepository.getLocalVehicleData();
//       if (vehicleLocalDataModel != null) {
//         GetAllVehicleDataResponseModel output = GetAllVehicleDataResponseModel(
//           status: 200,
//           message: "Success",
//           data: vehicleLocalDataModel.listVehicleData!.map((e) {
//             return DatumVehicle(
//               id: e.id!,
//               userId: e.userId!,
//               vehicleName: e.vehicleName!,
//               vehicleImage: e.vehicleImage!,
//               year: e.year!,
//               engineCapacity: e.engineCapacity!,
//               tankCapacity: e.tankCapacity!,
//               color: e.color!,
//               machineNumber: e.machineNumber!,
//               chassisNumber: e.chassisNumber!,
//               categorizedData: _helperCategorizeFromLocalToRemote(e.vehicleMeasurementLogModels!),
//               vehicleMeasurementLogModels: e.vehicleMeasurementLogModels!.map((e) {
//                 return VehicleMeasurementLogModel(
//                   id: e.id!,
//                   userId: e.userId!,
//                   vehicleId: e.vehicleId!,
//                   measurementTitle: e.measurementTitle!,
//                   currentOdo: e.currentOdo!,
//                   estimateOdoChanging: e.estimateOdoChanging!,
//                   amountExpenses: e.amountExpenses!,
//                   checkpointDate: e.checkpointDate!,
//                   notes: e.notes!,
//                   createdAt: e.createdAt!,
//                   updatedAt: e.updatedAt!,
//                 );
//               }).toList(),
//             );
//           }).toList(),
//         );
//         emit(
//           GetAllVehicleSuccess(
//             getAllVehicleDataResponseModel: output,
//           ),
//         );
//         // if (output.data!.isEmpty) {
//         //   emit(
//         //     GetAllVehicleFailed(
//         //       errorMessage: "Data is empty",
//         //     ),
//         //   );
//         // } else {
//         //   emit(
//         //     GetAllVehicleSuccess(
//         //       getAllVehicleDataResponseModel: output,
//         //     ),
//         //   );
//         // }
//       } else {
//         emit(
//           GetAllVehicleFailed(
//             errorMessage: "Failed to Get Vehicle Data",
//           ),
//         );
//       }
//     } catch (errorMessage) {
//       emit(
//         GetAllVehicleFailed(
//           errorMessage: errorMessage.toString(),
//         ),
//       );
//     }
//   }

//   Future<void> _getProfileDataAction(
//     AccountLocalRepository localRepository,
//   ) async {
//     emit(GetAllVehicleLoading());
//     await Future.delayed(const Duration(milliseconds: 500));
//     try {
//       UserDataEntity? userDataEntity = await localRepository.getLocalAccountData();
//       if (userDataEntity != null) {
//         emit(GetProfileDataVehicleSuccess(
//           accountDataUserModel: userDataEntity,
//         ));
//       } else {
//         emit(
//           GetAllVehicleFailed(errorMessage: "Failed To Get Profile Data"),
//         );
//       }
//     } catch (errorMessage) {
//       emit(
//         GetAllVehicleFailed(
//           errorMessage: errorMessage.toString(),
//         ),
//       );
//     }
//   }
// }
