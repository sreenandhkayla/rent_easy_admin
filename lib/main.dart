import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rent_easy_admin/core/di/injection.dart';
import 'package:rent_easy_admin/firebase_options_dev.dart';
import 'package:rent_easy_admin/rent_easy_admin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  runApp(const RentEasyAdmin());
}
