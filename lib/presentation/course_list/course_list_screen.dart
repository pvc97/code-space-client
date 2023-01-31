import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/material.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            onTap: () {},
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
