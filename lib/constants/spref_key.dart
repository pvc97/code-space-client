class SPrefKey {
  // When adding key to SPrefKey, also add to keys
  SPrefKey._();

  static const String userModel = 'userModel';
  static const String tokenModel = 'tokenModel';
  static const String localeCode = 'localeCode';

  // List keys contains all keys
  static List<String> get keys => [userModel, tokenModel, localeCode];

  // ExceptKeys contains keys will not delete when logout
  static List<String> get exceptKeys => [localeCode];
}
