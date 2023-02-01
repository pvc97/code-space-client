import 'package:code_space_client/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter $courseId'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.foggy),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: 20,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.goNamed(AppRoute.problem.name, params: {
                'courseId': courseId,
                'problemId': '$index',
              });
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
