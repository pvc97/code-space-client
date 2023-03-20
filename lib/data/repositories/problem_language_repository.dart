import 'package:code_space_client/data/data_provider/services/problem_language_service.dart';
import 'package:code_space_client/models/language_model.dart';
import 'package:code_space_client/utils/exception_parser.dart';

abstract class ProblemLanguageRepository {
  Future<List<LanguageModel>> getLanguages();
}

class ProblemLanguageRepositoryImpl implements ProblemLanguageRepository {
  final ProblemLanguageService problemLanguageService;

  ProblemLanguageRepositoryImpl({
    required this.problemLanguageService,
  });

  @override
  Future<List<LanguageModel>> getLanguages() async {
    try {
      final languages = await problemLanguageService.getLanguages();
      return languages;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
