part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class GetNotificationAction extends NotificationEvent {
  final GetNotificationRequestModel requestData;
  final NotificationActionEnum type;

  GetNotificationAction({
    required this.requestData,
    this.type = NotificationActionEnum.refresh,
  });
}
