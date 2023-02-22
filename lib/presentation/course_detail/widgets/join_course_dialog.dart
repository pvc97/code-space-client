import 'dart:io';

import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void joinCourseDialog(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(S.of(context).enter_course_code),
            content: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: S.of(context).course_code,
              ),
              onChanged: (value) {},
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).enter_course_code),
          content: TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: S.of(context).course_code,
            ),
            onChanged: (value) {},
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
  }
}
