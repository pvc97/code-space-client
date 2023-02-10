import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/data/repositories/submission_repository.dart';
import 'package:code_space_client/models/app_exception.dart';

part 'problem_state.dart';

class ProblemCubit extends Cubit<ProblemState> {
  final SubmissionRepository submissionRepository;

  ProblemCubit({
    required this.submissionRepository,
  }) : super(ProblemState.initial());

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
