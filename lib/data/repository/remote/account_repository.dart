import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/get_userdata_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/refresh_token_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/signin_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/signin_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/signup_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/signup_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/request/edit_profile_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/response/edit_profile_response_model.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';
import 'package:project_vehicle_log_app/support/app_api_service.dart';

class AppAccountRepository {
  final AppApiService appApiService;
  AppAccountRepository(this.appApiService);
  
  Future<SignInResponseModel?> signin(SignInRequestModel data) async {
    try {
      final response = await appApiService.call(
        AppApiPath.signInAccount,
        request: data.toJson(),
      );
      if (response.data != null) {
        return SignInResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      debugPrint("[AppAccountRepository][signin] errorMessage $errorMessage");
      return null;
    }
  }

  Future<SignUpResponseModel?> signup(SignUpRequestModel data) async {
    try {
      final response = await appApiService.call(
        AppApiPath.signUpAccount,
        request: data.toJson(),
      );
      if (response.data != null) {
        return SignUpResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      debugPrint("[AppAccountRepository][signup] errorMessage $errorMessage");
      return null;
    }
  }

  Future<GetUserDataResponseModel?> getUserdata({required String token}) async {
    try {
      final response = await appApiService.call(
        AppApiPath.getUserData,
        method: MethodRequest.get,
        header: <String, String>{
          'token': token,
        },
      );
      if (response.data != null) {
        return GetUserDataResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      debugPrint("[AppAccountRepository][getUserdata] errorMessage $errorMessage");
      return null;
    }
  }

  Future<EditProfileResponseModel?> editProfile({
    required EditProfileRequestModel data,
    required String token,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.editProfile,
        method: MethodRequest.post,
        request: data.toJson(),
        header: <String, String>{
          'token': token,
        },
      );
      return EditProfileResponseModel.fromJson(response.data);
    } catch (errorMessage) {
      debugPrint("[AppAccountRepository][editProfile] errorMessage $errorMessage");
      return null;
    }
  }

  Future<RefreshTokenResponseModel?> refreshToken({
    required String refreshToken,
    required String token,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.refreshToken,
        method: MethodRequest.get,
        header: <String, String>{
          'token': token,
          'refreshToken': refreshToken,
        },
      );
      return RefreshTokenResponseModel.fromJson(response.data);
    } catch (errorMessage) {
      debugPrint("[AppAccountRepository][refreshToken] errorMessage $errorMessage");
      return null;
    }
  }
}
