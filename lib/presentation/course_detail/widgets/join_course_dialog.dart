import 'dart:io';

import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showJoinCourseDialog(BuildContext ctx, String courseId) {
  // This context is different from the context in the below showDialog function
  // => Have to find CourseDetailBloc here
  final CourseDetailBloc bloc = ctx.read<CourseDetailBloc>();
  String accessCode = '';

  if (Platform.isIOS || Platform.isWindows) {
    showCupertinoDialog(
        context: ctx,
        barrierDismissible: true,
        builder: (context) {
          return BlocListener<CourseDetailBloc, CourseDetailState>(
            bloc: bloc,
            listenWhen: (previous, current) =>
                previous.joinedCourse != current.joinedCourse,
            listener: (context, state) {
              if (state.joinedCourse == true) {
                bloc.add(CourseDetailGetInitProblemsEvent(courseId: courseId));
                Navigator.pop(context);
              }
            },
            child: CupertinoAlertDialog(
              title: Text(S.of(context).enter_access_code),
              content: Padding(
                padding: const EdgeInsets.only(top: Sizes.s12),
                child: CupertinoTextField(
                  placeholder: S.of(context).access_code,
                  onChanged: (value) {
                    accessCode = value.trim();
                  },
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text(S.of(context).cancel),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    bloc.add(CourseDetailJoinCourseEvent(
                      courseId: courseId,
                      accessCode: accessCode,
                    ));
                  },
                  child: Text(S.of(context).ok),
                ),
              ],
            ),
          );
        });
  } else {
    showDialog(
      context: ctx,
      builder: (context) {
        return BlocListener<CourseDetailBloc, CourseDetailState>(
          bloc: bloc,
          listenWhen: (previous, current) =>
              previous.joinedCourse != current.joinedCourse,
          listener: (context, state) {
            if (state.joinedCourse == true) {
              bloc.add(CourseDetailGetInitProblemsEvent(courseId: courseId));
              Navigator.pop(context);
            }
          },
          child: AlertDialog(
            title: Text(S.of(context).enter_access_code),
            content: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: S.of(context).access_code,
              ),
              onChanged: (value) {
                accessCode = value.trim();
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () {
                  bloc.add(CourseDetailJoinCourseEvent(
                    courseId: courseId,
                    accessCode: accessCode,
                  ));
                },
                child: Text(S.of(context).ok),
              ),
            ],
          ),
        );
      },
    );
  }
}
