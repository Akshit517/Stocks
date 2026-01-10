import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../widgets/auth_illustration.dart';
import '../widgets/tonal_button.dart';
import '../widgets/text_form_field_widget.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/divider.dart';
import '../widgets/google_auth_button.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late final TextEditingController phoneController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade200,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      onModelReady: (model) {
        model.addListener(() {
          if (model.failure != null) {
            _showErrorSnackBar(context, model.failure!.message);
            model.clearFailure();
          }
        });
      },
      builder: (BuildContext context, AuthViewModel model, Widget? child) =>
          ResponsiveScaffold(
            title: "SIGN IN",
            content: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthIllustration(path: 'assets/icons/illust.svg'),
                    const SizedBox(height: 64),
                    Form(
                      key: formKey,
                      child: TextFormFieldWidget(
                        controller: phoneController,
                        labelText: "Phone Number",
                        hintText: "Enter your Phone No.",
                        enabled: !model.isBusy,
                        prefixIcon: Icon(Icons.send_to_mobile_outlined),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TonalButton(
                      title: "Continue",
                      onPressed: model.isBusy
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                final String phone =
                                    '+91 ${phoneController.text}';
                                model.sendOtp(
                                  phone,
                                  onSuccess: (verificationId) {
                                    Navigation().navigateTo(
                                      RouteNames.otp,
                                      arguments: {
                                        'verificationId': verificationId,
                                        'phoneNumber': phone,
                                      },
                                    );
                                  },
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 32.0),
                    const MiddleTextDivider(text: "OR"),
                    const SizedBox(height: 32.0),
                    GoogleAuthButton(
                      text: "Sign-in with Google",
                      iconPath: "assets/icons/g_logo.svg",
                      onPressed: model.isBusy
                          ? null
                          : () => model.signInWithGoogle(),
                    ),
                  ],
                ),
                if (model.isBusy)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
    );
  }
}
