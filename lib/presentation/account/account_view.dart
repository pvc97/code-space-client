import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/generated/l10n.dart';
import 'package:code_space_client/presentation/common_widgets/adaptive_app_bar.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => AccountViewState();
}

class AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        context: context,
        showHomeButton: false,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: Sizes.s20),
          child: TextField(
            decoration: InputDecoration(
              // border: InputBorder.none,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              enabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              hintText: S.of(context).search_accounts,
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              // Make textfield height smaller
              isDense: true,
              contentPadding: const EdgeInsets.all(Sizes.s8),
            ),
            onChanged: (value) {
              // _searchCourse(value);
            },
          ),
        ),
      ),
    );
  }
}
