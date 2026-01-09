import 'package:flutter/material.dart';

import '../view_models/auth_view_model.dart';

class PhoneAuthButton extends StatelessWidget {
  const PhoneAuthButton({
    super.key,
    required this.phoneController,
    required this.model,
    this.onPressed,
  });

  final TextEditingController phoneController;
  final AuthViewModel model;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.tonal(
        onPressed: onPressed,
        child: Text("Continue", style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
