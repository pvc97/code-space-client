import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:code_space_client/blocs/create_problem/create_problem_cubit.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/dropdown_item.dart';
import 'package:code_space_client/models/language_model.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/search_dropdown_button.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';

class CreateProblemView extends StatefulWidget {
  final String courseId;
  final bool me;

  const CreateProblemView({
    Key? key,
    required this.courseId,
    required this.me,
  }) : super(key: key);

  @override
  State<CreateProblemView> createState() => _CreateProblemViewState();
}

class _CreateProblemViewState extends State<CreateProblemView> {
  final _searchLanguageController = TextEditingController();
  BaseDropdownItem? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateProblemCubit>().getLanguages();
    });
  }

  @override
  void dispose() {
    _searchLanguageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        const BlocListener<CreateProblemCubit, CreateProblemState>(
          listener: stateStatusListener,
        ),
        BlocListener<CreateProblemCubit, CreateProblemState>(
          listenWhen: (previous, current) =>
              previous.problemId != current.problemId,
          listener: (context, state) {
            final problemId = state.problemId;
            if (problemId != null) {
              context.goNamed(
                AppRoute.problem.name,
                params: {
                  'courseId': widget.courseId,
                  'problemId': problemId,
                },
                queryParams: widget.me ? {'me': 'true'} : {},
              );
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AdaptiveAppBar(
            context: context,
            title: Text(S.of(context).create_new_problem),
          ),
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(Sizes.s20),
              width: Sizes.s300,
              child: Column(
                children: [
                  BlocSelector<CreateProblemCubit, CreateProblemState,
                      Iterable<LanguageModel>>(
                    selector: (state) => state.languages,
                    builder: (context, teachers) {
                      return SearchDropdownButton(
                        items: teachers,
                        hint: S.of(context).select_languages,
                        searchHint: S.of(context).enter_name_of_language,
                        textEditingController: _searchLanguageController,
                        onChanged: (BaseDropdownItem? value) {
                          _selectedLanguage = value;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
