import 'package:code_space_client/models/submission_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_space_client/cubits/base/base_state.dart';
import 'package:code_space_client/data/repositories/submission_repository.dart';
import 'package:code_space_client/models/app_exception.dart';

part 'problem_result_state.dart';

class ProblemResultCubit extends Cubit<ProblemResultState> {
  final SubmissionRepository submissionRepository;

  ProblemResultCubit({
    required this.submissionRepository,
  }) : super(ProblemResultState.initial());

  void getSubmissionResult(String submissionId) async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final submission = await submissionRepository.getSubmission(submissionId);
      emit(state.copyWith(
        submission: submission,
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
}
