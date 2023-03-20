import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/submission_model.dart';

abstract class SubmissionService {
  Future<String> submitCode({
    required String sourceCode,
    required String problemId,
  });

  Future<SubmissionModel> getSubmission(String submissionId);
}

class SubmissionServiceImpl implements SubmissionService {
  final ApiProvider apiProvider;

  SubmissionServiceImpl({required this.apiProvider});

  @override
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

  @override
  Future<SubmissionModel> getSubmission(String submissionId) async {
    final response = await apiProvider.get(
      '${UrlConstants.submissions}/$submissionId',
    );
    return SubmissionModel.fromJson(response?.data['data']);
  }
}
