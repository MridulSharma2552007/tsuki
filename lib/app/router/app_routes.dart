import 'package:go_router/go_router.dart';
import 'package:tsuki/features/auth/presentation/pages/auth_gate.dart';
import 'package:tsuki/features/auth/presentation/pages/login_page.dart';
import 'package:tsuki/features/auth/presentation/pages/verify_page.dart';
import 'package:tsuki/features/home/home_page.dart';
import 'package:tsuki/shell/root_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => AuthGate()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(
      path: '/verify/:email',
      builder: (context, state) =>
          VerifyPage(email: state.pathParameters['email']!),
    ),
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    GoRoute(path: '/root', builder: (context, state) => RootPage()),
  ],
);
