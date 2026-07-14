 _________  ________  ___  ___  ___  __    ___     
|\___   ___\\   ____\|\  \|\  \|\  \|\  \ |\  \    
\|___ \  \_\ \  \___|\ \  \\\  \ \  \/  /|\ \  \   
     \ \  \ \ \_____  \ \  \\\  \ \   ___  \ \  \  
      \ \  \ \|____|\  \ \  \\\  \ \  \\ \  \ \  \ 
       \ \__\  ____\_\  \ \_______\ \__\\ \__\ \__\
        \|__| |\_________\|_______|\|__| \|__|\|__|
              \|_________|                         
                                                   
                                                     
                              

Welcome, contributor! This guide will walk you through every corner of the
Tsuki codebase — its structure, services, routing, design system, and where
you can jump in and help.


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  TABLE OF CONTENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1.  What is Tsuki?
  2.  Tech Stack
  3.  Project Root — File Map
  4.  Full Directory Tree
  5.  App Bootstrap — How the App Starts
  6.  Routing — How Pages Are Decided
  7.  The Shell — Main App Layout
  8.  Core Services — Deep Dive
  9.  Feature Modules — Page by Page
  10. Backend — JioSaavnAPI
  11. Data Flow — How Search Works End-to-End
  12. Design System — Colors, Typography, Philosophy
  13. Spotify Integration — Status & What Needs Doing
  14. Open Contribution Areas
  15. Getting Started Locally
  16. Coding Conventions


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. WHAT IS TSUKI?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tsuki (internally also called "Hum") is a mobile music player for Android.
It searches and plays songs from YouTube Music, with Spotify library import
on the roadmap. The vibe: a quiet room, not a dashboard.

  ┌─────────────────────────────────────────────────────────────┐
  │  ┌─────────┐   ┌──────────┐   ┌──────────┐   ┌─────────┐ │
  │  │ Explore │   │  Search  │   │ Library  │   │ Profile │ │
  │  │   (0)   │   │   (1)    │   │   (2)    │   │   (3)   │ │
  │  │  [TODO] │   │  [WORKS] │   │  [STUB]  │   │ [TODO]  │ │
  │  └─────────┘   └──────────┘   └──────────┘   └─────────┘ │
  │                     │                                      │
  │              Search YouTube Music                          │
  │              Play audio streams                            │
  └─────────────────────────────────────────────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  2. TECH STACK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  FRONTEND (Flutter / Dart)
  ─────────────────────────
  flutter_bloc        BLoC pattern state management
  go_router           Declarative URL-based routing
  dio                 HTTP client
  youtube_explode     YouTube search + stream extraction
  media_kit           Audio playback engine
  flutter_inappwebview In-app browser (Spotify login)
  flutter_secure_storage  Encrypted local storage
  shared_preferences  Simple key-value storage
  flutter_dotenv      Environment config (.env)
  google_fonts        Fraunces + DM Sans typography
  flutter_svg         SVG icon rendering

  BACKEND (Python / Flask)
  ────────────────────────
  Flask               Web framework
  flask-cors          Cross-origin support
  requests            HTTP client for JioSaavn
  pyDes               DES decryption for media URLs
  gunicorn            Production WSGI server
  Vercel              Deployment platform

  ANDROID PLATFORM
  ────────────────
  Kotlin              Standard FlutterActivity
  AGP 8.11.1          Gradle plugin
  Java 17             Compatibility target


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  3. PROJECT ROOT — FILE MAP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  tsuki/
  │
  ├── .env                        # Backend URL (BACKEND_URL=https://tsukii.vercel.app)
  ├── .gitignore
  ├── pubspec.yaml                # Flutter deps & project metadata
  ├── pubspec.lock                # Locked dep versions
  ├── analysis_options.yaml       # Dart linter rules
  │
  ├── lib/                        # >>> Flutter source code <<<
  ├── android/                    # >>> Android platform shell <<<
  ├── assets/                     # >>> SVG icons (house, search, library, user) <<<
  ├── JioSaavnAPI/                # >>> Python/Flask backend <<<
  ├── docs/                       # >>> Design guide + Spotify auth spec <<<
  └── reverse_engineering/        # >>> Spotify API research notes <<<


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  4. FULL DIRECTORY TREE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  tsuki/
  │
  ├── lib/
  │   ├── main.dart                              # Entry point
  │   │
  │   ├── app/
  │   │   ├── app.dart                           # Root widget (MultiBlocProvider + MaterialApp)
  │   │   ├── app_router.dart                    # GoRouter route table
  │   │   └── theme/
  │   │       ├── app_colors.dart                # Color palette
  │   │       └── app_text_theme.dart            # Typography
  │   │
  │   ├── core/
  │   │   ├── config/
  │   │   │   └── env.dart                       # Loads .env vars
  │   │   ├── constants/
  │   │   │   ├── api_constants.dart             # [EMPTY] API route constants
  │   │   │   ├── auth_keys.dart                 # SharedPref key "isLoggedin"
  │   │   │   └── spotify_cookies_keys.dart      # Spotify cookie key
  │   │   ├── network/
  │   │   │   └── dio_client.dart                # Dio HTTP client (base URL)
  │   │   ├── services/
  │   │   │   ├── metadata_service.dart          # YouTube search via youtube_explode
  │   │   │   ├── player_service.dart            # Audio playback via media_kit
  │   │   │   ├── secure_storage_services.dart   # Encrypted storage wrapper
  │   │   │   ├── shared_preference_storage_service.dart  # Simple storage wrapper
  │   │   │   ├── time_formatter.dart            # Duration -> "mm:ss" formatter
  │   │   │   └── yt_music_extractor_Service.dart # YouTube audio stream extractor
  │   │   ├── storage/
  │   │   │   └── spotify_cookies_service.dart   # [EMPTY] Spotify cookie storage
  │   │   └── widgets/
  │   │       ├── buttons.dart                   # PrimaryButton (pill shape)
  │   │       ├── song_tile.dart                 # SongTile (image + title + meta)
  │   │       └── textfields.dart                # CustomSearchTextField
  │   │
  │   └── features/
  │       ├── home/
  │       │   ├── explore/
  │       │   │   └── explore_page.dart          # [PLACEHOLDER] no content yet
  │       │   ├── library/
  │       │   │   └── library_page.dart          # [STUB] heading only
  │       │   └── search/
  │       │       ├── search_page.dart            # Full search UI
  │       │       ├── bloc/
  │       │       │   ├── search_bloc.dart        # Search BLoC
  │       │       │   ├── search_event.dart       # SearchSongs event
  │       │       │   └── search_state.dart       # Init/Loading/Loaded/Error
  │       │       └── data/
  │       │           ├── search_repository.dart  # Calls MetadataService
  │       │           └── models/
  │       │               └── search_model.dart   # Maps Video -> SearchModel
  │       ├── inits/
  │       │   └── presentation/pages/
  │       │       ├── splash/
  │       │       │   └── splash_screen.dart      # 3s delay, routes by login state
  │       │       ├── onboard/
  │       │       │   ├── on_board.dart           # 3-page onboarding carousel
  │       │       │   └── widgets/
  │       │       │       └── page_zero_onboard.dart  # Reusable onboarding page
  │       │       └── spotify/
  │       │           ├── spotify_login.dart      # "Connect with Spotify" screen
  │       │           ├── spotify_connect.dart    # WebView token grabber (prototype)
  │       │           └── bloc/
  │       │               ├── spotify_bloc.dart   # [EMPTY]
  │       │               ├── spotify_event.dart  # [EMPTY]
  │       │               └── spotify_state.dart  # [EMPTY]
  │       └── shell/
  │           ├── shell.dart                      # IndexedStack + NavBar host
  │           └── nav_bar.dart                    # Custom bottom nav bar
  │
  ├── android/
  │   ├── build.gradle.kts                        # Root Gradle config
  │   ├── settings.gradle.kts                     # AGP + Kotlin versions
  │   └── app/
  │       ├── build.gradle.kts                    # App-level build config
  │       └── src/main/
  │           ├── AndroidManifest.xml
  │           ├── kotlin/.../MainActivity.kt
  │           └── res/
  │               ├── xml/network_security_config.xml  # Cleartext for localhost
  │               ├── drawable/                   # Launch backgrounds
  │               ├── values/ + values-night/     # Light/dark styles
  │               └── mipmap-*/                   # App icons
  │
  ├── assets/icons/
  │   ├── house.svg                               # Nav: Explore
  │   ├── search.svg                              # Nav: Search
  │   ├── square-library.svg                      # Nav: Library
  │   └── user.svg                                # Nav: Profile
  │
  ├── JioSaavnAPI/
  │   ├── app.py                                  # Flask REST endpoints
  │   ├── jiosaavn.py                             # JioSaavn API client
  │   ├── helper.py                               # URL decryption + formatting
  │   ├── endpoints.py                            # JioSaavn URL constants
  │   ├── requirements.txt                        # Python dependencies
  │   ├── vercel.json                             # Vercel deploy config
  │   └── Procfile                                # Gunicorn config
  │
  ├── docs/
  │   ├── hum-style-guide.md                      # Full design system
  │   └── spotify-scraper.md                      # Spotify private API auth spec
  │
  └── reverse_engineering/
      ├── spotify.md                              # Spotify API findings
      └── spotify.txt                             # Raw captured data


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  5. APP BOOTSTRAP — HOW THE APP STARTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Everything begins in lib/main.dart:

  ┌─────────────────────────────────────────────────────────────────┐
  │  main.dart                                                     │
  │                                                                 │
  │  1. SharedPreferenceStorageService.init()   (async)             │
  │  2. MetadataService.init()                  (async)             │
  │  3. MediaKit.ensureInitialized()            (sync)              │
  │  4. dotenv.load()                           (async)             │
  │  5. runApp(App())                                              │
  │                                                                 │
  │  App (lib/app/app.dart)                                        │
  │  └── MultiBlocProvider                                         │
  │       └── SearchBloc(SearchRepository())                       │
  │           └── MaterialApp.router                               │
  │                └── GoRouter (app_router.dart)                   │
  │                     └── Initial route: "/" (SplashScreen)       │
  └─────────────────────────────────────────────────────────────────┘

  The init order matters. SharedPref must be ready before any BLoC
  checks login state. MetadataService needs YoutubeExplode initialized
  before any search happens. MediaKit must be initialized before the
  player is created.


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  6. ROUTING — HOW PAGES ARE DECIDED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Routing is handled by GoRouter in lib/app/app_router.dart.

  ┌──────────────────────────────────────────────────────────────┐
  │                     ROUTE TABLE                              │
  ├────────────────┬─────────────────────┬───────────────────────┤
  │  PATH          │  WIDGET             │  PURPOSE              │
  ├────────────────┼─────────────────────┼───────────────────────┤
  │  /             │  SplashScreen       │  Entry, auto-redirect │
  │  /onboard      │  OnBoard            │  3-page intro         │
  │  /spotify-login│  SpotifyLogin       │  Spotify connect      │
  │  /shell        │  Shell              │  Main app (4 tabs)    │
  │  /explore      │  ExplorePage        │  Explore (standalone) │
  │  /search       │  SearchPage         │  Search (standalone)  │
  │  /library      │  LibraryPage        │  Library (standalone) │
  └────────────────┴─────────────────────┴───────────────────────┘

  THE NAVIGATION FLOW:

                          App Starts
                              │
                              ▼
                      ┌──────────────┐
                      │ Splash (/)   │
                      │  3s delay    │
                      └──────┬───────┘
                             │
                  ┌──────────┴──────────┐
                  │                     │
            isLoggedIn?            isLoggedIn?
              FALSE                 TRUE
                  │                     │
                  ▼                     ▼
          ┌──────────────┐      ┌──────────────┐
          │  /onboard    │      │   /shell     │
          │  3 pages     │      │   4 tabs     │
          │  PageView    │      │              │
          └──────┬───────┘      └──────────────┘
                 │
          "Get Started"
                 │
                 ▼
          ┌──────────────┐
          │   /shell     │
          └──────────────┘

  NOTE: The /spotify-login route exists but is NOT wired into the
  splash/onboard flow yet. It is only reachable by direct URL.
  TODO: Connect this into the onboarding flow.


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  7. THE SHELL — MAIN APP LAYOUT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  File: lib/features/shell/shell.dart

  The Shell is the persistent container for the app after onboarding.
  It uses an IndexedStack (preserves state across tabs) with 4 pages
  and a custom floating NavBar at the bottom.

  ┌─────────────────────────────────────────────────┐
  │                                                 │
  │                                                 │
  │          IndexedStack[currentIndex]              │
  │                                                 │
  │   index 0: ExplorePage    (placeholder)         │
  │   index 1: SearchPage     (functional)          │
  │   index 2: LibraryPage    (stub)                │
  │   index 3: Placeholder()  (profile, empty)      │
  │                                                 │
  │                                                 │
  │  ┌───────────────────────────────────────────┐  │
  │  │  ╔═══════╗  ╔═══════╗  ╔═══════╗  ╔════╗│  │
  │  │  │ 🏠    │  │ 🔍    │  │ 📚    │  │ 👤 ││  │
  │  │  │ house │  │search │  │library│  │user││  │
  │  │  ╚═══════╝  ╚═══════╝  ╚═══════╝  ╚════╝│  │
  │  └───────────────────────────────────────────┘  │
  │                                                 │
  └─────────────────────────────────────────────────┘

  On first load, the Shell sets the "isLoggedin" flag to true in
  SharedPreferences so subsequent app launches skip onboarding.

  The NavBar (lib/features/shell/nav_bar.dart) is a custom widget —
  NOT a Material BottomNavigationBar. It uses SVG icons from assets/icons/
  and a pill-shaped highlight on the active item.


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  8. CORE SERVICES — DEEP DIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  All live in lib/core/services/. These are singletons (except
  MetadataService which uses static methods).

  ┌─────────────────────────────────────────────────────────────────────┐
  │                                                                     │
  │  MetadataService                    lib/core/services/              │
  │  ─────────────────                                    metadata_     │
  │  Wraps youtube_explode_dart.        searchSongs(query) → [Video]   │
  │  Appends "official audio" to queries for better results.           │
  │  Initialized once at app start. Static class (no instances).       │
  │                                                                     │
  ├─────────────────────────────────────────────────────────────────────┤
  │                                                                     │
  │  YtMusicExtractorService           lib/core/services/              │
  │  ──────────────────────                         yt_music_extractor │
  │  Extracts a playable audio URL from a YouTube video ID.            │
  │  Tries 4 client configs in order:                                   │
  │    1. androidSdkless  (no special client)                           │
  │    2. androidVr       (Oculus Quest user agent)                     │
  │    3. ios             (iPhone user agent)                           │
  │    4. tv              (Cobalt/Chromium user agent)                  │
  │                                                                     │
  │  For each client:                                                   │
  │    a) Try direct URL access (HEAD request, 8s timeout)              │
  │    b) Fallback: download entire stream to temp file                 │
  │                                                                     │
  │  Returns AudioSourceResult(source: String, isFile: bool)            │
  │  Singleton via private constructor.                                 │
  │                                                                     │
  ├─────────────────────────────────────────────────────────────────────┤
  │                                                                     │
  │  PlayerService                    lib/core/services/               │
  │  ──────────────                                    player_service   │
  │  Singleton wrapper around media_kit's Player.                      │
  │  Methods: play(AudioSourceResult), stop(), pause(), seek(Duration)  │
  │  Stops any current playback before playing a new source.            │
  │                                                                     │
  ├─────────────────────────────────────────────────────────────────────┤
  │                                                                     │
  │  SecureStorageServices            lib/core/services/               │
  │  ─────────────────────                            secure_storage    │
  │  Wrapper around FlutterSecureStorage (encrypted).                  │
  │  Methods: write(key, value), read(key), delete(key), deleteAll()   │
  │  Singleton. Will be used for Spotify sp_dc cookie storage.          │
  │                                                                     │
  ├─────────────────────────────────────────────────────────────────────┤
  │                                                                     │
  │  SharedPreferenceStorageService   lib/core/services/               │
  │  ──────────────────────────────                     shared_         │
  │  Wrapper around SharedPreferences (plaintext).                     │
  │  Methods: setString, setBool, setInt, getBool, remove              │
  │  Singleton. Used for: login flag, simple prefs.                    │
  │  Must call .init() before use (in main.dart).                      │
  │                                                                     │
  ├─────────────────────────────────────────────────────────────────────┤
  │                                                                     │
  │  TimeFormatter                    lib/core/services/               │
  │  ──────────────                                    time_formatter   │
  │  Static utility. Duration → "mm:ss" or "h:mm:ss" string.          │
  │                                                                     │
  ├─────────────────────────────────────────────────────────────────────┤
  │                                                                     │
  │  DioClient                        lib/core/network/               │
  │  ─────────                                        dio_client       │
  │  Pre-configured Dio instance. Base URL from .env (BACKEND_URL).    │
  │  Currently not used by any feature — the search flow goes          │
  │  directly through youtube_explode_dart.                            │
  │                                                                     │
  └─────────────────────────────────────────────────────────────────────┘

  STORAGE LAYERS:
  ┌──────────────────────┬──────────────────────┬──────────────────────┐
  │  SharedPrefs          │  SecureStorage        │  SpotifyCookies     │
  │  (simple, plaintext)  │  (encrypted)          │  (EMPTY, planned)   │
  │                       │                       │                     │
  │  - isLoggedin         │  - will hold sp_dc    │  - will manage      │
  │  - simple flags       │  - token storage      │    cookie lifecycle │
  └──────────────────────┴──────────────────────┴──────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  9. FEATURE MODULES — PAGE BY PAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  SPLASH SCREEN
  ─────────────
  File:  lib/features/inits/presentation/pages/splash/splash_screen.dart
  State: WORKING

  Shows a dark screen for 3 seconds, then checks SharedPrefs for
  "isLoggedin". Routes to /shell (if true) or /onboard (if false).

  ONBOARDING
  ──────────
  File:  lib/features/inits/presentation/pages/onboard/on_board.dart
  State: WORKING

  3-page PageView carousel:
    Page 0 — Mood matching concept
    Page 1 — Play anything concept
    Page 2 — Library gathering concept

  Uses reusable page_zero_onboard.dart for layout. Has "Skip" on page 0
  and "Get Started" on page 2, both navigate to /shell.

  SPOTIFY LOGIN
  ─────────────
  Files: lib/features/inits/presentation/pages/spotify/
    spotify_login.dart       — Marketing screen with "Connect" button
    spotify_connect.dart     — InAppWebView that opens Spotify login
    bloc/spotify_bloc.dart   — [EMPTY]
    bloc/spotify_event.dart  — [EMPTY]
    bloc/spotify_state.dart  — [EMPTY]

  State: PROTOTYPE (not wired into navigation flow)

  spotify_connect.dart uses InAppWebView to load accounts.spotify.com/login
  and tries to intercept tokens via JavaScript injection. This is an early
  prototype — see section 13 for the full plan.

  SEARCH PAGE
  ───────────
  Files: lib/features/home/search/
    search_page.dart         — UI with search field + BlocBuilder results
    bloc/search_bloc.dart    — Handles SearchSongs event
    bloc/search_event.dart   — SearchSongs(query)
    bloc/search_state.dart   — Initialized / Loading / Loaded / Error
    data/search_repository.dart  — Calls MetadataService.searchSongs()
    data/models/search_model.dart — Maps Video to SearchModel

  State: FULLY FUNCTIONAL (the main working feature)

  EXPLORE PAGE
  ────────────
  File:  lib/features/home/explore/explore_page.dart
  State: PLACEHOLDER (returns Placeholder() widget)

  LIBRARY PAGE
  ────────────
  File:  lib/features/home/library/library_page.dart
  State: STUB (shows "Your library" heading only)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  10. BACKEND — JioSaavnAPI
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Location: JioSaavnAPI/
  Deployed: https://tsukii.vercel.app
  Stack:    Python 3.8 + Flask + flask-cors + requests + pyDes

  NOTE: The backend is fully built but the Flutter app does NOT call it
  yet. The DioClient points to it, but ApiConstants is empty and the
  search flow uses YouTube directly.

  ┌──────────────────────────────────────────────────────────────────┐
  │                     API ROUTES                                   │
  ├──────────────┬────────┬──────────────────────────────────────────┤
  │  ENDPOINT    │ METHOD │  DESCRIPTION                             │
  ├──────────────┼────────┼──────────────────────────────────────────┤
  │  /           │  GET   │  Redirects to JioSaavnAPI docs           │
  │  /song/      │  GET   │  Search songs (?query=, ?lyrics=)        │
  │  /song/get/  │  GET   │  Get song by ID (?id=, ?lyrics=)         │
  │  /playlist/  │  GET   │  Search playlist (?query=, ?lyrics=)     │
  │  /album/     │  GET   │  Search album (?query=, ?lyrics=)        │
  │  /lyrics/    │  GET   │  Get lyrics (?query= — URL or ID)        │
  │  /result/    │  GET   │  Universal: auto-detects URL type        │
  └──────────────┴────────┴──────────────────────────────────────────┘

  Backend file breakdown:
  ┌──────────────────────────────────────────────────────────────────┐
  │  app.py        Flask app + route handlers (CORS enabled)        │
  │  jiosaavn.py   Core client: search, get_song, get_album, etc.   │
  │  helper.py     format_song(), format_album(), decrypt_url()     │
  │  endpoints.py  JioSaavn internal API URL constants              │
  │  vercel.json   Vercel serverless function config                 │
  └──────────────────────────────────────────────────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  11. DATA FLOW — HOW SEARCH WORKS END-TO-END
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  User types query in SearchPage
          │
          ▼
  SearchPage fires SearchSongs(query) event
          │
          ▼
  SearchBloc._onSearchSongs() receives event
          │
          ├─► emit(SearchLoading())
          │
          ├─► SearchRepository.search(query)
          │        │
          │        ▼
          │   MetadataService.searchSongs(query)
          │        │  (appends "official audio")
          │        ▼
          │   YoutubeExplode.search.search("query official audio")
          │        │
          │        ▼
          │   List<Video> returned
          │        │
          │        ▼
          │   Videos mapped to List<SearchModel>
          │
          ├─► emit(SearchLoaded(results))
          │
          └─► on error: emit(SearchError(message))

  When user taps a song:
          │
          ▼
  YtMusicExtractorService.getPlayableSource(videoId)
          │
          ├─► Try 4 YouTube client configs
          │   (androidSdkless → androidVr → ios → tv)
          │
          ├─► For each: try direct URL, then download fallback
          │
          ▼
  AudioSourceResult(source, isFile)
          │
          ▼
  PlayerService.play(source)
          │
          ▼
  media_kit Player plays audio


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  12. DESIGN SYSTEM — COLORS, TYPOGRAPHY, PHILOSOPHY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Philosophy: "Feel like a quiet room, not a dashboard."
  No shadows. No gradients. Flat color fills only.
  Pill shapes for buttons, chips, and nav bar.

  COLOR PALETTE (lib/app/theme/app_colors.dart):
  ┌─────────────────────────────────────────────────────────────────┐
  │                                                                 │
  │  BASE COLORS                                                    │
  │  ───────────                                                    │
  │  ░░░░░░░░░░░░  Background  #F8F3E8  (warm cream)               │
  │  ████████████  Surface     #1D1B17  (dark ink — nav, buttons)   │
  │  ██████████░░  TextPrimary #221F1A  (warm dark)                 │
  │  ▓▓▓▓▓▓▓▓░░░░  TextSecond  #6B685F  (muted)                    │
  │  ▒▒▒▒▒▒▒▒▒▒▒▒  Inactive    #9A9689  (faint)                    │
  │  ░░░░░░░░░░░░  Divider     #E4DDCC  (hairline)                 │
  │                                                                 │
  │  MOOD COLORS (each pair = bg + matching text)                   │
  │  ────────────────────────────────────────────                   │
  │  ☁️  Sky       #C7E3F3  +  #1B4D66  (calm)                     │
  │  🌅  Amber     #F6C768  +  #6B4707  (happy)                    │
  │  🌸  Rose      #F3C9D3  +  #7A2E40  (nostalgic)                │
  │  🌿  Sage      #CFE0BE  +  #3C5A28  (focus)                    │
  │                                                                 │
  │  RULE: Never mix a mood bg with textPrimary.                    │
  │        Always use its matching *Text color.                      │
  │                                                                 │
  └─────────────────────────────────────────────────────────────────┘

  TYPOGRAPHY (lib/app/theme/app_text_theme.dart):
  ┌─────────────────────────────────────────────────────────────────┐
  │                                                                 │
  │  Display & Headings  →  Fraunces (serif)     weights 400-500   │
  │  UI & Body Text      →  DM Sans (sans-serif) weights 400-600   │
  │                                                                 │
  │  RULE: Never mix serif and sans-serif within a single line.     │
  │                                                                 │
  └─────────────────────────────────────────────────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  13. SPOTIFY INTEGRATION — STATUS & WHAT NEEDS DOING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  The goal: let users connect their Spotify account to import playlists
  and liked songs. This uses Spotify's PRIVATE/INTERNAL API (not the
  official Web API). Full spec in docs/spotify-scraper.md.

  THE 4-PHASE PLAN:

  ┌──────────────────────────────────────────────────────────────┐
  │                                                              │
  │  PHASE 1: Login (one-time)                                   │
  │  ────────────────────────                                    │
  │  User logs in via WebView → app captures sp_dc cookie        │
  │  Store in SecureStorageServices (encrypted at rest)          │
  │                                                              │
  │  Status: PROTOTYPE (SpotifyConnect has WebView, but           │
  │          token interception via JS is unreliable)            │
  │                                                              │
  │  Files to build out:                                         │
  │  ├── lib/core/storage/spotify_cookies_service.dart  [EMPTY]  │
  │  ├── lib/features/.../spotify/bloc/spotify_bloc.dart [EMPTY] │
  │  ├── lib/features/.../spotify/bloc/spotify_event.dart [EMPTY]│
  │  └── lib/features/.../spotify/bloc/spotify_state.dart [EMPTY]│
  │                                                              │
  ├──────────────────────────────────────────────────────────────┤
  │                                                              │
  │  PHASE 2: Token Refresh Loop (every 50-60 min)               │
  │  ─────────────────────────────────────────────               │
  │                                                              │
  │  Step A: GET Client-Token from clienttoken.spotify.com       │
  │          (device fingerprint — lasts ~14 days)               │
  │                                                              │
  │  Step B: Generate TOTP code locally (6-digit, version 61)    │
  │          (no network call — pure local computation)          │
  │                                                              │
  │  Step C: Trade sp_dc + Client-Token + TOTP for Access Token  │
  │          GET open.spotify.com/api/token                      │
  │          (valid ~60 min, refresh 5 min before expiry)        │
  │                                                              │
  │  Status: NOT IMPLEMENTED                                     │
  │                                                              │
  ├──────────────────────────────────────────────────────────────┤
  │                                                              │
  │  PHASE 3: Streaming                                          │
  │  ────────────────────                                        │
  │  Use Access Token for playback requests.                     │
  │  Handle 401 → prompt re-login if sp_dc is invalidated.      │
  │                                                              │
  │  Status: NOT IMPLEMENTED                                     │
  │                                                              │
  └──────────────────────────────────────────────────────────────┘

  EMPTY FILES NEEDING IMPLEMENTATION:
  ┌──────────────────────────────────────────────────────────────────┐
  │  lib/core/storage/spotify_cookies_service.dart                   │
  │  → Manages sp_dc cookie lifecycle: store, retrieve, validate    │
  │                                                                  │
  │  lib/features/.../spotify/bloc/spotify_bloc.dart                 │
  │  → BLoC for Spotify auth state: login, token refresh, logout    │
  │                                                                  │
  │  lib/features/.../spotify/bloc/spotify_event.dart                │
  │  → Events: ConnectSpotify, RefreshToken, DisconnectSpotify      │
  │                                                                  │
  │  lib/features/.../spotify/bloc/spotify_state.dart                │
  │  → States: SpotifyInitial, SpotifyConnected, SpotifyError       │
  │                                                                  │
  │  lib/core/constants/api_constants.dart                           │
  │  → Spotify API endpoint URLs (clienttoken, /api/token, etc.)    │
  └──────────────────────────────────────────────────────────────────┘

  Also needs wiring:
  - /spotify-login route needs to be added to the onboarding flow
  - The existing SpotifyConnect WebView should feed cookies to the
    new SpotifyCookiesService instead of trying JS injection


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  14. OPEN CONTRIBUTION AREAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Here is what you can work on right now, roughly ordered by impact:

  ┌─────────────────────────────────────────────────────────────────┐
  │  ★ HIGH PRIORITY                                               │
  ├─────────────────────────────────────────────────────────────────┤
  │                                                                 │
  │  1. SPOTIFY INTEGRATION                                        │
  │     Implement the 3-phase auth flow described in                │
  │     docs/spotify-scraper.md. Build out the empty BLoC files,   │
  │     SpotifyCookiesService, and the token refresh loop.         │
  │                                                                 │
  │  2. WIRE SPOTIFY INTO ONBOARDING                               │
  │     Connect /spotify-login into the splash → onboard flow.     │
  │     Decide: should Spotify be optional or required?            │
  │                                                                 │
  │  3. CONNECT BACKEND TO APP                                      │
  │     The JioSaavnAPI is deployed but unused. Populate           │
  │     ApiConstants, add Dio calls in a new data layer, and       │
  │     decide: use JioSaavn, YouTube, or both?                   │
  │                                                                 │
  ├─────────────────────────────────────────────────────────────────┤
  │  ★★ MEDIUM PRIORITY                                            │
  ├─────────────────────────────────────────────────────────────────┤
  │                                                                 │
  │  4. EXPLORE PAGE                                               │
  │     Currently a Placeholder(). Build the home/explore screen.  │
  │     Ideas: mood-based recommendations, trending, recent plays. │
  │                                                                 │
  │  5. LIBRARY PAGE                                               │
  │     Currently just a heading. Implement: saved songs, playlists │
  │     (from Spotify import or JioSaavn), local favorites.        │
  │                                                                 │
  │  6. PROFILE / SETTINGS TAB                                     │
  │     4th tab is Placeholder(). Build: user info, Spotify        │
  │     connection status, theme settings, about page.             │
  │                                                                 │
  │  7. PLAYER UI                                                  │
  │     No full-screen player exists yet. Build: album art,        │
  │     progress bar, controls, queue, mood-based backgrounds.     │
  │                                                                 │
  ├─────────────────────────────────────────────────────────────────┤
  │  ★★★ LOWER PRIORITY (but still helpful)                        │
  ├─────────────────────────────────────────────────────────────────┤
  │                                                                 │
  │  8.  Android signing config (release builds use debug keys)    │
  │  9.  Change Application ID from com.example.tsuki              │
  │  10. Remove unused deps (just_audio, animated_text_kit)        │
  │  11. Add error handling / toast messages across the app        │
  │  12. Add loading skeletons / shimmer effects to search results │
  │  13. Lyrics display feature (backend already supports it)      │
  │  14. Persist playback queue across app restarts                │
  │  15. Add unit tests and widget tests                           │
  │                                                                 │
  └─────────────────────────────────────────────────────────────────┘


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  15. GETTING STARTED LOCALLY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  PREREQUISITES:
    • Flutter SDK >= 3.11.5 (stable channel)
    • Android Studio / VS Code with Flutter plugin
    • Android device or emulator (API 21+)
    • Python 3.8+ (only for backend)

  SETUP:
    1.  Clone the repo
        git clone https://github.com/<your-fork>/tsuki.git
        cd tsuki

    2.  Install Flutter deps
        flutter pub get

    3.  Create .env file in project root
        echo "BACKEND_URL=https://tsukii.vercel.app" > .env

    4.  Run on connected device
        flutter run

  RUNNING THE BACKEND (optional):
    1.  cd JioSaavnAPI
    2.  pip install -r requirements.txt
    3.  python app.py
    4.  Backend runs on http://localhost:5100

  USEFUL COMMANDS:
    flutter run                   # Run on connected device
    flutter analyze               # Static analysis
    flutter build apk             # Build release APK
    flutter test                  # Run tests (currently none)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  16. CODING CONVENTIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  DART / FLUTTER:
    • Follow official Dart style guide (effective_dart)
    • Use BLoC for state management (flutter_bloc)
    • Services are singletons with private constructors: ClassName._()
    • Static services use static methods and late final fields
    • Widgets are StatelessWidget unless they need setState
    • Keep UI in widgets/, business logic in bloc/, data in data/
    • Use const constructors wherever possible
    • File naming: snake_case (e.g., search_bloc.dart)

  PROJECT STRUCTURE:
    • lib/core/     → shared services, utils, constants, widgets
    • lib/features/ → feature modules (home/, inits/, shell/)
    • Each feature can have its own bloc/, data/, presentation/ dirs

  DESIGN:
    • Use AppColors for all colors (no hardcoded hex values)
    • Use AppTextTheme for all text styles
    • Follow the pill-shape convention for buttons and chips
    • No shadows, no gradients — flat fills only
    • Refer to docs/hum-style-guide.md for detailed specs

  GIT:
    • One feature per branch
    • Conventional commits preferred (feat:, fix:, chore:)
    • Don't commit .env or build artifacts


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ┌─────────────────────────────────────────────────────────────────┐
  │                                                                 │
  │   That's everything! If you have questions, open an issue       │
  │   or reach out. Happy coding!                                   │
  │                                                                 │
  │                    ♪  Thanks for contributing to Tsuki  ♪        │
  │                                                                 │
  └─────────────────────────────────────────────────────────────────┘

