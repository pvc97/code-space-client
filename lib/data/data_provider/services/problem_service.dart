import 'dart:convert';
import 'package:code_space_client/constants/status_code_constants.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
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
}
