import 'package:flutter/material.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/get_userdata_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signin_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signin_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signup_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/signup_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/request/edit_profile_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/response/edit_profile_response_model.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';
import 'package:project_vehicle_log_app/support/app_api_service.dart';

class AppAccountReposistory {
  Future<SignInResponseModel?> signin(SignInRequestModel data) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.signInAccount,
        request: data.toJson(),
      );
      if (response.data != null) {
        return SignInResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      debugPrint("[AppAccountReposistory][signin] errorMessage $errorMessage");
      return null;
    }
  }

  Future<SignUpResponseModel?> signup(SignUpRequestModel data) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.signUpAccount,
        request: data.toJson(),
      );
      if (response.data != null) {
        return SignUpResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      debugPrint("[AppAccountReposistory][signup] errorMessage $errorMessage");
      return null;
    }
  }

  Future<GetUserDataResponseModel?> getUserdata({required String token}) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
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
      debugPrint("[AppAccountReposistory][getUserdata] errorMessage $errorMessage");
      return null;
    }
  }

  Future<EditProfileResponseModel?> editProfile({
    required EditProfileRequestModel data,
    required String token,
  }) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.editProfile,
        method: MethodRequest.post,
        request: data.toJson(),
        header: <String, String>{
          'token': token,
        },
      );
      return EditProfileResponseModel.fromJson(response.data);
    } catch (errorMessage) {
      debugPrint("[AppAccountReposistory][editProfile] errorMessage $errorMessage");
      return null;
    }
  }
}
