import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuki/app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env/.env.dev");
  await Hive.initFlutter();
  await Hive.openBox('home_cache');
  await Hive.openBox('search_cache');
  await Hive.openBox('search_history');
  runApp(const App());
}
