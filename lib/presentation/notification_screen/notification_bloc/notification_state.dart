part of 'notification_bloc.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  final NotificationActionEnum type;
  NotificationLoading({
    required this.type,
  });
}

class NotificationSuccess extends NotificationState {
  final GetNotificationPaginationEntity result;
  final NotificationActionEnum type;

  NotificationSuccess({
    required this.result,
    required this.type,
  });
}

class NotificationFailed extends NotificationState {
  final String errorMessage;
  NotificationFailed({
    required this.errorMessage,
  });
}
