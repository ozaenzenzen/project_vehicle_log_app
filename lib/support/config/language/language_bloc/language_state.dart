part of 'language_bloc.dart';

abstract class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguageFailed extends LanguageState {
  final String errorMessage;
  LanguageFailed({required this.errorMessage});
}

class LanguageSuccess extends LanguageState {
  final Language language;
  LanguageSuccess({required this.language});
}
