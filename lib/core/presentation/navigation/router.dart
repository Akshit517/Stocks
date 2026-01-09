import 'package:flutter/material.dart';

import '../../../features/auth/presentation/views/auth_view.dart';
import '../../../features/auth/presentation/views/otp_view.dart';

class RouteNames {
  static const String login = '/';
  static const String otp = '/otp';
  static const String home = '/home';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const AuthView());

      case RouteNames.otp:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => OtpView());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const Placeholder());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
