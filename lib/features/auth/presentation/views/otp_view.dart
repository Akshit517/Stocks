import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../widgets/pinput_widget.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/auth_illustration.dart';
import '../widgets/tonal_button.dart';

class OtpView extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpView({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final TextEditingController _pinputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _pinputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      builder: (BuildContext context, AuthViewModel model, Widget? child) =>
          ResponsiveScaffold(
            title: "Verify OTP",
            onBackPressed: Navigation().goBack,
            content: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthIllustration(path: 'assets/icons/illust.svg'),
                    const SizedBox(height: 40),
                    Text(
                      "Enter the code sent to ${widget.phoneNumber}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 48),
                    CustomPinput(
                      controller: _pinputController,
                      focusNode: _focusNode,
                      forceErrorState: model.failure != null,
                      onCompleted: (pin) => _onVerify(model),
                    ),
                    const SizedBox(height: 32),
                    TonalButton(
                      title: "Verify & Proceed",
                      onPressed: model.isBusy ? null : () => _onVerify(model),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Didn't you receive any code?",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextButton(
                      onPressed: model.isBusy
                          ? null
                          : () => model.sendOtp(
                              widget.phoneNumber,
                              onSuccess: (id) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Code Resent!")),
                                );
                              },
                            ),
                      child: const Text("Resend New Code"),
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

  void _onVerify(AuthViewModel model) async {
    if (_pinputController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter full 6-digit code")),
      );
      return;
    }

    await model.verifyOtp(
      widget.verificationId,
      _pinputController.text,
      onSuccess: (appUser) {
        Navigation().navigateTo(RouteNames.home, arguments: {'user': appUser});
      },
    );

    if (model.failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(model.failure!.message),
          backgroundColor: Colors.red.shade200,
        ),
      );
    }
  }
}
