import 'package:code_space_client/data/data_provider/network/api_provider.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/models/problem_detail_model.dart';

extension ProblemDetailExt on ProblemDetailModel {
  String get fullPdfPath => '${sl<ApiProvider>().dio.options.baseUrl}/$pdfPath';
}
