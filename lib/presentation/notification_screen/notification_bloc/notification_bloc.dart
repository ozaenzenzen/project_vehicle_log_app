// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:project_vehicle_log_app/data/local_repository/account_local_repository.dart';
import 'package:project_vehicle_log_app/data/model/remote/notification/get_notification_request_model.dart';
import 'package:project_vehicle_log_app/data/model/remote/notification/get_notification_response_model_v2.dart';
import 'package:project_vehicle_log_app/data/repository/notification_repository.dart';
import 'package:project_vehicle_log_app/domain/entities/notification/notification_data_entity.dart';
import 'package:project_vehicle_log_app/presentation/enum/notification_action_enum.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
      if (event is GetNotificationAction) {
        if (event.type == NotificationActionEnum.refresh) {
          currentPage = 1;
          responseData.listData = [];
          listResponseData = [];
          _getNotificationAction(
            event.appNotificationRepository,
            event,
          );
        } else {
          if (currentPage <= responseData.totalPages!) {
            currentPage++;
            _getNotificationAction(
              event.appNotificationRepository,
              event,
            );
          } else {
            emit(
              NotificationSuccess(
                result: responseData,
                type: NotificationActionEnum.loadMore,
              ),
            );
          }
        }
      }
    });
  }

  GetNotificationPaginationEntity responseData = GetNotificationPaginationEntity();
  List<GetNotificationEntity>? listResponseData = [];
  int currentPage = 1;

  Future<void> _getNotificationAction(
    AppNotificationRepository notificationRepository,
    GetNotificationAction event,
  ) async {
    emit(
      NotificationLoading(
        type: event.type,
      ),
    );
    // await Future.delayed(const Duration(milliseconds: 200));
    try {
      String? userToken = await AccountLocalRepository().getUserToken();
      if (userToken == null) {
        emit(
          NotificationFailed(errorMessage: "Failed To Get Support Data"),
        );
        return;
      }

      GetNotificationRequestModel dataReq = event.requestData;
      dataReq.currentPage = currentPage;

      GetNotificationResponseModelV2? output = await notificationRepository.getNotificationV2(
        reqData: dataReq,
        token: userToken,
      );
      if (output == null) {
        emit(
          NotificationFailed(
            errorMessage: "Failed edit profile",
          ),
        );
        return;
      }

      if (output.status != 200) {
        emit(
          NotificationFailed(
            errorMessage: output.message!,
          ),
        );
        return;
      }

      if (output.data != null) {
        responseData = output.toGetNotificationEntity()!;
        listResponseData?.addAll(output.toGetNotificationEntity()!.listData!);
        responseData.listData = listResponseData;
        emit(
          NotificationSuccess(
            result: responseData,
            type: event.type,
          ),
        );
      }
    } catch (errorMessage) {
      emit(
        NotificationFailed(
          errorMessage: errorMessage.toString(),
        ),
      );
    }
  }
}
