import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/constants/app_text_style.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/base_scaffold.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/extensions/role_type_ext.dart';
import 'package:code_space_client/utils/extensions/string_ext.dart';
import 'package:code_space_client/utils/state_status_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _fullName, _email;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Because this view contains some textfield, so I can not use BlocBuilder
      // to set initial value for textfield, so I set initial value with textcontroller
      final user = context.read<UserCubit>().state.user;
      if (user != null) {
        _fullNameController.text = user.name;
        _emailController.text = user.email;
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    final user = context.read<UserCubit>().state.user;
    if (user == null) {
      return;
    }

    context.read<UserCubit>().updateProfile(
          userId: user.userId,
          fullName: _fullName!,
          email: _email!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserCubit, UserState>(
          listenWhen: (previous, current) =>
              previous.stateStatus != current.stateStatus,
          listener: stateStatusListener,
        ),
        BlocListener<UserCubit, UserState>(
          listenWhen: (previous, current) =>
              previous.updateProfileState != current.updateProfileState,
          listener: (context, state) {
            stateStatusListener(
              context,
              state,
              stateStatus: state.updateProfileState,
              onSuccess: () {
                EasyLoading.showSuccess(
                  S.of(context).profile_updated,
                  dismissOnTap: true,
                );
              },
            );
          },
        ),
        BlocListener<UserCubit, UserState>(
          listenWhen: (previous, current) =>
              (previous.stateStatus != current.stateStatus &&
                  current.stateStatus != StateStatus.loading) ||
              (previous.updateProfileState != current.updateProfileState &&
                  current.updateProfileState != StateStatus.loading),
          listener: (context, state) {
            // https://dart.dev/guides/language/effective-dart/usage#consider-assigning-a-nullable-field-to-a-local-variable-to-enable-type-promotion
            final user = state.user;
            if (user != null) {
              // If success, update textfield value
              // If fail, reset textfield value to user's current value
              if (_fullNameController.text != user.name) {
                _fullNameController.text = user.name;
              }

              if (_emailController.text != user.email) {
                _emailController.text = user.email;
              }
            }
          },
        ),
      ],
      child: BaseScaffold(
        unfocusOnTap: true,
        appBar: AdaptiveAppBar(
          context: context,
          title: Text(S.of(context).profile),
          showHomeButton: false,
          actions: [
            IconButton(
              onPressed: () {
                context.goNamed(AppRoute.settings.name);
              },
              icon: const Icon(Bootstrap.gear),
            )
          ],
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Box(
              width: 300.0,
              child: ListView(
                shrinkWrap: true,
                children: [
                  BlocSelector<UserCubit, UserState, UserModel?>(
                    selector: (state) {
                      return state.user;
                    },
                    builder: (context, user) {
                      if (user == null) {
                        return const SizedBox.shrink();
                      }
                      return CircleAvatar(
                        radius: Sizes.s64,
                        backgroundColor: Colors.pink[200],
                        child: Image.asset(user.roleType.imagePath),
                      );
                    },
                  ),
                  Box.h24,
                  BlocSelector<UserCubit, UserState, UserModel?>(
                    selector: (state) {
                      return state.user;
                    },
                    builder: (context, user) {
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${S.of(context).role}: ${user?.roleType.getName(context) ?? ''}",
                          style: AppTextStyle.textStyle20,
                        ),
                      );
                    },
                  ),
                  Box.h24,
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).full_name,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).full_name_cannot_be_empty;
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _fullName = value;
                    },
                  ),
                  Box.h12,
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).email,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).email_cannot_be_empty;
                      }

                      if (!value.isValidEmail()) {
                        return S.of(context).username_only_alphanumeric;
                      }

                      return null;
                    },
                    onSaved: (String? value) {
                      _email = value;
                    },
                  ),
                  Box.h16,
                  BlocSelector<UserCubit, UserState, StateStatus>(
                    selector: (state) => state.stateStatus,
                    builder: (context, status) {
                      return AppElevatedButton(
                        onPressed: _submit,
                        text: S.of(context).update,
                      );
                    },
                  ),
                  Box.h24,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.goNamed(AppRoute.changePassword.name);
                      },
                      child: Text(S.of(context).change_password),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
