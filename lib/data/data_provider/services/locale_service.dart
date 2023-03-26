import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/languages.dart';

abstract class LocaleService {
  Future<bool> saveLocaleCode(String code);
  Future<String> getLocaleCode();
}

class LocaleServiceImpl implements LocaleService {
  final LocalStorageManager localStorage;
  final ApiProvider apiProvider;

  LocaleServiceImpl({
    required this.localStorage,
    required this.apiProvider,
  });

  @override
  Future<bool> saveLocaleCode(String code) {
    apiProvider.setLocale(code);
    return localStorage.write<String>(SPrefKey.localeCode, code);
  }

  @override
  Future<String> getLocaleCode() async {
    final String code =
        (await localStorage.read<String>(SPrefKey.localeCode)) ??
            AppLanguages.vietnamese.code;
    apiProvider.setLocale(code);
    return code;
  }
}
