// ignore_for_file: library_prefixes

import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/configs/env_config_manager.dart';
import 'package:code_space_client/constants/app_constants.dart';
import 'package:code_space_client/models/problem_detail_model.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/problem/widgets/code_tab.dart';
import 'package:code_space_client/presentation/problem/widgets/pdf_tab.dart';
import 'package:code_space_client/presentation/problem/widgets/result_dialog/result_dialog.dart';
import 'package:code_space_client/presentation/problem/widgets/result_dialog/result_dialog_cubit.dart';
import 'package:code_space_client/utils/extensions/language_ext.dart';
import 'package:code_space_client/utils/extensions/user_model_ext.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:code_space_client/blocs/problem/problem_cubit.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:multi_split_view/multi_split_view.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

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

  late IO.Socket _socket;

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

    _initSocket();
  }

  void _initSocket() {
    _socket = IO.io(
      EnvConfigManager.instance.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableForceNew() // Have to enable this option to force creating a new connection after disconnect in dispose
          .build(),
    );

    _socket.onConnect((_) {
      logger.d('Socket connected');
    });

    _socket.onDisconnect((_) => logger.d('Socket disconnected'));

    _socket.on('result', (data) {
      context.read<ResultDialogCubit>().addResult(data);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserCubit cubit) => cubit.state.user);

    final screenWidth = MediaQuery.of(context).size.width;

    return MultiBlocListener(
      listeners: [
        // Listen to state status of ProblemCubit to show loading, error, success
        BlocListener<ProblemCubit, ProblemState>(
          listenWhen: (previous, current) =>
              previous.stateStatus != current.stateStatus,
          listener: stateStatusListener,
        ),
        // Listen to problem detail to set language for code controller
        BlocListener<ProblemCubit, ProblemState>(
          listenWhen: (previous, current) =>
              previous.problemDetail != current.problemDetail &&
              current.problemDetail != null,
          listener: (context, state) {
            final problemDetail = state.problemDetail;
            _codeController.language ??= problemDetail!.language.highlight;

            context
                .read<ResultDialogCubit>()
                .setTotalTestCases(problemDetail!.numberOfTestCases);
          },
        ),
        // Listen to submission id to navigate to result page
        BlocListener<ProblemCubit, ProblemState>(
          listenWhen: (previous, current) =>
              previous.submissionId != current.submissionId &&
              current.submissionId != null,
          listener: (context, state) {
            context.read<ResultDialogCubit>().clearResults();
            showResultDialog(
                ctx: context,
                onDetailPressed: () {
                  context.goNamed(
                    AppRoute.problemResult.name,
                    params: {
                      'courseId': widget.courseId,
                      'problemId': widget.problemId,
                      'submitId': state.submissionId!,
                    },
                    queryParams: widget.me ? {'me': 'true'} : {},
                  );
                });

            _socket.emit('submissionId', state.submissionId!);
          },
        ),
      ],
      child: BaseScaffold(
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
            bool isManager = user.isManager;
            if (constraints.maxWidth <= AppConstants.maxMobileWidth ||
                isManager) {
              return PageView(
                physics: isManager
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
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
        // Only show this button when current the tab is code or width > AppConstants.maxMobileWidth
        floatingActionButton: (user.isManager)
            ? null
            : BlocSelector<ProblemCubit, ProblemState, ProblemTab>(
                selector: (ProblemState state) => state.problemTab,
                builder: (context, state) {
                  if (state == ProblemTab.code ||
                      screenWidth > AppConstants.maxMobileWidth) {
                    return FloatingActionButton(
                      onPressed: () {
                        final sourceCode = _codeController.text;
                        final problemId = widget.problemId;

                        context.read<ProblemCubit>().submitCode(
                            sourceCode: sourceCode, problemId: problemId);
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
