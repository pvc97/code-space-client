import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/data/repositories/problem_repository.dart';
import 'package:code_space_client/data/repositories/submission_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/utils/logger/logger.dart';

part 'problem_state.dart';

class ProblemCubit extends Cubit<ProblemState> {
  final SubmissionRepository submissionRepository;
  final ProblemRepository problemRepository;

  ProblemCubit({
    required this.submissionRepository,
    required this.problemRepository,
  }) : super(ProblemState.initial());

  Future<void> getProblemDetail(String problemId) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final problemDetail = await problemRepository.getProblemDetail(problemId);
      emit(state.copyWith(
        problemDetail: problemDetail,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          error: e,
          stateStatus: StateStatus.error,
        ),
      );
    }
  }

  Future<void> submitCode({
    required String sourceCode,
    required String problemId,
  }) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final submissionId = await submissionRepository.submitCode(
        sourceCode: sourceCode,
        problemId: problemId,
      );
      emit(state.copyWith(
        submissionId: submissionId,
        stateStatus: StateStatus.success,
      ));
    } on AppException catch (e) {
      emit(
        state.copyWith(
          error: e,
          stateStatus: StateStatus.error,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    logger.d('ProblemCubit closed');
    return super.close();
  }
}
