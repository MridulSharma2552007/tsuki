# Tsuki Design

## Concept

Tsuki (月, Japanese for "moon") is a YouTube Music streaming client wrapped in a retro terminal/CRT aesthetic. The visual identity evokes an old-school computing terminal — amber phosphor on black — paired with ASCII art and typewriter animations. The tagline is **心に響く音** ("sounds that resonate in the heart").

---

## Color Palette

| Token | Hex | Usage |
|---|---|---|
| `primaryBg` | `#0B0D10` | Near-black with a hint of blue (auth screens) |
| `terminalSurface` | `#0A0A0A` | Pure pitch-black (main app surfaces) |
| `terminalAmber` | `#FFB000` | Primary text, borders, icons, cursor |
| `secondary` | `#D6A04D` | Muted amber (ASCII art, secondary text) |

All borders are hard-edged (zero border radius). Opacity variants of amber (55% for inactive, 40% for hints) are used throughout.

---

## Typography

| Style | Font | Size | Tracking | Use |
|---|---|---|---|---|
| `terminal` | Courier | 14px | normal | Body text, labels |
| `terminalTitle` | Courier | 24px | 4px | Section headers |
| `terminalSmall` | Courier | 12px | normal | Subtitles, metadata |

Monospace Courier enforces the terminal feel everywhere.

---

## Key UI Patterns

### 1. Auth Gate (Splash)

An elaborate ASCII art illustration (braille moon/skull motif) is centered on screen. Boot-sequence messages typewriter-in at the bottom left (`initializing audio engine...`, `loading playlists...`, `checking session...`, `ready.`). After the sequence, the app routes to `/login` or `/root` depending on stored JWT.

### 2. Auth Screens (Login / Register / Verify)

- **Background:** `primaryBg` (`#0B0D10`)
- **Layout:** Vertically centered form with ASCII logo, `CustomTextField` inputs (with `> ` prefix hint), and `AuthButton`.
- **Fields:** `CustomTextField` — amber border (`OutlineInputBorder`, zero radius), amber cursor, amber text, `> ` prefix, low-opacity amber hint text. Focus doubles border width to 2px.
- **Button:** `AuthButton` — full-width, amber background, zero radius, black text. On press, background inverts to `terminalSurface`.
- **Validation feedback:** `TerminalOverlay` — a fixed-position amber-bordered toast at the top of screen displaying `> message`.
- **Login/Register swipe:** A `PageView` with swipe or tap-to-toggle between login and register via `"New Here Create a account?"` / `"Already a User Login >"` links.
- **Verify page:** Shows the OTP section with a typewriter reassurance message: *"your data is safe, we store our data in AWS Mumbai server"*.

### 3. Shell / Root Layout

| Element | Position | Details |
|---|---|---|
| `TsukiHeader` | Top | Animated `[TSUKI]` with spinning loader frame (`\| / - \`) |
| Tagline | Below header | `心に響く音 .v1.0.1` in amber |
| `IndexedStack` | Body | Keeps tab state alive across navigation |
| `Navbar` | Bottom | Terminal-style tab bar (HOME, SEARCH, PLAY LISTS, SETTINGS) |

**Navbar:** Horizontal `Row` inside an amber-bordered black container. Active tab is wrapped in brackets (`[ HOME ]`); inactive tabs have reduced opacity (55%). Zero-radius `InkWell` hit targets.

### 4. Home Feed

- **Background:** `terminalSurface`
- **Loading state:** `TsukiLoader` — centered amber text `Loading` with spinning frame (`\| / - \`).
- **Content sections (vertical scroll):**
  - `[Featured]` — horizontal scroll of `ArtistHomeBig` (circular amber-bordered avatar, 150×150, with name below)
  - `[Featured Albums]` — horizontal scroll of `AlbumHomeBig` (amber-bordered rectangular thumbnail, 150×100)
  - `[Featured Songs]` — vertical list of `SongTileSmall` (80px tall, amber-bordered row with 64×64 thumbnail + title/artist/duration)

### 5. Search

- **Search bar:** Same `CustomTextField` style with `> ` prefix and amber (X) clear button. Submits on enter.
- **States:**
  - **History loaded:** Displays `HistoryTile` list — same layout as `SongTileSmall` plus a cancel icon button per row. Tapping cancel triggers a CRT scanline dissolve animation (`ParticleExplosion` — 24 horizontal black bars that grow from top, wiping the tile in 700ms).
  - **Loading:** Centered `TsukiLoader`.
  - **Results:** List of `SongTileSmall` items. Long-press on a result:
    1. Adds to search history (Hive).
    2. Dispatches `PlaySong` event.
    3. Opens a bottom sheet (rounded-top, amber border, black bg) with thumbnail (120×120), title, artist, and three actions: **Play**, **Add to Queue** (TODO), **Like** (TODO).

### 6. Playlists

Placeholder (`Placeholder` widget) — not yet implemented.

### 7. Settings (Debug)

Standard Material `AppBar` + body — not themed in terminal style. A developer audio-test page: enter YouTube video ID → load via innertube API → play/pause with seek slider and position display.

---

## Micro-interactions & Animations

| Element | Animation | Details |
|---|---|---|
| `TsukiHeader` spinner | Frame tick (200ms) | `\| / - \` cycling |
| `TsukiLoader` spinner | Frame tick (100ms) | `\| / - \` cycling |
| Auth boot sequence | Typewriter | 30ms per character, one message at a time |
| Verify reassurance | Typewriter | Single line, 30ms per character |
| TerminalOverlay | Auto-dismiss | Fades after 3 seconds |
| ParticleExplosion | CRT scanline wipe | 24 black bars, 700ms, triggered on history delete |
| Bottom sheet | Slide up | Standard Material sheet with rounded amber border |
| Auth button press | Color invert | Amber → black on press |

---

## Component Tree

```
MaterialApp.router
└── GoRouter
    ├── / → AuthGate
    │   ├── ascii_widget (braille ASCII art)
    │   └── initialization_text (typewriter boot log)
    ├── /login → LoginPage
    │   └── PageView
    │       ├── LoginWidget
    │       │   ├── logoascii
    │       │   ├── tsukiascii
    │       │   ├── CustomTextField (EMAIL)
    │       │   ├── CustomTextField (PASSWORD)
    │       │   └── AuthButton (> LOGIN)
    │       └── RegisterPage
    │           ├── logoascii
    │           ├── tsukiascii
    │           ├── CustomTextField (EMAIL)
    │           ├── CustomTextField (PASSWORD)
    │           └── AuthButton (> REGISTER)
    ├── /verify/:email → VerifyPage
    │   ├── logoascii
    │   ├── tsukiascii
    │   ├── Typewriter (reassurance text)
    │   ├── CustomTextField (6-DIGIT CODE)
    │   └── AuthButton (> VERIFY)
    └── /root → RootPage
        ├── TsukiHeader
        ├── IndexedStack
        │   ├── HomePage
        │   │   ├── [Featured]
        │   │   │   └── FeaturedArtist → ArtistHomeBig (×N)
        │   │   ├── [Featured Albums]
        │   │   │   └── FeaturedAlbum → AlbumHomeBig (×N)
        │   │   └── [Featured Songs]
        │   │       └── FeaturedSongs → SongTileSmall (×N)
        │   ├── SearchPage
        │   │   ├── SearchBar
        │   │   ├── HistoryTile[] / SongTileSmall[]
        │   │   └── BottomSheet (player)
        │   ├── PlaylistPage (Placeholder)
        │   └── SettingsPage (Material debug)
        └── Navbar
            ├── NavItem HOME
            ├── NavItem SEARCH
            ├── NavItem PLAYLISTS
            └── NavItem SETTINGS
```

---

## State Management (UI-relevant BLoCs)

| BLoC | Triggers | States |
|---|---|---|
| `AuthBloc` | Login, Register, Verify, Logout | Initial, AuthLoading, Authenticated, VerificationRequired, AuthError |
| `HomeBloc` | GetFeaturedFeed | HomeLoading, HomeDataLoaded, HomeError |
| `SearchBloc` | Search, LoadSearchHistory, AddToSearchHistory, DeleteHistoryItem | SearchHistoryLoaded, SearchLoading, SearchCompleted |
| `PlayerBloc` | PlaySong, StopSong, PauseSong, ResumeSong, NextSong, PreviousSong | PlayerInitial, PlayerLoading, PlayerPlaying, PlayerPaused, PlayerStopped, PlayerError |

---

## Data & Caching (affects UI)

| Hive Box | Key | TTL | Purpose |
|---|---|---|---|
| `home_cache` | `featured` | 5 days | Home feed data |
| `search_cache` | query string | 4 days | Search results |
| `search_history` | sequential | forever | Browsing history shown on search page |
