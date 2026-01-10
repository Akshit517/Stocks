import 'package:flutter/material.dart';
import 'package:stocks/features/auth/presentation/view_models/auth_view_model.dart';

import '../../../../core/presentation/views/base_view.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _showLogoutDialog(BuildContext context, AuthViewModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              model.signOut(
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Logout was Successful"),
                      backgroundColor: Colors.red.shade200,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
            child: Text(
              "Logout",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      builder: (BuildContext context, AuthViewModel model, Widget? child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: model.isBusy
                ? null
                : () => _showLogoutDialog(context, model),
          ),
        );
      },
    );
  }
}
