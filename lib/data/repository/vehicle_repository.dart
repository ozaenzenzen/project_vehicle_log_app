import 'package:dio/dio.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/create_log_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/create_log_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/create_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/create_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_measurement_log_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_measurement_log_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/edit_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_all_vehicle_data_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/get_log_vehicle_data_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/get_all_vehicle_data_response_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/get_log_vehicle_data_response_model_v2.dart';
import 'package:project_vehicle_log_app/env.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';
import 'package:project_vehicle_log_app/support/app_api_service.dart';

class AppVehicleReposistory {
  Future<GetAllVehicleResponseModelV2?> getAllVehicleDataV2(
    String token,
    GetAllVehicleRequestModelV2 reqData,
  ) async {
    try {
      Map<String, dynamic> req = reqData.toJson();
      if (reqData.sortOrder == null) {
        req.remove("sort_order");
      }
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.getAllVehicleV2,
        method: MethodRequest.post,
        request: req,
        header: {"token": token},
      );
      if (response.data != null) {
        return GetAllVehicleResponseModelV2.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      rethrow;
    }
  }

  Future<GetLogVehicleResponseModelV2?> getLogVehicleDataV2(
    String token,
    GetLogVehicleRequestModelV2 reqData,
  ) async {
    try {
      Map<String, dynamic> req = reqData.toJson();
      if (reqData.sortOrder == null) {
        req.remove("sort_order");
      }
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.getLogVehicleV2,
        method: MethodRequest.post,
        request: req,
        header: {"token": token},
      );
      if (response.data != null) {
        return GetLogVehicleResponseModelV2.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      rethrow;
    }
  }

  Future<GetAllVehicleDataResponseModel?> getAllVehicleData(String token) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.getAllVehicle,
        method: MethodRequest.get,
        header: {"token": token},
      );
      return GetAllVehicleDataResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      return GetAllVehicleDataResponseModel(
        status: e.response?.data['status'],
        message: e.response?.data['Message'],
      );
      // if (e.response?.data is Map) {
      //   return DataState.error(
      //     exception: e,
      //     stackTrace: e.stackTrace,
      //     message: e.response?.data['Message'] ?? "Error",
      //     code: int.tryParse('${e.response?.data['StatusCode']}'),
      //   );
      // }
    } catch (errorMessage) {
      return null;
    }
  }

  Future<GetLogVehicleDataResponseModel> getLogVehicleData(String id) async {
    final response = await AppApiService(
      EnvironmentConfig.baseUrl(),
    ).call(
      AppApiPath.getLogVehicle,
      method: MethodRequest.get,
      header: {"usd": id},
    );
    return GetLogVehicleDataResponseModel.fromJson(response.data);
  }

  Future<CreateVehicleResponseModel?> createVehicleData({
    required CreateVehicleRequestModel createVehicleRequestModel,
    required String token,
  }) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.createVehicle,
        method: MethodRequest.post,
        request: createVehicleRequestModel.toJson(),
        header: {
          "token": token,
        },
      );
      return CreateVehicleResponseModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<EditVehicleResponseModel?> editVehicleData({
    required EditVehicleRequestModel editVehicleRequestModel,
    required String token,
  }) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.editVehicle,
        method: MethodRequest.post,
        request: editVehicleRequestModel.toJson(),
        header: {
          "token": token,
        },
      );
      return EditVehicleResponseModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<CreateLogVehicleResponseModel?> createLogVehicleData({
    required CreateLogVehicleRequestModel createLogVehicleRequestModel,
    required String token,
  }) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.createLogVehicle,
        method: MethodRequest.post,
        request: createLogVehicleRequestModel.toJson(),
        header: {
          "token": token,
        },
      );
      return CreateLogVehicleResponseModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<EditMeasurementLogResponseModel?> editMeasurementLogVehicleData({
    required EditMeasurementLogRequestModel editMeasurementLogRequestModel,
    required String token,
  }) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.editMeasurementLogLogVehicle,
        method: MethodRequest.put,
        request: editMeasurementLogRequestModel.toJson(),
        header: {
          "token": token,
        },
      );
      return EditMeasurementLogResponseModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<CreateLogVehicleResponseModel?> deleteMeasurementLogVehicleData({
    required CreateLogVehicleRequestModel createLogVehicleRequestModel,
    required String token,
  }) async {
    try {
      final response = await AppApiService(
        EnvironmentConfig.baseUrl(),
      ).call(
        AppApiPath.deleteMeasurementLogVehicle,
        method: MethodRequest.delete,
        request: createLogVehicleRequestModel.toJson(),
        header: {
          "token": token,
        },
      );
      return CreateLogVehicleResponseModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
