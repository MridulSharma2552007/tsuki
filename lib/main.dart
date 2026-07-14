import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tsuki/app/app.dart';
import 'package:tsuki/core/services/metadata_service.dart';
import 'package:tsuki/core/services/shared_preference_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceStorageService.init();
  await MetadataService.init();
  MediaKit.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const App());
}
