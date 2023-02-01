import 'package:flutter/material.dart';

class ProblemScreen extends StatelessWidget {
  final String problemId;
  final String courseId;

  const ProblemScreen({
    Key? key,
    required this.problemId,
    required this.courseId,
  }) : super(key: key);

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
    );
  }
}
