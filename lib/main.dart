import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stocks/firebase_options.dart' show DefaultFirebaseOptions;

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Placeholder());
}
