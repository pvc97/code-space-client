import 'package:flutter/material.dart';

import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';

class RankingScreen extends StatelessWidget {
  final bool me;
  final String courseId;

  const RankingScreen({
    Key? key,
    required this.me,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: Text(S.of(context).ranking),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(Sizes.s20),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Text('${index + 1}'),
              title: const Text('Pham Van Cuong'),
              subtitle: const Text('Score 100'),
            ),
          );
        },
      ),
    );
  }
}
