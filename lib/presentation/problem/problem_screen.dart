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

class _ProblemScreenState extends State<ProblemScreen> {
  final _codeController = CodeController();

  @override
  void dispose() {
    _codeController.dispose();
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
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
        ],
      ),
      body: CodeField(
        controller: _codeController,
        expands: true,
      ),
    );
  }
}
