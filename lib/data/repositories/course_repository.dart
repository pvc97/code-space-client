import 'package:code_space_client/data/data_provider/services/course_service.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/problem_model.dart';
import 'package:code_space_client/utils/exception_parser.dart';

class CourseRepository {
  final CourseService courseService;

  CourseRepository({required this.courseService});

  Future<List<ProblemModel>> getProblems({
    required String courseId,
    required String query,
    required int page,
    required int limit,
  }) async {
    try {
      final problems = await courseService.getProblems(
        courseId: courseId,
        query: query,
        page: page,
        limit: limit,
      );
      // await Future.delayed(const Duration(seconds: 1));

      return problems;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<List<CourseModel>> getCourses({
    required String query,
    required int page,
    required int limit,
  }) async {
    try {
      final courses = await courseService.getCourses(
        query: query,
        page: page,
        limit: limit,
      );

      return courses;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<CourseModel> getCourse({required String courseId}) async {
    try {
      final course = await courseService.getCourse(courseId: courseId);

      return course;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  Future<bool> joinCourse(
      {required String courseId, required String accessCode}) async {
    try {
      final response = await courseService.joinCourse(
          courseId: courseId, accessCode: accessCode);

      return response;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
