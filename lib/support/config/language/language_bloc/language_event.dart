part of 'language_bloc.dart';

abstract class LanguageEvent {}

class ChangeLanguageAction extends LanguageEvent {
  final BuildContext context;
  final Language language;

  ChangeLanguageAction({
    required this.context,
    required this.language,
  });
}
