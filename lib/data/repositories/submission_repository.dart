import 'package:code_space_client/data/data_provider/services/submission_service.dart';
import 'package:code_space_client/models/submission_model.dart';
import 'package:code_space_client/utils/exception_parser.dart';

abstract class SubmissionRepository {
  Future<String> submitCode({
    required String sourceCode,
    required String problemId,
  });

  Future<SubmissionModel> getSubmission(String submissionId);
}

class SubmissionRepositoryImpl implements SubmissionRepository {
  final SubmissionService submissionService;

  SubmissionRepositoryImpl({
    required this.submissionService,
  });

  @override
  Future<String> submitCode({
    required String sourceCode,
    required String problemId,
  }) async {
    try {
      final submisionId = await submissionService.submitCode(
        sourceCode: sourceCode,
        problemId: problemId,
      );

      return submisionId;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<SubmissionModel> getSubmission(String submissionId) async {
    try {
      final submission = await submissionService.getSubmission(submissionId);
      return submission;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
