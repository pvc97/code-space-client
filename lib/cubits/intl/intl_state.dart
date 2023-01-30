part of 'intl_cubit.dart';

class IntlState extends Equatable {
  final Locale locale;

  const IntlState({
    required this.locale,
  });

  factory IntlState.initial() {
    return IntlState(
        locale: Locale.fromSubtags(languageCode: Languages.english.code));
  }

  @override
  List<Object> get props => [locale];

  IntlState copyWith({
    Locale? locale,
  }) {
    return IntlState(
      locale: locale ?? this.locale,
    );
  }
}
