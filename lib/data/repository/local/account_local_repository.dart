import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/domain/entities/account/token_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/account/user_data_entity.dart';
import 'package:project_vehicle_log_app/support/local_service.dart';

class AccountLocalRepository {
  String userDataV2 = "userDataV2";
  String isSignIn = "isSignIn";
  String isOnboardingDone = "isOnboardingDone";
  String dataToken = "dataToken";
  String userToken = "userToken";
  String refreshToken = "refreshToken";

  Future<void> removeLocalAccountData() async {
    try {
      await LocalService.instance.box.remove(userDataV2);
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[removeLocalAccountData][error] $errorMessage");
      rethrow;
    }
  }

  Future<void> setLocalAccountData({
    required UserDataEntity data,
  }) async {
    try {
      await LocalService.instance.box.write(
        userDataV2,
        jsonEncode(data.toJson()),
      );
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[saveLocalAccountData][error] $errorMessage");
      rethrow;
    }
  }

  Future<UserDataEntity?> getLocalAccountData() async {
    try {
      String? dataFromLocal = LocalService.instance.box.read(userDataV2);
      if (dataFromLocal != null) {
        UserDataEntity? userData = UserDataEntity.fromJson(jsonDecode(dataFromLocal));
        return userData;
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[getLocalAccountData][error] $errorMessage");
      return null;
    }
  }

  Future<void> removeDataToken() async {
    try {
      await LocalService.instance.box.remove(dataToken);
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[removeDataToken][error] $errorMessage");
      rethrow;
    }
  }

  Future<void> setDataToken({
    required TokenDataEntity data,
  }) async {
    try {
      await LocalService.instance.box.write(
        dataToken,
        jsonEncode(data.toJson()),
      );
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[setDataToken][error] $errorMessage");
      rethrow;
    }
  }

  Future<TokenDataEntity?> getDataToken() async {
    try {
      String? data = LocalService.instance.box.read(dataToken);
      if (data != null) {
        TokenDataEntity result = TokenDataEntity.fromJson(jsonDecode(data));
        return result;
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[getDataToken][error] $errorMessage");
      return null;
    }
  }

  Future<void> removeUserToken() async {
    try {
      await LocalService.instance.box.remove(userToken);
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[removeUserToken][error] $errorMessage");
      rethrow;
    }
  }

  Future<void> setUserToken({
    required String data,
  }) async {
    try {
      await LocalService.instance.box.write(
        userToken,
        data,
      );
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[setUserToken][error] $errorMessage");
      rethrow;
    }
  }

  Future<String?> getUserToken() async {
    try {
      String? result = LocalService.instance.box.read(userToken);
      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[getUserToken][error] $errorMessage");
      return null;
    }
  }

  Future<void> removeRefreshToken() async {
    try {
      await LocalService.instance.box.remove(refreshToken);
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[removeRefreshToken][error] $errorMessage");
      rethrow;
    }
  }

  Future<void> setRefreshToken({
    required String data,
  }) async {
    try {
      await LocalService.instance.box.write(
        refreshToken,
        data,
      );
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[setRefreshToken][error] $errorMessage");
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      String? result = LocalService.instance.box.read(refreshToken);
      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[getRefreshToken][error] $errorMessage");
      return null;
    }
  }

  Future<bool?> getIsSignIn() async {
    try {
      bool? result = LocalService.instance.box.read(isSignIn);
      if (result != null) {
        debugPrint("[getIsSignIn] data: $result");
        return result;
      } else {
        return false;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[getIsSignIn][error] $errorMessage");
      return false;
    }
  }

  Future<void> setIsSignIn() async {
    try {
      await LocalService.instance.box.write(isSignIn, true);
      debugPrint("[setIsSignIn] isSignIn ${LocalService.instance.box.read(isSignIn)}");
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[setIsSignIn][error] $errorMessage");
      rethrow;
    }
  }

  Future<void> setIsSignOut() async {
    try {
      await LocalService.instance.box.write(isSignIn, false);
      debugPrint("[setIsSignOut] isSignIn ${LocalService.instance.box.read(isSignIn)}");
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[setIsSignOut][error] $errorMessage");
      rethrow;
    }
  }

  Future<void> setIsOnboardingDone() async {
    try {
      await LocalService.instance.box.write(isOnboardingDone, true);
      debugPrint("[setIsOnboardingDone] isSignIn ${LocalService.instance.box.read(isSignIn)}");
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[setIsOnboardingDone][error] $errorMessage");
      rethrow;
    }
  }
}
