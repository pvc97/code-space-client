import 'dart:convert';

import 'package:code_space_client/constants/spref_key.dart';
import 'package:code_space_client/constants/url_constants.dart';
import 'package:code_space_client/models/token_model.dart';
import 'package:dio/dio.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/data/data_provider/local/local_storage_manager.dart';

class ApiProvider {
  final Dio dio;
  final LocalStorageManager localStorage;

  ApiProvider({
    required this.dio,
    required this.localStorage,
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

    await loadHeader();
  }

  set accessToken(String accessToken) {
    dio.options.headers["Authorization"] = 'Bearer $accessToken';
  }

  String get accessToken => dio.options.headers["Authorization"] ?? '';

  Future<void> loadHeader() async {
    final String? tokenModelStr =
        await localStorage.read<String>(SPrefKey.tokenModel);
    if (tokenModelStr != null && tokenModelStr.isNotEmpty) {
      final tokenModel = TokenModel.fromJson(jsonDecode(tokenModelStr));
      dio.options.headers["Authorization"] = 'Bearer ${tokenModel.accessToken}';
    }
  }

  Future<Response?> post(
    String path, {
    dynamic params,
    Options? options,
  }) async {
    final response = await dio.post(
      '${UrlConstants.api}$path',
      data: params,
      options: options,
    );
    return response;
  }

  Future<Response?> get(
    String path, {
    dynamic params,
    Options? options,
  }) async {
    final response = await dio.get(
      '${UrlConstants.api}$path',
      queryParameters: params,
      options: options,
    );
    return response;
  }

  Future<Response?> put(
    String path, {
    dynamic params,
    Options? options,
  }) async {
    final response = await dio.put(
      '${UrlConstants.api}$path',
      data: params,
      options: options,
    );
    return response;
  }

  Future<Response?> patch(
    String path, {
    dynamic params,
    Options? options,
  }) async {
    final response = await dio.patch(
      '${UrlConstants.api}$path',
      data: params,
      options: options,
    );
    return response;
  }
}
