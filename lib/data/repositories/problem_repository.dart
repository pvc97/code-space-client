import 'package:code_space_client/data/data_provider/services/problem_service.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/utils/exception_parser.dart';

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
}
