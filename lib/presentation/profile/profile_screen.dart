import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/cubits/auth/auth_cubit.dart';
import 'package:code_space_client/cubits/user/user_cubit.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:code_space_client/presentation/widgets/adaptive_app_bar.dart';
import 'package:code_space_client/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
    context.read<UserCubit>().getUserInfo();
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
          title: Text(S.of(context).profile),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: SizedBox(
              width: 300.0,
              child: ListView(
                shrinkWrap: true,
                children: [
                  CircleAvatar(
                    radius: Sizes.p64,
                    backgroundColor: Colors.pink[200],
                    child: const FlutterLogo(size: Sizes.p64),
                  ),
                  gapH24,
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
                  gapH12,
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
                  gapH12,
                  ElevatedButton(
                    onPressed: _submit,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                      child: Text(S.of(context).update),
                    ),
                  ),
                  gapH24,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
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
