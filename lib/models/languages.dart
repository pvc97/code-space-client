enum Languages {
  vietnamese,
  english,
}

extension LanguagesExtension on Languages {
  String get code {
    switch (this) {
      case Languages.vietnamese:
        return 'vi';
      case Languages.english:
        return 'en';
    }
  }
}

extension LanguagesCodeExtension on String {
  Languages get toLanguage {
    switch (this) {
      case 'vi':
        return Languages.vietnamese;
      case 'en':
        return Languages.english;
      default:
        return Languages.vietnamese;
    }
  }
}
