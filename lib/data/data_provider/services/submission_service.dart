import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/submission_model.dart';

class SubmissionService {
  final ApiProvider apiProvider;

  SubmissionService({required this.apiProvider});

  Future<String> submitCode({
    required String sourceCode,
    required String problemId,
  }) async {
    final response = await apiProvider.post(
      UrlConstants.submissions,
      params: {
        'sourceCode': sourceCode,
        'problemId': problemId,
      },
    );

    // Result submissionId
    return response?.data['data']['id'];
  }

  Future<SubmissionModel> getSubmission(String submissionId) async {
    final response = await apiProvider.get(
      '${UrlConstants.submissions}/$submissionId',
    );
    return SubmissionModel.fromJson(response?.data['data']);
  }
}
