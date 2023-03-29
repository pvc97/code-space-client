import 'dart:convert';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/models/problem_history_model.dart';
import 'package:code_space_client/models/problem_model.dart';
import 'package:code_space_client/models/test_case_model.dart';
import 'package:dio/dio.dart';

abstract class ProblemService {
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
    required bool pdfDeleteSubmission,
    String? name,
    int? pointPerTestCase,
    int? languageId,
    Iterable<TestCaseModel>? testCases,
    MultipartFile? file,
    // When update pdf file, I can choose delete all submission or not
  });

  Future<List<ProblemHistoryModel>> getProblemHistories({
    required String problemId,
    required int page,
    required int limit,
  });
}

class ProblemServiceImpl implements ProblemService {
  final ApiProvider apiProvider;

  ProblemServiceImpl({required this.apiProvider});

  @override
  Future<ProblemDetailModel> getProblemDetail(String problemId) async {
    final response = await apiProvider.get(
      '${UrlConstants.problems}/$problemId',
    );
    return ProblemDetailModel.fromJson(response?.data['data']);
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
    final formData = FormData.fromMap(
      {
        'name': name,
        'pointPerTestCase': pointPerTestCase,
        'courseId': courseId,
        'languageId': languageId,
        'testCases': jsonEncode(testCases.map((e) => e.toJson()).toList()),
        'pdfFile': file,
      },
    );

    final response = await apiProvider.post(
      UrlConstants.problems,
      params: formData,
    );
    return response?.data['data']['id'];
  }

  /// Teacher delete problem
  @override
  Future<bool> deleteProblem({required String problemId}) async {
    final response =
        await apiProvider.delete('${UrlConstants.problems}/$problemId');

    if (response?.statusCode == StatusCodeConstants.code200) {
      return true;
    }

    return false;
  }

  @override
  Future<ProblemModel> updateProblem({
    required String problemId,
    required String courseId,
    required bool pdfDeleteSubmission,
    String? name,
    int? pointPerTestCase,
    int? languageId,
    Iterable<TestCaseModel>? testCases,
    MultipartFile? file,
  }) async {
    final body = <String, dynamic>{
      'courseId': courseId,
    };

    if (name != null) {
      body['name'] = name;
    }

    if (pointPerTestCase != null) {
      body['pointPerTestCase'] = pointPerTestCase;
    }

    if (languageId != null) {
      body['languageId'] = languageId;
    }

    if (testCases != null) {
      body['testCases'] = jsonEncode(testCases.map((e) => e.toJson()).toList());
    }

    if (file != null) {
      body['pdfDeleteSubmission'] = pdfDeleteSubmission;
      body['pdfFile'] = file;
    }

    final formData = FormData.fromMap(body);

    final response = await apiProvider.put(
      '${UrlConstants.problems}/$problemId',
      params: formData,
    );
    return ProblemModel.fromJson(response?.data['data']);
  }

  @override
  Future<List<ProblemHistoryModel>> getProblemHistories({
    required String problemId,
    required int page,
    required int limit,
  }) async {
    final response = await apiProvider.get(
      '${UrlConstants.problems}/$problemId/history',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    return (response?.data['data'] as List)
        .map((e) => ProblemHistoryModel.fromJson(e))
        .toList();
  }
}
