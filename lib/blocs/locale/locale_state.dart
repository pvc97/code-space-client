part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  final Locale locale;

  const LocaleState({
    required this.locale,
  });

  factory LocaleState.initial({Languages? initLanguage}) {
    if (initLanguage != null) {
      return LocaleState(
        locale: Locale.fromSubtags(languageCode: initLanguage.code),
      );
    }

    return LocaleState(
        locale: Locale.fromSubtags(languageCode: Languages.vietnamese.code));
  }

  @override
  List<Object> get props => [locale];

  LocaleState copyWith({
    Locale? locale,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }
}
