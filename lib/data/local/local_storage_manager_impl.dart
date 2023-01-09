import 'dart:async';

import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManagerImpl extends LocalStorageManager {
  final SharedPreferences sharedPreferences;

  LocalStorageManagerImpl({
    required this.sharedPreferences,
  });

  @override
  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    return sharedPreferences.setString(key, value);
  }

  @override
  bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

  @override
  int? getInt(String key) {
    return sharedPreferences.getInt(key);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return sharedPreferences.setInt(key, value);
  }

  @override
  double? getDouble(String key) {
    return sharedPreferences.getDouble(key);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    return sharedPreferences.setDouble(key, value);
  }

  @override
  FutureOr<List<String>?> getStringList(String key) {
    return sharedPreferences.getStringList(key);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    return sharedPreferences.setStringList(key, value);
  }

  @override
  Future<bool> remove(String key) {
    return sharedPreferences.remove(key);
  }

  @override
  Future<bool> clear() {
    return sharedPreferences.clear();
  }
}
