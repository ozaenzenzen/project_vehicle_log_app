// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/local/vehicle_local_data_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signin_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signin_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
import 'package:project_vehicle_log_app/data/repository/account_repository.dart';
import 'package:project_vehicle_log_app/data/repository/vehicle_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/user_data_entity.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc(AppAccountReposistory accountReposistory) : super(SigninInitial()) {
    on<SigninEvent>((event, emit) {
      if (event is SigninAction) {
        _signInAction(accountReposistory, event);
      }
    });
  }

  List<LocalCategorizedVehicleLogData> _helperCategorizeFromRemoteToLocal(List<VehicleMeasurementLogModel> vehicleMeasurementLogModels) {
    Map<String, List<VehicleMeasurementLogModel>> categorizedData = {};
    List<LocalCategorizedVehicleLogData> categorizedDataAsList = [];
    for (VehicleMeasurementLogModel item in vehicleMeasurementLogModels) {
      String category = item.measurementTitle!;
      if (!categorizedData.containsKey(category)) {
        categorizedData[category] = [];
      }
      categorizedData[category]!.add(item);
    }

    // categorizedData.forEach((category, items) {
    //   debugPrint('Category: $category');
    //   debugPrint('Items: $items');
    //   debugPrint('--------');
    // });

    // categorizedDataAsList = categorizedData.entries.map((e) => e.value).toList();
    categorizedDataAsList = categorizedData.entries.map((e) {
      return LocalCategorizedVehicleLogData(
        measurementTitle: e.key,
        vehicleMeasurementLogModels: e.value.map((e) {
          return LocalVehicleMeasurementLogModel(
            id: e.id,
            userId: e.userId,
            vehicleId: e.vehicleId,
            measurementTitle: e.measurementTitle,
            currentOdo: e.currentOdo,
            estimateOdoChanging: e.estimateOdoChanging,
            amountExpenses: e.amountExpenses,
            checkpointDate: e.checkpointDate,
            notes: e.notes,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
          );
        }).toList(),
      );
    }).toList();
    return categorizedDataAsList;
  }

  Future<void> _signInAction(
    AppAccountReposistory accountReposistory,
    SigninAction event,
  ) async {
    emit(SigninLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      SignInResponseModel? signInResponseModel = await accountReposistory.signin(
        event.signInRequestModel,
      );
      if (signInResponseModel != null) {
        if (signInResponseModel.status == 200) {
          UserDataEntity? entity = signInResponseModel.toUserDataEntity();
          // await AccountLocalRepository().setLocalAccountData(
          //   data: entity!,
          // );
          // await AccountLocalRepository().setUserToken(data: signInResponseModel.data!.token!);
          // await AccountLocalRepository().setRefreshToken(data: signInResponseModel.data!.refreshToken!);
          // await AccountLocalRepository().setIsSignIn();
          // emit(
          //   SigninSuccess(
          //     userdata: entity,
          //   ),
          // );
          GetAllVehicleDataResponseModel? getAllVehicleDataResponseModel = await event.appVehicleReposistory!.getAllVehicleData(
            signInResponseModel.data!.token.toString(),
          );
          if (getAllVehicleDataResponseModel != null) {
            if (getAllVehicleDataResponseModel.status == 200) {
              VehicleLocalDataModel data = VehicleLocalDataModel(
                listVehicleData: getAllVehicleDataResponseModel.data!
                    .map((e) => VehicleDatam(
                          id: e.id,
                          userId: e.userId,
                          vehicleName: e.vehicleName,
                          vehicleImage: e.vehicleImage,
                          year: e.year,
                          engineCapacity: e.engineCapacity,
                          tankCapacity: e.tankCapacity,
                          color: e.color,
                          machineNumber: e.machineNumber,
                          chassisNumber: e.chassisNumber,
                          categorizedLog: _helperCategorizeFromRemoteToLocal(e.vehicleMeasurementLogModels!),
                          vehicleMeasurementLogModels: e.vehicleMeasurementLogModels!
                              .map(
                                (e) => LocalVehicleMeasurementLogModel(
                                  id: e.id,
                                  userId: e.userId,
                                  vehicleId: e.vehicleId,
                                  measurementTitle: e.measurementTitle,
                                  currentOdo: e.currentOdo,
                                  estimateOdoChanging: e.estimateOdoChanging,
                                  amountExpenses: e.amountExpenses,
                                  checkpointDate: e.checkpointDate,
                                  notes: e.notes,
                                  createdAt: e.createdAt,
                                  updatedAt: e.updatedAt,
                                ),
                              )
                              .toList(),
                        ))
                    .toList(),
              );
              await AccountLocalRepository().setLocalAccountData(
                data: entity!,
              );
              await AccountLocalRepository().setUserToken(data: signInResponseModel.data!.token!);
              await AccountLocalRepository().setRefreshToken(data: signInResponseModel.data!.refreshToken!);
              await AccountLocalRepository().setIsSignIn();
              await event.vehicleLocalRepository.saveLocalVehicleData(data: data);
              emit(
                SigninSuccess(
                  userdata: entity,
                ),
              );
            } else {
              emit(
                SigninFailed(
                  errorMessage: signInResponseModel.message.toString(),
                ),
              );
            }
          } else {
            emit(
              SigninFailed(
                errorMessage: signInResponseModel.message.toString(),
              ),
            );
          }
        } else {
          emit(
            SigninFailed(
              errorMessage: signInResponseModel.message.toString(),
            ),
          );
        }
      } else {
        emit(
          SigninFailed(
            errorMessage: "Terjadi kesalahan, data kosong",
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        SigninFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
