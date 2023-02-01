import 'package:code_space_client/generated/l10n.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

class ProblemScreen extends StatefulWidget {
  final String problemId;
  final String courseId;

  const ProblemScreen({
    Key? key,
    required this.problemId,
    required this.courseId,
  }) : super(key: key);

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen>
    with TickerProviderStateMixin {
  late final CodeController _codeController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController();
    _tabController = TabController(length: 2, vsync: this);
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
      appBar: AppBar(
        title: const Text('Problem'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Text(S.of(context).problem_tab),
            ),
            Tab(
              icon: Text(S.of(context).code_tab),
            ),
          ],
        ),
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
        onPressed: () {},
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
