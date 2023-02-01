import 'package:code_space_client/presentation/widgets/adaptive_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:code_space_client/router/app_router.dart';

class CourseDetailScreen extends StatelessWidget {
  final bool me;
  final String courseId;

  const CourseDetailScreen({
    Key? key,
    required this.me,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: Text('Flutter $courseId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.foggy),
            onPressed: () {
              context.goNamed(
                AppRoute.ranking.name,
                params: {
                  'courseId': courseId,
                },
                queryParams: me ? {'me': 'true'} : {},
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: 20,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.goNamed(
                AppRoute.problem.name,
                params: {
                  'courseId': courseId,
                  'problemId': '$index',
                },
                queryParams: me ? {'me': 'true'} : {},
              );
            },
            child: Card(
              child: ListTile(
                title: Text('Problem $index'),
              ),
            ),
          );
        },
      ),
    );
  }
}
