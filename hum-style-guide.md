# Hum — style guide

A calm, warm music app. The goal on every screen: feel like a quiet room, not a dashboard.

## Colors

| Name | Hex | Use |
|---|---|---|
| Cream (background) | `#F8F3E8` | Screen background, everywhere |
| Ink (bezel / nav / buttons) | `#1D1B17` | Bottom nav bar, primary buttons, mini player background |
| Ink text | `#221F1A` | Body text, headings on cream |
| Muted text | `#6B685F` | Secondary text, timestamps, subtitles |
| Faint text | `#9A9689` | Placeholder text, inactive nav icons |
| Hairline | `#E4DDCC` | List dividers, thin borders |
| Sky (mood: calm) | `#C7E3F3` bg / `#1B4D66` text | "Calm", "Liked songs", calm-tagged content |
| Amber (mood: happy/warm) | `#F6C768` bg / `#6B4707` text | "Happy", golden/warm-tagged content |
| Rose (mood: nostalgic) | `#F3C9D3` bg / `#7A2E40` text | "Nostalgic", "Rainy day" |
| Sage (mood: focus) | `#CFE0BE` bg / `#3C5A28` text | "Focus", "Deep focus" |

**Rule:** every mood/playlist card gets exactly one of the four accent colors, and the text on it always uses that color's dark variant — never plain black. Cycle the four colors; don't invent new ones per screen.

## Typography

- **Display / headings:** Fraunces (serif). Weights 400 and 500 only. Used for screen titles, greetings, and playlist/card names — anywhere the app is "speaking" to the user.
- **UI / body:** DM Sans (sans-serif). Weights 400 and 500 only. Used for buttons, labels, list rows, nav, timestamps — anywhere the app is showing data or controls.
- Never mix them within a single line of text. Serif = voice, sans = interface.

| Element | Font | Size | Weight |
|---|---|---|---|
| Screen title | Fraunces | 22–27px | 500 |
| Card / playlist name | Fraunces | 13–15px | 500 |
| Body / list text | DM Sans | 13–14px | 400 |
| Secondary / muted text | DM Sans | 11–13px | 400 |
| Button label | DM Sans | 14px | 500 |

## Spacing & shape

- Corner radius: `16px` for cards, `999px` (full pill) for buttons, chips, and the bottom nav bar, `30px` for the screen itself inside its device frame.
- Card padding: `12–14px`.
- Section gap: `20–26px` vertical between major sections.
- No shadows anywhere. Depth comes from color blocks, not elevation.
- No gradients. Flat fills only.

## Components

**Buttons (primary)** — full-width pill, ink background (`#1D1B17`), cream text, 15px vertical padding, icon + label centered.

**Mood chips** — small pill, one of the four accent colors at full saturation background with its matching dark text, 7px/14px padding, 12px text.

**Mini player** — ink-background bar, `16px` radius, always sits directly above the bottom nav. Contains: small `34px` square color-block art, title (cream, 13px) + artist (muted gray, 11px) stacked, play/pause icon on the right. Persists across every screen except sign-in.

**Bottom nav** — ink pill bar, four icons evenly spaced (home, search, library, profile), active icon is cream, inactive icons are `#9A9689`. No labels under icons — icons only.

**Playlist / mood card** — colored block, `14–16px` radius, name in Fraunces 500 dark-on-color, subtitle (song count) in DM Sans 11px same dark-on-color. If the content is synced from Spotify, add a small `ti-brand-spotify` icon top-right at 14px — this is the only place Spotify's presence should be visible to the user.

**List row** (search results, recently played) — 36px square color-block art, title + artist stacked left, duration or metadata right-aligned, `0.5px` hairline divider between rows, no card wrapper.

## Icons

Tabler outline icons only (`ti-home`, `ti-search`, `ti-playlist`, `ti-user`, `ti-player-play`, `ti-player-pause`, `ti-brand-spotify`, `ti-heart`). Never filled icons. Decorative doodle marks (waveforms, blobs) are hand-drawn SVG, not icons — reserve these for empty states and the sign-in illustration, not for functional UI.

## Voice and copy

The app should sound like a calm, thoughtful friend — never a system.

**Do:**
- "Let's find your sound" — not "Sign in to continue"
- "Pick up where you left off" — not "Recently played"
- "Nothing plays until you're ready" — not "Grant permissions to continue"
- "Not now, just let me look around" — not "Skip"
- Playlist names describe a feeling: *Calm mornings, Deep focus, Golden hour, Slow unwind, Rainy day* — not genres like "Chill Pop" or "Lo-fi Beats"

**Don't:**
- No exclamation marks on system copy.
- No "Please" — the app isn't asking a favor.
- No technical language ("sync", "API", "cache", "backend") ever surfaces to the user.
- No empty "Nothing here yet" — empty states should invite an action, e.g. "Nothing saved yet. Search for something and tap the heart."
- Sentence case everywhere. Never Title Case, never ALL CAPS.

## Screen checklist

Every screen (except sign-in) includes, top to bottom:
1. Camera-island bar at the very top of the device (cosmetic, ink color).
2. Screen content (see components above).
3. Mini player (if a track is active).
4. Bottom nav, pinned as the last element.

Keep one accent color "mood" per section — don't mix all four colors into a single row of cards unless they intentionally represent four different moods (as in Home's "Made for your mood" grid).
