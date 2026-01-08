import 'package:flutter/material.dart';

import 'responsive_appbar.dart';
import 'responsive_body.dart';

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool isScrollable;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.content,
    this.onBackPressed,
    this.actions,
    this.centerTitle = true,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = ResponsiveBody(child: content);
    if (isScrollable) {
      body = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: body,
      );
    }

    return Scaffold(
      appBar: ResponsiveAppBar(title: title, theme: Theme.of(context)),
      body: SafeArea(child: body),
    );
  }
}
