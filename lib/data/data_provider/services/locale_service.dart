import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';
import 'package:code_space_client/models/languages.dart';

class LocaleService {
  final LocalStorageManager localStorage;

  LocaleService({required this.localStorage});

  Future<bool> saveLocaleLanguage(Languages language) {
    return localStorage.write<Languages>(SPrefKey.localeLanguage, language);
  }

  Future<Languages> getLocaleLanguage() async {
    final Languages language = (await localStorage.read<Languages>(
      SPrefKey.localeLanguage,
      defaultValue: Languages.vietnamese,
    ))!;

    return language;
  }
}
