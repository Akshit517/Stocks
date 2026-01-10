import 'package:flutter/material.dart';

import '../../../features/auth/presentation/views/auth_wrapper.dart';
import '../../../features/stocks/presentation/views/stocks_view.dart';
import '../../../features/stocks/presentation/views/stocks_detail_view.dart';
import '../../../features/auth/presentation/views/auth_view.dart';
import '../../../features/auth/presentation/views/otp_view.dart';

class RouteNames {
  static const String authWrapper = '/';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String stockdetail = '/home/details';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const AuthView());

      case RouteNames.otp:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OtpView(
            verificationId: args['verificationId'],
            phoneNumber: args['phoneNumber'],
          ),
        );

      case RouteNames.home:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => StockView(user: args['user']));

      case RouteNames.stockdetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => StocksDetailView(title: args['title']),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
