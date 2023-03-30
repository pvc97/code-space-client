import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/course_model.dart';
import 'package:code_space_client/models/problem_model.dart';
import 'package:code_space_client/models/ranking_model.dart';

abstract class CourseService {
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

  Future<CourseModel> createCourse({
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

class CourseServiceImpl implements CourseService {
  final ApiProvider apiProvider;

  CourseServiceImpl({required this.apiProvider});

  @override
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

  @override
  Future<List<CourseModel>> getCourses({
    required String query,
    required int page,
    required int limit,
    required bool me,
  }) async {
    final response = await apiProvider.get(
      UrlConstants.courses,
      queryParameters: {
        'page': page,
        'q': query,
        'limit': limit,
        'me': me,
      },
    );
    return (response?.data['data'] as List)
        .map((e) => CourseModel.fromJson(e))
        .toList();
  }

  @override
  Future<CourseModel> getCourse({required String courseId}) async {
    final response = await apiProvider.get(
      '${UrlConstants.courses}/$courseId',
    );
    return CourseModel.fromJson(response?.data['data']);
  }

  @override
  Future<bool> joinCourse({
    required String courseId,
    required String accessCode,
  }) async {
    final response = await apiProvider.post(
      '${UrlConstants.courses}/$courseId/join',
      params: {
        'accessCode': accessCode,
      },
    );
    return response?.statusCode == 201;
  }

  @override
  Future<bool> leaveCourse({
    required String courseId,
  }) async {
    final response = await apiProvider.delete(
      '${UrlConstants.courses}/$courseId/leave',
    );
    return response?.statusCode == StatusCodeConstants.code204;
  }

  @override
  Future<CourseModel> createCourse({
    required String name,
    required String code,
    required String accessCode,
    required String teacherId,
  }) async {
    final response = await apiProvider.post(
      UrlConstants.courses,
      params: {
        'name': name,
        'code': code,
        'accessCode': accessCode,
        'teacherId': teacherId,
      },
    );
    return CourseModel.fromJson(response?.data['data']);
  }

  @override
  Future<List<RankingModel>> getRankings({
    required String courseId,
    required int page,
    required int limit,
  }) async {
    final response = await apiProvider.get(
      '${UrlConstants.courses}/$courseId/ranking',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return (response?.data['data'] as List)
        .map((e) => RankingModel.fromJson(e))
        .toList();
  }

  /// Manager delete course
  @override
  Future<bool> deleteCourse({required String courseId}) async {
    final response =
        await apiProvider.delete('${UrlConstants.courses}/$courseId');

    if (response?.statusCode == StatusCodeConstants.code200) {
      return true;
    }

    return false;
  }

  @override
  Future<CourseModel> updateCourse({
    required String courseId,
    required String name,
    required String code,
    required String accessCode,
    required String teacherId,
  }) async {
    final response = await apiProvider.put(
      '${UrlConstants.courses}/$courseId',
      params: {
        'name': name,
        'code': code,
        'accessCode': accessCode,
        'teacherId': teacherId,
      },
    );
    return CourseModel.fromJson(response?.data['data']);
  }
}
