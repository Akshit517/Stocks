import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height * 0.5, maxWidth: 800),
      child: SvgPicture.asset(
        'assets/icons/illust.svg',
        width: size.width * 0.7,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
