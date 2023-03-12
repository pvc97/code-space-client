import 'package:code_space_client/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:code_space_client/blocs/update_course/update_course_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/dropdown_item.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/presentation/common_widgets/search_dropdown_button.dart';
import 'package:code_space_client/utils/state_status_listener.dart';

class UpdateCourseView extends StatefulWidget {
  final String courseId;

  const UpdateCourseView({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  State<UpdateCourseView> createState() => _UpdateCourseViewState();
}

class _UpdateCourseViewState extends State<UpdateCourseView> {
  final TextEditingController _searchTeacherController =
      TextEditingController();
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _accessCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _courseName, _courseCode, _accessCode;
  BaseDropdownItem? _selectedTeacher;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<UpdateCourseCubit>();
      cubit.getCourse(courseId: widget.courseId);
      cubit.getTeachers();
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

    context.read<UpdateCourseCubit>().updateCourse(
          courseId: widget.courseId,
          name: _courseName!.trim(),
          code: _courseCode!.trim(),
          accessCode: _accessCode!.trim(),
          teacherId: _selectedTeacher!.id,
        );
  }

  @override
  void dispose() {
    _searchTeacherController.dispose();
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _accessCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        const BlocListener<UpdateCourseCubit, UpdateCourseState>(
          listener: stateStatusListener,
        ),
        BlocListener<UpdateCourseCubit, UpdateCourseState>(
          listenWhen: (previous, current) =>
              previous.course != current.course && current.course != null,
          listener: (context, state) {
            final newCourseName = state.course!.name;
            final newCourseCode = state.course!.code;
            final newAccessCode = state.course!.accessCode;

            if (newCourseName != _courseNameController.text) {
              _courseNameController.text = newCourseName;
            }

            if (newCourseCode != _courseCodeController.text) {
              _courseCodeController.text = newCourseCode;
            }

            if (newAccessCode != null &&
                newAccessCode != _accessCodeController.text) {
              _accessCodeController.text = newAccessCode;
            }

            if (state.course!.teacher != _selectedTeacher) {
              _selectedTeacher = state.course!.teacher;
            }
          },
        ),
        BlocListener<UpdateCourseCubit, UpdateCourseState>(
          listenWhen: (previous, current) =>
              previous.updateStatus != current.updateStatus,
          listener: (context, state) {
            stateStatusListener(
              context,
              state,
              stateStatus: state.updateStatus,
              onSuccess: () {
                EasyLoading.showSuccess(
                    S.of(context).update_course_successfully);
              },
            );
          },
        ),
      ],
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).update_course),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(Sizes.s20),
              child: SizedBox(
                width: Sizes.s600,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _courseNameController,
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
                      controller: _courseCodeController,
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
                      controller: _accessCodeController,
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
                    BlocBuilder<UpdateCourseCubit, UpdateCourseState>(
                      buildWhen: (previous, current) {
                        return previous.teachers != current.teachers ||
                            (previous.course != current.course &&
                                current.course != null);
                      },
                      builder: (context, state) {
                        final teachers = state.teachers;
                        return SearchDropdownButton(
                          initialValue: state.course?.teacher,
                          items: teachers,
                          hint: S.of(context).select_teacher,
                          searchHint:
                              S.of(context).enter_name_or_email_of_teacher,
                          textEditingController: _searchTeacherController,
                          onChanged: (BaseDropdownItem? value) {
                            _selectedTeacher = value;
                          },
                        );
                      },
                    ),
                    Box.h16,
                    BlocBuilder<UpdateCourseCubit, UpdateCourseState>(
                      buildWhen: (previous, current) {
                        return previous.isLoading != current.isLoading;
                      },
                      builder: (context, state) {
                        return FractionallySizedBox(
                          widthFactor: 0.7,
                          child: AppElevatedButton(
                            onPressed: state.isLoading ? null : _submit,
                            text: S.of(context).update,
                          ),
                        );
                      },
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
