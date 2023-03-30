import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/blocs/create_course/create_course_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/dropdown_item.dart';
import 'package:code_space_client/models/teacher_model.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/search_dropdown_button.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
        BlocListener<CreateCourseCubit, CreateCourseState>(
          listenWhen: (previous, current) =>
              previous.stateStatus != current.stateStatus,
          listener: stateStatusListener,
        ),
        BlocListener<CreateCourseCubit, CreateCourseState>(
          listenWhen: (previous, current) =>
              previous.createCourseStatus != current.createCourseStatus,
          listener: (ctx, state) {
            stateStatusListener(
              ctx,
              state,
              onSuccess: () {
                EasyLoading.showInfo(
                  S.of(context).course_created_successfully,
                  dismissOnTap: true,
                );
              },
            );
          },
        ),
      ],
      child: BaseScaffold(
        unfocusOnTap: true,
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
                  BlocSelector<CreateCourseCubit, CreateCourseState,
                      StateStatus>(
                    selector: (state) => state.stateStatus,
                    builder: (context, status) {
                      return AppElevatedButton(
                        onPressed:
                            status == StateStatus.loading ? null : _submit,
                        text: S.of(context).create,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
