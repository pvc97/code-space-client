import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/language_model.dart';

abstract class LanguageService {
  Future<List<LanguageModel>> getLanguages();
}

class LanguageServiceImpl implements LanguageService {
  final ApiProvider apiProvider;

  LanguageServiceImpl({
    required this.apiProvider,
  });

  @override
  Future<List<LanguageModel>> getLanguages() async {
    final response = await apiProvider.get(
      UrlConstants.languages,
    );
    return (response?.data['data'] as List)
        .map((e) => LanguageModel.fromJson(e))
        .toList();
  }
}
