import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/domain/entities/account/forgot_password_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/account/token_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/account/user_data_entity.dart';
import 'package:project_vehicle_log_app/domain/entities/account/user_register_data_entity.dart';
import 'package:project_vehicle_log_app/support/local_service.dart';

class AccountLocalRepository {
  String userDataV2 = "userDataV2";
  String isSignIn = "isSignIn";
  String isOnboardingDone = "isOnboardingDone";
  String dataToken = "dataToken";
  String userToken = "userToken";
  String refreshToken = "refreshToken";

  String forgotPasswordProcessHistory = "forgotPasswordProcessHistory";
  String forgotPasswordProcessHistorySingle = "forgotPasswordProcessHistorySingle";
  String userRegisterData = "userRegisterData";


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

  // Future<List<ForgotPasswordDataEntity>> getForgotPasswordProcessHistory() async {
  //   try {
  //     String? result = LocalService.instance.box.read(forgotPasswordProcessHistory);
  //     if (result != null) {
  //       debugPrint("[getForgotPasswordProcessHistory] data: $result");
  //       var stringToMap = jsonDecode(result);
  //       ForgotPasswordListDataMapper mapToObject = ForgotPasswordListDataMapper.fromJson(stringToMap);

  //       // List<Map<String, dynamic>> mapFromString = jsonDecode(result);
  //       // List<ForgotPasswordDataEntity> dataFromMap = List<ForgotPasswordDataEntity>.from(mapFromString.map((x) => ForgotPasswordDataEntity.fromJson(x)));
  //       // List<ForgotPasswordDataEntity> dataFromMap = List<ForgotPasswordDataEntity>.from(result.map((x) => ForgotPasswordDataEntity.fromJson(x)));
  //       return mapToObject.listData;
  //     } else {
  //       return [];
  //     }
  //   } catch (errorMessage) {
  //     AppLoggerCS.debugLog("[getForgotPasswordProcessHistory][error] $errorMessage");
  //     return [];
  //   }
  // }

  // Future<void> setForgotPasswordProcessHistory(ForgotPasswordDataEntity input) async {
  //   try {
  //     List<ForgotPasswordDataEntity> listData = await getForgotPasswordProcessHistory();
  //     AppLoggerCS.debugLog("[setForgotPasswordProcessHistory] get ${LocalService.instance.box.read(forgotPasswordProcessHistory)}");
  //     listData.add(input);

  //     ForgotPasswordListDataMapper dataObject = ForgotPasswordListDataMapper(listData: listData);
  //     String formatToString = jsonEncode(dataObject.toJson());
  //     await LocalService.instance.box.write(forgotPasswordProcessHistory, formatToString);
  //   } catch (errorMessage) {
  //     AppLoggerCS.debugLog("[setForgotPasswordProcessHistory][error] $errorMessage");
  //     rethrow;
  //   }
  // }

  Future<ForgotPasswordDataEntity?> getForgotPasswordProcessHistorySingle() async {
    try {
      String? result = LocalService.instance.box.read(forgotPasswordProcessHistorySingle);
      if (result != null) {
        debugPrint("[getForgotPasswordProcessHistorySingle] data: $result");
        var stringToMap = jsonDecode(result);
        ForgotPasswordDataEntity mapToObject = ForgotPasswordDataEntity.fromJson(stringToMap);

        return mapToObject;
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[getForgotPasswordProcessHistorySingle][error] $errorMessage");
      return null;
    }
  }

  Future<void> setForgotPasswordProcessHistorySingle(ForgotPasswordDataEntity input) async {
    try {
      String objectToString = jsonEncode(input.toJson());
      await LocalService.instance.box.write(forgotPasswordProcessHistorySingle, objectToString);
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[setForgotPasswordProcessHistorySingle][error] $errorMessage");
      rethrow;
    }
  }

  Future<void> setRegisterUserData({
    required UserRegisterDataEntity data,
  }) async {
    try {
      await LocalService.instance.box.write(
        userRegisterData,
        jsonEncode(data.toJson()),
      );
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[setEmailRegisterData][error] $errorMessage");
      rethrow;
    }
  }

  Future<UserRegisterDataEntity?> getRegisterUserData() async {
    try {
      var data = LocalService.instance.box.read(userRegisterData);
      if (data != null) {
        UserRegisterDataEntity result = UserRegisterDataEntity.fromJson(jsonDecode(data));
        return result;
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[getEmailRegisterData][error] $errorMessage");
      return null;
    }
  }
}
