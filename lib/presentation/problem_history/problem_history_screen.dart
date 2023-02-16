import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/router/app_router.dart';

class ProblemHistoryScreen extends StatelessWidget {
  final String problemId;
  final String courseId;
  final bool me;

  const ProblemHistoryScreen({
    Key? key,
    required this.problemId,
    required this.courseId,
    required this.me,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        context: context,
        title: Text(S.of(context).problem_history),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(Sizes.s20),
        itemCount: 20,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                AppRoute.problemResult.name,
                params: {
                  'courseId': courseId,
                  'problemId': problemId,
                  'submitId': '123',
                },
                queryParams: me ? {'me': 'true'} : {},
              );
            },
            child: Card(
              child: ListTile(
                title: const Text('dd/MM/yyyy hh:mm:ss'),
                trailing: Text('${S.of(context).total_point} 100'),
              ),
            ),
          );
        },
      ),
    );
  }
}
