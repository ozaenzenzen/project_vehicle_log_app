// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:fam_coding_supply/logic/export.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/support/config/language/language.dart';
import 'package:project_vehicle_log_app/support/config/language/language_controller.dart';
import 'package:restart_app/restart_app.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LanguageEvent>((event, emit) {
      if (event is ChangeLanguageAction) {
        _changeLanguageAction(event);
      }
    });
  }

  Future<void> _changeLanguageAction(
    ChangeLanguageAction event,
  ) async {
    emit(LanguageLoading());
    try {
      await LanguageController.switchLanguage(
        event.context,
        event.language,
      ).then((value) {
        AppLoggerCS.debugLog("value: ${value.locale1}");
        emit(LanguageSuccess(language: value));
        Restart.restartApp(
          /// In Web Platform, Fill webOrigin only when your new origin is different than the app's origin
          // webOrigin: 'http://example.com',

          // Customizing the restart notification message (only needed on iOS)
          notificationTitle: 'Restarting App',
          notificationBody: 'Please tap here to open the app again.',
        );
      }).catchError((error, stackTrace) {
        emit(LanguageFailed(
          errorMessage: error.toString(),
        ));
      });
    } catch (errorMessage) {
      emit(
        LanguageFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
