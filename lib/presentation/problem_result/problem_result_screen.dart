import 'package:code_space_client/constants/app_sizes.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/generated/l10n.dart';

class ProblemResultScreen extends StatelessWidget {
  final String submitId;

  const ProblemResultScreen({
    Key? key,
    required this.submitId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).problem_result),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${S.of(context).total_point}: 100',
              style: const TextStyle(
                fontSize: Sizes.p32,
              ),
            ),
            gapH8,
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Test $index'),
                      subtitle: const Text('Passed'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
