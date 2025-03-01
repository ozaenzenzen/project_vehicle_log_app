import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/change_password_forgot_password_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/change_password_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/otp_validation_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/validate_otp_forgot_password_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/change_password_forgot_password_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/change_password_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/delete_account_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/get_userdata_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/otp_resend_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/otp_validation_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/refresh_token_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/signin_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/send_otp_forgot_password_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/signin_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/request/signup_request_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/signup_response_models.dart';
import 'package:project_vehicle_log_app/data/model/remote/account/response/validate_otp_forgot_password_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/request/edit_profile_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/edit_profile/response/edit_profile_response_model.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';

class AppAccountRepository {
  final AppApiServiceCS appApiService;
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
      AppLoggerCS.debugLog("[AppAccountRepository][signin] errorMessage $errorMessage");
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
      AppLoggerCS.debugLog("[AppAccountRepository][signup] errorMessage $errorMessage");
      return null;
    }
  }

  Future<GetUserDataResponseModel?> getUserdata({required String token}) async {
    try {
      final response = await appApiService.call(
        AppApiPath.getUserData,
        method: MethodRequestCS.get,
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
      AppLoggerCS.debugLog("[AppAccountRepository][getUserdata] errorMessage $errorMessage");
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
        method: MethodRequestCS.post,
        request: data.toJson(),
        header: <String, String>{
          'token': token,
        },
      );
      return EditProfileResponseModel.fromJson(response.data);
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][editProfile] errorMessage $errorMessage");
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
        method: MethodRequestCS.get,
        header: <String, String>{
          'token': token,
          'refreshToken': refreshToken,
        },
      );
      return RefreshTokenResponseModel.fromJson(response.data);
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][refreshToken] errorMessage $errorMessage");
      return null;
    }
  }

  Future<ChangePasswordResponseModel?> changePassword({
    required ChangePasswordRequestModel data,
    required String token,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.changePassword,
        method: MethodRequestCS.post,
        request: data.toJson(),
        header: <String, String>{
          'token': token,
        },
      );
      if (response.data != null) {
        return ChangePasswordResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][changePassword] errorMessage $errorMessage");
      return null;
    }
  }

  Future<OtpValidationResponseModel?> otpValidation({
    required OtpValidationRequestModel data,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.otpValidation,
        method: MethodRequestCS.post,
        request: data.toJson(),
      );
      if (response.data != null) {
        return OtpValidationResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][otpValidation] errorMessage $errorMessage");
      return null;
    }
  }

  Future<OtpResendResponseModel?> otpResend({
    required String resendOtpKey,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.otpResend,
        method: MethodRequestCS.post,
        request: <String, String>{
          'resend_otp_key': resendOtpKey,
        },
      );
      if (response.data != null) {
        return OtpResendResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][otpResend] errorMessage $errorMessage");
      return null;
    }
  }

  Future<SendOtpForgotPasswordResponseModel?> sendOTPForgotPassword({
    required String email,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.sendOTPForgotPassword,
        method: MethodRequestCS.post,
        request: <String, String>{
          'email': email,
        },
      );
      AppLoggerCS.debugLog("[AppAccountRepository][sendOTPForgotPassword] response.data ${jsonEncode(response.data)}");
      if (response.data != null) {
        return SendOtpForgotPasswordResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][sendOTPForgotPassword] errorMessage $errorMessage");
      return null;
    }
  }

  Future<ValidateOtpForgotPasswordResponseModel?> validateOTPForgotPassword({
    required ValidateOtpForgotPasswordRequestModel data,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.validateOTPForgotPassword,
        method: MethodRequestCS.post,
        request: data.toJson(),
      );
      AppLoggerCS.debugLog("[AppAccountRepository][validateOTPForgotPassword] response.data ${jsonEncode(response.data)}");
      if (response.data != null) {
        return ValidateOtpForgotPasswordResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][validateOTPForgotPassword] errorMessage $errorMessage");
      return null;
    }
  }

  Future<ChangePasswordForgotPasswordResponseModel?> changePasswordForgotPassword({
    required ChangePasswordForgotPasswordRequestModel data,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.changePasswordForgotPassword,
        method: MethodRequestCS.post,
        request: data.toJson(),
      );
      AppLoggerCS.debugLog("[AppAccountRepository][changePasswordForgotPassword] response.data ${jsonEncode(response.data)}");
      if (response.data != null) {
        return ChangePasswordForgotPasswordResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][changePasswordForgotPassword] errorMessage $errorMessage");
      return null;
    }
  }

  Future<DeleteAccountResponseModel?> deleteAccount({
    required String token,
    String? reason,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.deleteAccount,
        method: MethodRequestCS.post,
        header: {
          'token': token,
        },
        request: {
          'reason': reason ?? "",
        },
      );
      if (response.data != null) {
        return DeleteAccountResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      AppLoggerCS.debugLog("[AppAccountRepository][deleteAccount] errorMessage $errorMessage");
      return null;
    }
  }
}
