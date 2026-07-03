import 'package:go_router/go_router.dart';
import 'package:tsuki/features/inits/onboard/on_board.dart';
import 'package:tsuki/features/inits/splash_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboard', builder: (context, state) => const OnBoard()),
  ],
);
