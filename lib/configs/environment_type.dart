enum EnvironmentType {
  dev,
  devWindowWeb,
  prod,
  prodWindowWeb,
}

extension EnvironmentTypeExtension on EnvironmentType {
  String get dotenvFilePath {
    return 'environments/$_dotenvFileName';
  }

  String get _dotenvFileName {
    switch (this) {
      case EnvironmentType.dev:
        return 'dev.env';
      case EnvironmentType.devWindowWeb:
        return 'dev_window_web.env';
      case EnvironmentType.prod:
        return 'prod.env';
      case EnvironmentType.prodWindowWeb:
        return 'prod_window_web.env';
    }
  }
}
