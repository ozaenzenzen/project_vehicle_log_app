import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/create_log_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/create_log_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/create_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/create_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/edit_measurement_log_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/edit_measurement_log_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/edit_vehicle_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/edit_vehicle_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_all_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/request/get_log_vehicle_data_request_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/get_all_vehicle_data_response_model_v2.dart';
import 'package:project_vehicle_log_app/data/model/remote/vehicle/response/get_log_vehicle_data_response_model_v2.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';
import 'package:project_vehicle_log_app/support/app_api_service.dart';

class AppVehicleRepository {
  final AppApiService appApiService;
  AppVehicleRepository(this.appApiService);

  Future<GetAllVehicleResponseModelV2?> getAllVehicleDataV2(
    String token,
    GetAllVehicleRequestModelV2 reqData,
  ) async {
    try {
      Map<String, dynamic> req = reqData.toJson();
      if (reqData.sortOrder == null) {
        req.remove("sort_order");
      }
      final response = await appApiService.call(
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
      final response = await appApiService.call(
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

  Future<CreateVehicleResponseModel?> createVehicleData({
    required CreateVehicleRequestModel createVehicleRequestModel,
    required String token,
  }) async {
    try {
      final response = await appApiService.call(
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
      final response = await appApiService.call(
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
      final response = await appApiService.call(
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
      final response = await appApiService.call(
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
      final response = await appApiService.call(
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
