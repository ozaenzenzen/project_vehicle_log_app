// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/model/remote/device/request/check_device_request_model.dart';
import 'package:project_vehicle_log_app/data/repository/local/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/signin_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/signin_response_models.dart';
import 'package:project_vehicle_log_app/data/repository/remote/account_repository.dart';
import 'package:project_vehicle_log_app/data/repository/remote/device_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/account/token_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/account/user_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/device/device_info_data_entity.dart';
import 'package:project_vehicle_log_app/support/app_device_info.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc(
    AppAccountRepository accountRepository,
    DeviceRepository deviceRepository,
  ) : super(SigninInitial()) {
    on<SigninEvent>((event, emit) {
      if (event is SigninAction) {
        _signInAction(
          accountRepository,
          deviceRepository,
          event,
        );
      }
    });
  }

  Future<void> _signInAction(
    AppAccountRepository accountRepository,
    DeviceRepository deviceRepository,
    SigninAction event,
  ) async {
    emit(SigninLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      SignInResponseModel? signInResponseModel = await accountRepository.signin(
        event.signInRequestModel,
      );
      if (signInResponseModel != null) {
        if (signInResponseModel.status == 200) {
          UserDataEntity? entity = signInResponseModel.toUserDataEntity();
          await AccountLocalRepository().setLocalAccountData(
            data: entity!,
          );
          await AccountLocalRepository().setDataToken(
            data: TokenDataEntity(
              userStamp: signInResponseModel.data!.userStamp!,
              accessToken: signInResponseModel.data!.accessToken!,
              accessTokenExpiryTime: signInResponseModel.data!.accessTokenExpiryTime!,
              refreshToken: signInResponseModel.data!.refreshToken!,
              refreshTokenExpiryTime: signInResponseModel.data!.refreshTokenExpiryTime!,
            ),
          );
          await AccountLocalRepository().setUserToken(data: signInResponseModel.data!.accessToken!);
          await AccountLocalRepository().setRefreshToken(data: signInResponseModel.data!.refreshToken!);
          await AccountLocalRepository().setIsSignIn();

          DeviceInfoDataEntity deviceInfoDataEntity = await AppDeviceInfo().getDeviceData();

          CheckDeviceRequestModel checkDeviceRequestModel = CheckDeviceRequestModel(
            deviceId: deviceInfoDataEntity.deviceId,
            deviceName: deviceInfoDataEntity.deviceName,
            deviceType: deviceInfoDataEntity.deviceType,
            osVersion: deviceInfoDataEntity.osVersion,
            appVersion: deviceInfoDataEntity.appVersion,
            pushToken: deviceInfoDataEntity.pushToken ?? "pushToken",
            // lastActive: DateTime.parse(DateTime.now().toUtc()),
            lastActive: DateTime.now().toUtc(),
          );

          // AppLogger.debugLog("checkDeviceRequestModel ${jsonEncode(checkDeviceRequestModel.toJson())}");
          await deviceRepository.checkDevice(
            checkDeviceRequestModel,
            signInResponseModel.data!.accessToken!,
          );

          // CheckDeviceResponseModel? checkDeviceResponseModel = await deviceRepository.checkDevice(
          //   checkDeviceRequestModel,
          //   signInResponseModel.data!.accessToken!,
          // );
          // if (checkDeviceResponseModel != null) {
          //   AppLogger.debugLog("checkDeviceResponseModel ${jsonEncode(checkDeviceResponseModel.toJson())}");
          // }
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
