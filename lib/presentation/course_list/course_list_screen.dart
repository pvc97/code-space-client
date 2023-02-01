import 'package:code_space_client/presentation/widgets/adaptive_app_bar.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/router/app_router.dart';

class CourseListScreen extends StatefulWidget {
  final bool me;

  const CourseListScreen({
    Key? key,
    this.me = false,
  }) : super(key: key);

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  @override
  void initState() {
    super.initState();
    logger.d('onlyMyCourses: ${widget.me}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        backgroundColor: widget.me ? Colors.green : Colors.pink,
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).search_course,
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: 20,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.goNamed(
                AppRoute.courseDetail.name,
                params: {'courseId': '$index'},
                queryParams: widget.me ? {'me': 'true'} : {},
              );
            },
            child: Card(
              child: ListTile(
                title: Text('Course $index'),
              ),
            ),
          );
        },
      ),
    );
  }
}
