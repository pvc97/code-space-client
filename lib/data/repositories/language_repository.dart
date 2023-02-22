import 'package:code_space_client/data/data_provider/services/language_service.dart';
import 'package:code_space_client/models/language_model.dart';
import 'package:code_space_client/utils/exception_parser.dart';

class LanguageRepository {
  final LanguageService languageService;

  LanguageRepository({
    required this.languageService,
  });

  Future<List<LanguageModel>> getLanguages() async {
    try {
      final languages = await languageService.getLanguages();
      return languages;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
