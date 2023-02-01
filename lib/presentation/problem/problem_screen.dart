import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/presentation/widgets/adaptive_app_bar.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
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
                  fontSize: Sizes.p20,
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
                  fontSize: Sizes.p20,
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
          context.goNamed(
            AppRoute.problemResult.name,
            params: {
              'courseId': widget.courseId,
              'problemId': widget.problemId,
              'submitId': '123',
            },
            queryParams: widget.me ? {'me': 'true'} : {},
          );
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
