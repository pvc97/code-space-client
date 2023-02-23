import 'package:code_space_client/blocs/create_course/create_course_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/dropdown_item.dart';
import 'package:code_space_client/models/teacher_model.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/search_dropdown_button.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class CreateCourseView extends StatefulWidget {
  const CreateCourseView({super.key});

  @override
  State<CreateCourseView> createState() => CreateCourseViewState();
}

class CreateCourseViewState extends State<CreateCourseView> {
  final TextEditingController searchTeacherController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _courseName, _courseCode, _accessCode;
  BaseDropdownItem? _selectedTeacher;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateCourseCubit>().getTeachers();
    });
  }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    if (_selectedTeacher == null) {
      EasyLoading.showInfo(S.of(context).please_select_teacher,
          dismissOnTap: true);
      return;
    }

    context.read<CreateCourseCubit>().createCourse(
          name: _courseName!.trim(),
          code: _courseCode!.trim(),
          accessCode: _accessCode!.trim(),
          teacherId: _selectedTeacher!.id,
        );
  }

  @override
  void dispose() {
    searchTeacherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        const BlocListener<CreateCourseCubit, CreateCourseState>(
          listener: stateStatusListener,
        ),
        BlocListener<CreateCourseCubit, CreateCourseState>(
          listenWhen: (previous, current) =>
              previous.courseId != current.courseId,
          listener: (context, state) {
            final courseId = state.courseId;
            if (courseId != null) {
              context.pushNamed(
                AppRoute.courseDetail.name,
                params: {'courseId': courseId},
                queryParams: {'me': 'false'},
              );
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AdaptiveAppBar(
            context: context,
            title: Text(S.of(context).create_new_course),
          ),
          body: Center(
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).course_name,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).course_name_cannot_be_empty;
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _courseName = value;
                      },
                    ),
                    Box.h16,
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).course_code,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).course_code_cannot_be_empty;
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _courseCode = value;
                      },
                    ),
                    Box.h16,
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).access_code,
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).access_code_cannot_be_empty;
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _accessCode = value;
                      },
                    ),
                    Box.h16,
                    BlocSelector<CreateCourseCubit, CreateCourseState,
                        Iterable<TeacherModel>>(
                      selector: (state) => state.teachers,
                      builder: (context, teachers) {
                        return SearchDropdownButton(
                          items: teachers,
                          hint: S.of(context).select_teacher,
                          searchHint:
                              S.of(context).enter_name_or_email_of_teacher,
                          textEditingController: searchTeacherController,
                          onChanged: (BaseDropdownItem? value) {
                            _selectedTeacher = value;
                          },
                        );
                      },
                    ),
                    Box.h16,
                    AppElevatedButton(
                      onPressed: _submit,
                      text: S.of(context).create,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
