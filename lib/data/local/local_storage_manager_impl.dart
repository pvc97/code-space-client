import 'dart:async';

import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManagerImpl extends LocalStorageManager {
  final SharedPreferences sharedPreferences;

  LocalStorageManagerImpl({
    required this.sharedPreferences,
  });

  @override
  Future<T?> read<T>(String key, {T? defaultValue}) {
    // In dart: DO NOT use T is String
    // USE T == String instead or switch case
    switch (T) {
      case String:
        return Future<T?>.value(
            (sharedPreferences.getString(key) ?? defaultValue) as T?);
      case bool:
        return Future<T?>.value(
            (sharedPreferences.getBool(key) ?? defaultValue) as T?);

      case int:
        return Future<T?>.value(
            (sharedPreferences.getInt(key) ?? defaultValue) as T?);
      case double:
        return Future<T?>.value(
            (sharedPreferences.getDouble(key) ?? defaultValue) as T?);

      case List<String>:
        return Future<T?>.value(
            (sharedPreferences.getStringList(key) ?? defaultValue) as T?);

      default:
        return Future<T?>.value(defaultValue);
    }
  }

  @override
  Future<bool> write<T>(String key, T value) {
    switch (T) {
      case String:
        return sharedPreferences.setString(key, value as String);
      case bool:
        return sharedPreferences.setBool(key, value as bool);
      case int:
        return sharedPreferences.setInt(key, value as int);
      case double:
        return sharedPreferences.setDouble(key, value as double);
      case List<String>:
        return sharedPreferences.setStringList(key, value as List<String>);
      default:
        return Future<bool>.value(false);
    }
  }

  @override
  Future<bool> delete(String key) {
    return sharedPreferences.remove(key);
  }

  @override
  Future<bool> deleteAll() {
    return sharedPreferences.clear();
  }
}
