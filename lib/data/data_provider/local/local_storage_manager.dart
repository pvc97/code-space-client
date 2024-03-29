import 'dart:async';

abstract class LocalStorageManager {
  Future<T?> read<T>(String key);

  Future<bool> write<T>(String key, T value);

  Future<bool> delete(String key);

  Future<bool> deleteAll({List<String>? exceptKeys});
}
