// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/local_repository/vehicle_local_repository.dart';

part 'signout_event.dart';
part 'signout_state.dart';

class SignoutBloc extends Bloc<SignoutEvent, SignoutState> {
  SignoutBloc(
    AccountLocalRepository accountLocalRepository,
    VehicleLocalRepository vehicleLocalRepository,
  ) : super(SignoutInitial()) {
    on<SignoutEvent>((event, emit) {
      if (event is SignoutAction) {
        _signOutAction(
          accountLocalRepository: accountLocalRepository,
          vehicleLocalRepository: vehicleLocalRepository,
        );
      }
    });
  }
  Future<void> _signOutAction({
    required AccountLocalRepository accountLocalRepository,
    required VehicleLocalRepository vehicleLocalRepository,
  }) async {
    emit(SignoutLoading());
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      await accountLocalRepository.removeLocalAccountData();
      await accountLocalRepository.removeRefreshToken();
      await accountLocalRepository.removeUserToken();
      await accountLocalRepository.removeDataToken();
      await accountLocalRepository.setIsSignOut();
      await vehicleLocalRepository.removeLocalVehicleDataV2();
      emit(SignoutSuccess());
    } catch (errorMessage) {
      emit(
        SignoutFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
