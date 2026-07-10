import 'package:go_router/go_router.dart';
import 'package:tsuki/features/home/explore/explore_page.dart';
import 'package:tsuki/features/home/library/library_page.dart';
import 'package:tsuki/features/home/search/search_page.dart';
import 'package:tsuki/features/inits/presentation/pages/onboard/on_board.dart';
import 'package:tsuki/features/inits/presentation/pages/splash/splash_screen.dart';
import 'package:tsuki/features/inits/presentation/pages/spotify/spotify_login.dart';
import 'package:tsuki/features/shell/shell.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboard', builder: (context, state) => OnBoard()),
   // to do build spotify connect
    GoRoute(
      path: '/spotify-login',
      builder: (context, state) => SpotifyLogin(),
    ),
    GoRoute(path: '/shell', builder: (context, state) => const Shell()),
    GoRoute(path: '/explore',builder: (context, state) => const ExplorePage(),),
    GoRoute(path: '/search',builder: (context, state) => const SearchPage(),),
    GoRoute(path: '/library',builder: (context, state) => const LibraryPage(),),

  ],
);
