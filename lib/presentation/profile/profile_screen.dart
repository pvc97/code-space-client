import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:code_space_client/blocs/user/user_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/role_type.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:code_space_client/presentation/common_widgets/app_elevated_button.dart';
import 'package:code_space_client/presentation/common_widgets/box.dart';
import 'package:code_space_client/router/app_router.dart';
import 'package:code_space_client/utils/logger/logger.dart';
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
  UserModel? _user;

  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;
  String? _fullName, _email;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getMe();
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

    // TODO: Handle sign up
    logger.d('$_fullName, $_email');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        _user = state.user;

        // https://dart.dev/guides/language/effective-dart/usage#consider-assigning-a-nullable-field-to-a-local-variable-to-enable-type-promotion
        final user = _user;
        if (user != null) {
          _fullNameController.text = user.name;
          _emailController.text = user.email;
        } else {
          // Handle case user clear user data
          EasyLoading.showInfo(S.of(context).session_expired);
          context.read<AuthCubit>().logout();
        }
      },
      child: Scaffold(
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
                  CircleAvatar(
                    radius: Sizes.s64,
                    backgroundColor: Colors.pink[200],
                    child: const FlutterLogo(size: Sizes.s64),
                  ),
                  Box.h24,
                  Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        return Text(
                          "${S.of(context).role}: ${_user?.roleType.getName(context) ?? ''}",
                          style: const TextStyle(
                            fontSize: Sizes.s20,
                          ),
                        );
                      },
                    ),
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
                      return null;
                    },
                    onSaved: (String? value) {
                      _email = value;
                    },
                  ),
                  Box.h12,
                  AppElevatedButton(
                    onPressed: _submit,
                    text: S.of(context).update,
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
