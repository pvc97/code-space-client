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
