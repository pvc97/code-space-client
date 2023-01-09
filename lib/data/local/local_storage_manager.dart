import 'dart:async';

abstract class LocalStorageManager {
  // Use FutureOr to easily switch between shared_preferences and flutter_secure_storage
  FutureOr<String?> getString(String key);
  Future<bool> setString(String key, String value);

  FutureOr<bool?> getBool(String key);
  Future<bool> setBool(String key, bool value);

  FutureOr<int?> getInt(String key);
  Future<bool> setInt(String key, int value);

  FutureOr<double?> getDouble(String key);
  Future<bool> setDouble(String key, double value);

  FutureOr<List<String>?> getStringList(String key);
  Future<bool> setStringList(String key, List<String> value);

  Future<bool> remove(String key);
  Future<bool> clear();
}
