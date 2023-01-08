enum EnvironmentType {
  dev,
  prod,
}

extension EnvironmentTypeExtension on EnvironmentType {
  String get dotenvFilePath {
    return 'environments/$_dotenvFileName';
  }

  String get _dotenvFileName {
    switch (this) {
      case EnvironmentType.dev:
        return 'dev.env';
      case EnvironmentType.prod:
        return 'prod.env';
    }
  }
}
