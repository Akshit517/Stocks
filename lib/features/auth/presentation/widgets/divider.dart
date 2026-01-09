import 'package:flutter/material.dart';

class MiddleTextDivider extends StatelessWidget {
  const MiddleTextDivider({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 2)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const Expanded(child: Divider(thickness: 2)),
      ],
    );
  }
}
