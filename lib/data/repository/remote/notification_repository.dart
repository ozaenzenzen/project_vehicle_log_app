import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:project_vehicle_log_app/data/model/remote/notification/get_notification_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/notification/get_notification_response_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/notification/get_notification_response_model_v2.dart';
import 'package:project_vehicle_log_app/support/app_api_path.dart';
import 'package:project_vehicle_log_app/support/app_api_service.dart';

class AppNotificationRepository {
  final AppApiService appApiService;
  AppNotificationRepository(this.appApiService);

  Future<GetNotificationResponseModel?> getNotification({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await appApiService.call(
        AppApiPath.getNotification + userId,
        method: MethodRequest.get,
        header: <String, String>{
          'token': token,
        },
      );
      return GetNotificationResponseModel.fromJson(response.data);
    } catch (errorMessage) {
      return null;
    }
  }

  Future<GetNotificationResponseModelV2?> getNotificationV2({
    required GetNotificationRequestModel reqData,
    required String token,
  }) async {
    try {
      Map<String, dynamic> req = reqData.toJson();
      if (reqData.sortOrder == null) {
        req.remove("sort_order");
      }
      final response = await appApiService.call(
        AppApiPath.getNotificationV2,
        method: MethodRequest.post,
        request: req,
        header: <String, String>{
          'token': token,
        },
      );
      return GetNotificationResponseModelV2.fromJson(response.data);
    } catch (errorMessage) {
      return null;
    }
  }
}
