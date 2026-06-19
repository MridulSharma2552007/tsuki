import 'package:flutter/material.dart';
import 'package:tsuki/app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env/.env.dev");

  runApp(const App());
}
