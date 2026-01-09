import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/locator.dart';
import 'core/core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  runApp(const StocksApp());
}

class StocksApp extends StatelessWidget {
  const StocksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      title: "Stocks",
      initialRoute: RouteNames.login,
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation().navigatorKey,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
