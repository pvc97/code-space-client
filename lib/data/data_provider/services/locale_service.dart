import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/languages.dart';

class LocaleService {
  final LocalStorageManager localStorage;
  final ApiProvider apiProvider;

  LocaleService({
    required this.localStorage,
    required this.apiProvider,
  });

  Future<bool> saveLocaleCode(String code) {
    apiProvider.setLocale(code);
    return localStorage.write<String>(SPrefKey.localeCode, code);
  }

  Future<String> getLocaleCode() async {
    final String code =
        (await localStorage.read<String>(SPrefKey.localeCode)) ??
            Languages.vietnamese.code;
    apiProvider.setLocale(code);
    return code;
  }
}
