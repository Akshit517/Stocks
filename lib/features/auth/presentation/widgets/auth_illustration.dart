import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthIllustration extends StatelessWidget {
  final String path;
  const AuthIllustration({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height * 0.5, maxWidth: 800),
      child: SvgPicture.asset(
        path,
        width: size.width * 0.7,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
