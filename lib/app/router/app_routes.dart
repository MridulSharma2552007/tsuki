import 'package:go_router/go_router.dart';
import 'package:tsuki/app/feature/auth/presentation/pages/auth_gate.dart';
import 'package:tsuki/app/feature/auth/presentation/pages/login_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => AuthGate()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
  ],
);
