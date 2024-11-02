import 'package:flutter/widgets.dart';
import 'package:project_vehicle_log_app/data/model/remote/device/request/check_device_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/device/response/check_device_response_model.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';
import 'package:project_vehicle_log_app/support/app_api_service.dart';

class DeviceRepository {
  final AppApiService appApiService;
  DeviceRepository(this.appApiService);

  Future<CheckDeviceResponseModel?> checkDevice(
    CheckDeviceRequestModel data,
    String token,
  ) async {
    try {
      final response = await appApiService.call(
        AppApiPath.checkDevice,
        method: MethodRequest.post,
        request: data.toJson(),
        header: <String, String>{
          'token': token,
        },
      );
      if (response.data != null) {
        return CheckDeviceResponseModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (errorMessage) {
      debugPrint("[DeviceRepository][checkDevice] errorMessage $errorMessage");
      return null;
    }
  }
}
