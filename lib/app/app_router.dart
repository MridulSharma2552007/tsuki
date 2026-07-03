import 'package:go_router/go_router.dart';
import 'package:tsuki/features/init/splash_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
  ],
);
