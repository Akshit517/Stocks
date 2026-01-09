import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.onPressed,
  });
  final String text;
  final void Function()? onPressed;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final BoxConstraints constraints = BoxConstraints(
      maxHeight: 640, // this is the tablet breakpoint
    );

    return SizedBox(
      width: constraints.maxWidth * 0.90,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        label: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SvgPicture.asset(
            iconPath,
            width: Theme.of(context).iconTheme.size ?? 24,
          ),
        ),
      ),
    );
  }
}
