import 'dart:convert';

import 'package:code_space_client/models/user_auth_model.dart';
import 'package:dio/dio.dart';

import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/data/local/local_storage_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiProvider {
  final Dio dio;
  final LocalStorageManager localStorageManager;

  ApiProvider({
    required this.dio,
    required this.localStorageManager,
  });

  Future<void> init({required String baseUrl}) async {
    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio.options = options;

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: false,
        ),
      );
    }

    await setAuthorizationHeader();
  }

  void setHeader({required String accessToken}) {
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    dio.options.headers = headers;
  }

  Future<void> setAuthorizationHeader() async {
    var headers = <String, dynamic>{};
    final String? userAuth =
        await localStorageManager.read<String>(NetworkConstants.userAuth);
    if (userAuth != null && userAuth.isNotEmpty) {
      final userAuthModel = UserAuthModel.fromJson(jsonDecode(userAuth));
      headers = {
        'Authorization': 'Bearer ${userAuthModel.accessToken}',
      };
    }
    dio.options.headers = headers;
  }

  Future<Response?> post(
    String path, {
    dynamic params,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        '${NetworkConstants.api}$path',
        data: params,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response?> get(
    String path, {
    dynamic params,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        '${NetworkConstants.api}$path',
        queryParameters: params,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response?> put(
    String path, {
    dynamic params,
    Options? options,
  }) async {
    try {
      final response = await dio.put(
        '${NetworkConstants.api}$path',
        data: params,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response?> patch(
    String path, {
    dynamic params,
    Options? options,
  }) async {
    try {
      final response = await dio.patch(
        '${NetworkConstants.api}$path',
        data: params,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
