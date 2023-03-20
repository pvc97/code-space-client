import 'package:code_space_client/data/data_provider/services/locale_service.dart';

abstract class LocaleRepository {
  Future<bool> saveLocaleCode(String code);
  Future<String> getLocaleCode();
}

class LocaleRepositoryImpl implements LocaleRepository {
  final LocaleService localeService;

  LocaleRepositoryImpl({
    required this.localeService,
  });

  @override
  Future<bool> saveLocaleCode(String code) async {
    return localeService.saveLocaleCode(code);
  }

  @override
  Future<String> getLocaleCode() async {
    return localeService.getLocaleCode();
  }
}
