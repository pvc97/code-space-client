import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.floatingActionButton,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage("assets/images/cloud_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
