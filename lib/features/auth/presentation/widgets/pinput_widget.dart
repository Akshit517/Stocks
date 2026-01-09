import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CustomPinput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onCompleted;
  final bool forceErrorState;

  const CustomPinput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCompleted,
    this.forceErrorState = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double boxWidth = (constraints.maxWidth - (5 * 8)) / 6;

        final defaultPinTheme = PinTheme(
          width: boxWidth,
          height: 60,
          textStyle: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 2,
            ),
          ),
        );

        return Pinput(
          length: 6,
          controller: controller,
          focusNode: focusNode,
          forceErrorState: forceErrorState,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: theme.colorScheme.error, width: 2),
            ),
          ),
          onCompleted: onCompleted,
        );
      },
    );
  }
}
