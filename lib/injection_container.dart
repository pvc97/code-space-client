import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:code_space_client/data/local/local_storage_manager_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<LocalStorageManager>(
    () => LocalStorageManagerImpl(sharedPreferences: sharedPreferences),
  );
}
