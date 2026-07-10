import 'package:flutter/material.dart';
import 'package:tsuki/app/app.dart';
import 'package:tsuki/core/services/shared_preference_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceStorageService.init();
  runApp(const App());
}
