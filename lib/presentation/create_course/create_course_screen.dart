import 'package:code_space_client/blocs/create_course/create_course_cubit.dart';
import 'package:code_space_client/injection_container.dart';
import 'package:code_space_client/presentation/create_course/create_course_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCourseScreen extends StatelessWidget {
  const CreateCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateCourseCubit>(
      create: (context) => sl(),
      child: const CreateCourseView(),
    );
  }
}
