import 'package:code_space_client/data/data_provider/services/course_service.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/problem_model.dart';
import 'package:code_space_client/models/ranking_model.dart';
import 'package:code_space_client/utils/exception_parser.dart';

abstract class CourseRepository {
  Future<List<ProblemModel>> getProblems({
    required String courseId,
    required String query,
    required int page,
    required int limit,
  });

  Future<List<CourseModel>> getCourses({
    required String query,
    required int page,
    required int limit,
    required bool me,
  });

  Future<CourseModel> getCourse({required String courseId});

  Future<bool> joinCourse({
    required String courseId,
    required String accessCode,
  });

  Future<bool> leaveCourse({
    required String courseId,
  });

  Future<String> createCourse({
    required String name,
    required String code,
    required String accessCode,
    required String teacherId,
  });

  Future<List<RankingModel>> getRankings({
    required String courseId,
    required int page,
    required int limit,
  });

  Future<bool> deleteCourse({required String courseId});

  Future<CourseModel> updateCourse({
    required String courseId,
    required String name,
    required String code,
    required String accessCode,
    required String teacherId,
  });
}

class CourseRepositoryImpl implements CourseRepository {
  final CourseService courseService;

  CourseRepositoryImpl({required this.courseService});

  @override
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

      return problems;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<List<CourseModel>> getCourses({
    required String query,
    required int page,
    required int limit,
    required bool me,
  }) async {
    try {
      final courses = await courseService.getCourses(
        query: query,
        page: page,
        limit: limit,
        me: me,
      );

      return courses;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<CourseModel> getCourse({required String courseId}) async {
    try {
      final course = await courseService.getCourse(courseId: courseId);

      return course;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> joinCourse({
    required String courseId,
    required String accessCode,
  }) async {
    try {
      final response = await courseService.joinCourse(
          courseId: courseId, accessCode: accessCode);
      return response;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> leaveCourse({
    required String courseId,
  }) async {
    try {
      final response = await courseService.leaveCourse(courseId: courseId);
      return response;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<String> createCourse({
    required String name,
    required String code,
    required String accessCode,
    required String teacherId,
  }) async {
    try {
      final response = await courseService.createCourse(
        name: name,
        code: code,
        accessCode: accessCode,
        teacherId: teacherId,
      );
      return response;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<List<RankingModel>> getRankings({
    required String courseId,
    required int page,
    required int limit,
  }) async {
    try {
      final rankings = await courseService.getRankings(
        courseId: courseId,
        page: page,
        limit: limit,
      );

      return rankings;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<bool> deleteCourse({
    required String courseId,
  }) async {
    try {
      final response = await courseService.deleteCourse(courseId: courseId);
      return response;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }

  @override
  Future<CourseModel> updateCourse({
    required String courseId,
    required String name,
    required String code,
    required String accessCode,
    required String teacherId,
  }) async {
    try {
      final course = await courseService.updateCourse(
        courseId: courseId,
        name: name,
        code: code,
        accessCode: accessCode,
        teacherId: teacherId,
      );

      return course;
    } catch (e) {
      throw ExceptionParser.parse(e);
    }
  }
}
