import 'package:code_space_client/configs/environment_type.dart';

class EnvConfigManager {
  final EnvironmentType environmentType;
  final String baseUrl;

  EnvConfigManager._(this.environmentType, this.baseUrl);

  static EnvConfigManager? _instance;

  static EnvConfigManager get instance {
    if (_instance == null) {
      throw Exception('EnvConfigManager is not initialized');
    }
    return _instance!;
  }

  static void init({
    required EnvironmentType environmentType,
    required String baseUrl,
  }) {
    _instance = EnvConfigManager._(environmentType, baseUrl);
  }
}
