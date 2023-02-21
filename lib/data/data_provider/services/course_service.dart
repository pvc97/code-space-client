import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/problem_model.dart';

class CourseService {
  final ApiProvider apiProvider;

  CourseService({required this.apiProvider});

  Future<List<ProblemModel>> getProblems({
    required String courseId,
    required String query,
    required int page,
    required int limit,
  }) async {
    final response = await apiProvider.get(
      '${UrlConstants.courses}/$courseId/problems',
      queryParameters: {
        'page': page,
        'q': query,
        'limit': limit,
      },
    );
    return (response?.data['data'] as List)
        .map((e) => ProblemModel.fromJson(e))
        .toList();
  }

  Future<List<CourseModel>> getCourses({
    required String query,
    required int page,
    required int limit,
  }) async {
    final response = await apiProvider.get(
      UrlConstants.courses,
      queryParameters: {
        'page': page,
        'q': query,
        'limit': limit,
      },
    );
    return (response?.data['data'] as List)
        .map((e) => CourseModel.fromJson(e))
        .toList();
  }
}
