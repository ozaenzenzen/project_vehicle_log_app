part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class GetNotificationAction extends NotificationEvent {
  final AppNotificationRepository appNotificationRepository;
  final GetNotificationRequestModel requestData;
  final NotificationActionEnum type;

  GetNotificationAction({
    required this.appNotificationRepository,
    required this.requestData,
    this.type = NotificationActionEnum.refresh,
  });
}
