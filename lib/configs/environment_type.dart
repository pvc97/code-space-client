enum EnvironmentType {
  dev,
  devLocal,
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
      case EnvironmentType.devLocal:
        return 'dev_local.env';
      case EnvironmentType.prod:
        return 'prod.env';
    }
  }
}
