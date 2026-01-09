import 'package:flutter/material.dart';

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final double tabletBreakpoint;
  final EdgeInsets padding;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.tabletBreakpoint = 640,
    this.padding = const EdgeInsets.all(15.0),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: tabletBreakpoint),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
