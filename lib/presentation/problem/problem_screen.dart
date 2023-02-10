import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/cubits/problem/problem_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/router/app_router.dart';

class ProblemScreen extends StatefulWidget {
  final String problemId;
  final String courseId;
  final bool me;

  const ProblemScreen({
    Key? key,
    required this.problemId,
    required this.courseId,
    required this.me,
  }) : super(key: key);

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen>
    with TickerProviderStateMixin {
  static const tabLength = 2;

  late final CodeController _codeController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController();
    _tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProblemCubit>(
      create: (context) => sl(),
      child: Builder(builder: (context) {
        return BlocListener<ProblemCubit, ProblemState>(
          listener: (context, state) {
            stateStatusListener(
              context,
              state,
              onSuccess: () {
                context.goNamed(
                  AppRoute.problemResult.name,
                  params: {
                    'courseId': widget.courseId,
                    'problemId': widget.problemId,
                    'submitId': state.submissionId!,
                  },
                  queryParams: widget.me ? {'me': 'true'} : {},
                );
              },
            );
          },
          child: Scaffold(
            appBar: AdaptiveAppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      _tabController.animateTo(0);
                    },
                    child: Text(
                      '< ${S.of(context).problem_tab}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.s20,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _tabController.animateTo(1);
                    },
                    child: Text(
                      '${S.of(context).code_tab} >',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.s20,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    context.goNamed(
                      AppRoute.problemHistory.name,
                      params: {
                        'courseId': widget.courseId,
                        'problemId': widget.problemId,
                      },
                      queryParams: widget.me ? {'me': 'true'} : {},
                    );
                  },
                ),
              ],
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                const Center(
                  child: Text("It's sunny here"),
                ),
                CodeField(
                  controller: _codeController,
                  expands: true,
                ),
              ],
            ),
            // TODO: Only show this button when current the tab is code
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final sourceCode = _codeController.text;
                // final problemId = widget.problemId;
                const problemId = '2f7d93c3-5943-4516-a05d-22bd1c0ec0fc';

                context
                    .read<ProblemCubit>()
                    .submitCode(sourceCode: sourceCode, problemId: problemId);
              },
              child: const Icon(Icons.play_arrow),
            ),
          ),
        );
      }),
    );
  }
}
