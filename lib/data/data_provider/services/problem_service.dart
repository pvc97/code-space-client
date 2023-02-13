import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/problem_detail_model.dart';

class ProblemService {
  final ApiProvider apiProvider;

  ProblemService({required this.apiProvider});

  Future<ProblemDetailModel> getProblemDetail(String problemId) async {
    final response = await apiProvider.get(
      '${UrlConstants.problems}/$problemId',
    );
    return ProblemDetailModel.fromJson(response?.data['data']);
  }
}
