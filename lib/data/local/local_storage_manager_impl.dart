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
    if (T is String) {
      return Future<T?>.value(
          (sharedPreferences.getString(key) ?? defaultValue) as T?);
    } else if (T is bool) {
      return Future<T?>.value(
          (sharedPreferences.getBool(key) ?? defaultValue) as T?);
    } else if (T is int) {
      return Future<T?>.value(
          (sharedPreferences.getInt(key) ?? defaultValue) as T?);
    } else if (T is double) {
      return Future<T?>.value(
          (sharedPreferences.getDouble(key) ?? defaultValue) as T?);
    } else if (T is List<String>) {
      return Future<T?>.value(
          (sharedPreferences.getStringList(key) ?? defaultValue) as T?);
    } else {
      return Future<T?>.value(defaultValue);
    }
  }

  @override
  Future<bool> write<T>(String key, T value) {
    if (T is String) {
      return sharedPreferences.setString(key, value as String);
    } else if (T is bool) {
      return sharedPreferences.setBool(key, value as bool);
    } else if (T is int) {
      return sharedPreferences.setInt(key, value as int);
    } else if (T is double) {
      return sharedPreferences.setDouble(key, value as double);
    } else if (T is List<String>) {
      return sharedPreferences.setStringList(key, value as List<String>);
    } else {
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
