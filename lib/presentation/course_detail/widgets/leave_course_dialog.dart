import 'package:code_space_client/blocs/course_detail/course_detail_bloc.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showLeaveCourseDialog(BuildContext ctx, String courseId) {
  // This context is different from the context in the below showDialog function
  // => Have to find CourseDetailBloc here
  final CourseDetailBloc bloc = ctx.read<CourseDetailBloc>();

  return showDialog(
    context: ctx,
    builder: (context) {
      return BlocListener<CourseDetailBloc, CourseDetailState>(
        bloc: bloc,
        listenWhen: (previous, current) =>
            previous.joinedCourse != current.joinedCourse,
        listener: (context, state) {
          Navigator.pop(context);
        },
        child: AlertDialog(
          title: Text(S.of(context).confirm_leave_course),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                bloc.add(CourseDetailLeaveCourseEvent(courseId: courseId));
              },
              child: Text(S.of(context).ok),
            ),
          ],
        ),
      );
    },
  );
}
