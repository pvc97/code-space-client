import 'package:code_space_client/data/data_provider/services/problem_service.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/models/problem_model.dart';
import 'package:code_space_client/models/test_case_model.dart';
import 'package:code_space_client/utils/exception_parser.dart';
import 'package:dio/dio.dart';

abstract class ProblemRepository {
  Future<ProblemDetailModel> getProblemDetail(String problemId);

  Future<String> createProblem({
    required String name,
    required int pointPerTestCase,
    required String courseId,
    required int languageId,
    required Iterable<TestCaseModel> testCases,
    required MultipartFile file,
  });

  Future<bool> deleteProblem({required String problemId});

  Future<ProblemModel> updateProblem({
    required String problemId,
    required String courseId,
    String? name,
    int? pointPerTestCase,
    int? languageId,
    Iterable<TestCaseModel>? testCases,
    MultipartFile? file,
    bool pdfDeleteSubmission = false,
    // When update pdf file, I can choose delete all submission or not
  });
}

class ProblemRepositoryImpl implements ProblemRepository {
  final ProblemService problemService;

  ProblemRepositoryImpl({required this.problemService});

  @override
  Future<ProblemDetailModel> getProblemDetail(String problemId) async {
    try {
      final problemDetail = await problemService.getProblemDetail(problemId);

      return problemDetail;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
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

  /// Teacher delete problem
  @override
  Future<bool> deleteProblem({required String problemId}) async {
    try {
      final success = await problemService.deleteProblem(problemId: problemId);
      return success;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<ProblemModel> updateProblem({
    required String problemId,
    required String courseId,
    String? name,
    int? pointPerTestCase,
    int? languageId,
    Iterable<TestCaseModel>? testCases,
    MultipartFile? file,
    bool pdfDeleteSubmission = false,
  }) async {
    try {
      final problem = await problemService.updateProblem(
        problemId: problemId,
        courseId: courseId,
        name: name,
        pointPerTestCase: pointPerTestCase,
        languageId: languageId,
        testCases: testCases,
        file: file,
      );
      return problem;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
