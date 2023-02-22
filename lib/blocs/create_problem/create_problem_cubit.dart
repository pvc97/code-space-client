import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/data/repositories/language_repository.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/language_model.dart';

part 'create_problem_state.dart';

class CreateProblemCubit extends Cubit<CreateProblemState> {
  final LanguageRepository languageRepository;
  CreateProblemCubit({
    required this.languageRepository,
  }) : super(CreateProblemState.initial());

  void getLanguages() async {
    try {
      emit(state.copyWith(stateStatus: StateStatus.loading));
      final languages = await languageRepository.getLanguages();
      emit(state.copyWith(
        languages: languages,
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
