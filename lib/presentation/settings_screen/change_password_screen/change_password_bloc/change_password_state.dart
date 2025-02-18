part of 'change_password_bloc.dart';

abstract class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordLoading extends ChangePasswordState {}

final class ChangePasswordSuccess extends ChangePasswordState {}

final class ChangePasswordFailed extends ChangePasswordState {
  final String errorMessage;
  ChangePasswordFailed({required this.errorMessage});
}
