enum AppLanguages {
  vietnamese,
  english,
}

extension AppLanguagesExtension on AppLanguages {
  String get code {
    switch (this) {
      case AppLanguages.vietnamese:
        return 'vi';
      case AppLanguages.english:
        return 'en';
    }
  }
}

extension AppLanguagesCodeExtension on String {
  AppLanguages get toLanguage {
    switch (this) {
      case 'vi':
        return AppLanguages.vietnamese;
      case 'en':
        return AppLanguages.english;
      default:
        return AppLanguages.vietnamese;
    }
  }
}
