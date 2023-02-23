import 'package:code_space_client/data/data_provider/services/problem_service.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/models/test_case_model.dart';
import 'package:code_space_client/utils/exception_parser.dart';
import 'package:dio/dio.dart';

class ProblemRepository {
  final ProblemService problemService;

  ProblemRepository({required this.problemService});

  Future<ProblemDetailModel> getProblemDetail(String problemId) async {
    try {
      final problemDetail = await problemService.getProblemDetail(problemId);

      return problemDetail;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<String> createProblem({
    required String name,
    required int pointPerTestCase,
    required String courseId,
    required int languageId,
    required Iterable<TestCaseModel> testCases,
    required MultipartFile file,
  }) async {
    try {
      final problemId = await problemService.createProblem(
        name: name,
        pointPerTestCase: pointPerTestCase,
        courseId: courseId,
        languageId: languageId,
        testCases: testCases,
        file: file,
      );

      return problemId;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
