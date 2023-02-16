import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/presentation/problem/widgets/code_tab.dart';
import 'package:code_space_client/presentation/problem/widgets/pdf_tab.dart';
import 'package:code_space_client/utils/extensions/language_ext.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:code_space_client/cubits/problem/problem_cubit.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:multi_split_view/multi_split_view.dart';

class ProblemView extends StatefulWidget {
  final String problemId;
  final String courseId;
  final bool me;

  const ProblemView({
    Key? key,
    required this.problemId,
    required this.courseId,
    required this.me,
  }) : super(key: key);

  @override
  State<ProblemView> createState() => _ProblemViewState();
}

class _ProblemViewState extends State<ProblemView> {
  late final CodeController _codeController = CodeController();

  late final List<Widget> _pages = [
    const PdfTab(key: PageStorageKey('pdf')),
    CodeTab(
      key: const PageStorageKey('code'),
      codeController: _codeController,
    )
  ];

  @override
  void initState() {
    super.initState();

    // Have to call get problem detail after build
    // because initState is called before build
    // so in the first line of getProblemDetail emit loading state, this event
    // will not be listened, because in this time the BlocListener isn't attached to widget tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProblemCubit>().getProblemDetail(widget.problemId);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access user info without using BlocBuilder
    // final userCubit = context.read<UserCubit>();
    // logger.d(userCubit.state.user?.roleType);

    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<ProblemCubit, ProblemState>(
      listener: (context, state) {
        stateStatusListener(
          context,
          state,
          onSuccess: () {
            final problemDetail = state.problemDetail;
            if (problemDetail != null) {
              logger.d('Assign language: ${problemDetail.language.highlight}');
              _codeController.language ??= problemDetail.language.highlight;
            }

            if (state.submissionId != null) {
              context.goNamed(
                AppRoute.problemResult.name,
                params: {
                  'courseId': widget.courseId,
                  'problemId': widget.problemId,
                  'submitId': state.submissionId!,
                },
                queryParams: widget.me ? {'me': 'true'} : {},
              );
            }
          },
        );
      },
      child: Scaffold(
        appBar: AdaptiveAppBar(
          context: context,
          title: BlocSelector<ProblemCubit, ProblemState, ProblemDetailModel?>(
            selector: (ProblemState state) => state.problemDetail,
            builder: (context, state) {
              if (state == null) {
                return const SizedBox.shrink();
              }

              return Container(
                width: screenWidth * 0.5,
                alignment: Alignment.center,
                child: Text(state.name),
              );
            },
          ),
          centerTitle: true,
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return PageView(
                onPageChanged: (index) {
                  context.read<ProblemCubit>().changeTab(
                        ProblemTab.values.elementAt(index),
                      );
                },
                children: _pages,
              );
            }

            final multiSplitView = MultiSplitView(
              initialAreas: [
                Area(weight: 0.4),
              ],
              children: _pages,
            );

            return MultiSplitViewTheme(
              data: MultiSplitViewThemeData(
                dividerThickness: 12.0,
                dividerPainter: DividerPainters.grooved1(
                  // thickness: 8.0,
                  size: 30,
                  highlightedSize: 45,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              child: multiSplitView,
            );
          },
        ),
        // Only show this button when current the tab is code or width >= 600
        floatingActionButton:
            BlocSelector<ProblemCubit, ProblemState, ProblemTab>(
          selector: (ProblemState state) => state.problemTab,
          builder: (context, state) {
            if (state == ProblemTab.code || screenWidth >= 600) {
              return FloatingActionButton(
                onPressed: () {
                  final sourceCode = _codeController.text;
                  final problemId = widget.problemId;

                  context
                      .read<ProblemCubit>()
                      .submitCode(sourceCode: sourceCode, problemId: problemId);
                },
                child: const Icon(Icons.play_arrow),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
