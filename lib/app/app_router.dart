import 'package:go_router/go_router.dart';
import 'package:tsuki/features/inits/presentation/pages/onboard/on_board.dart';
import 'package:tsuki/features/inits/presentation/pages/splash/splash_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboard', builder: (context, state) =>  OnBoard()),
  ],
);
