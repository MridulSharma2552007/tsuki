# Spotify Private API Authentication — Spec

## Overview

The whole point of this flow is to trade a **long-lived login cookie** (`sp_dc`) for a **short-lived streaming key** (Access Token), without going through Spotify's official developer portal.

Think of it as a relay race with 4 legs:

1. **Login once** → get a cookie
2. **Ask for a fingerprint** → get a Client-Token
3. **Swap everything for a key** → get an Access Token
4. **Stream with the key** → refresh before it expires

```
Login (once)
   │
   ▼
sp_dc cookie ──────────────┐
                            │
Client-Token request ──►  Client-Token
                            │
sp_dc + Client-Token + TOTP ──► Access Token (valid ~60 min)
                            │
                            ▼
                     Stream music
                            │
                  (5 min before expiry)
                            │
                            ▼
                    Loop back to Client-Token step
```

---

## Phase 1 — Login (one-time)

- User logs in through a WebView inside the app, exactly like a normal Spotify login.
- The app intercepts the response and pulls out one cookie: **`sp_dc`**.
- This cookie is long-lived — it's the "master key" the rest of the flow depends on. Store it securely (encrypted local storage, not plaintext prefs).

---

## Phase 2 — The Refresh Loop (every 50–60 minutes)

This is the part that runs silently in the background to keep the user's stream alive.

### Step A: Get a Client-Token (device fingerprint)

Spotify wants proof the request is coming from a "real" client, so you ask for a token that represents your app/device.

```
POST https://clienttoken.spotify.com/v1/clienttoken
Content-Type: application/json
User-Agent: Mozilla/5.0 (X11; Linux x86_64...)
```

**Request body:**
```json
{
  "client_data": {
    "client_version": "1.2.94.384.g4876140a",
    "client_id": "d8a5ed958d274c2e8ee717e6a4b0971d",
    "js_sdk_data": {
      "device_brand": "unknown",
      "device_model": "unknown",
      "os": "linux",
      "os_version": "unknown",
      "device_id": "0d9174c4-9739-4a8b-b4a0-2e90c9188c79",
      "device_type": "computer"
    }
  }
}
```

**Response:**
```json
{
  "response_type": "RESPONSE_GRANTED_TOKEN_RESPONSE",
  "granted_token": {
    "token": "AAFp1lbJXlKlKRN1iLBoRUFZK0l6PNXMFjiVCSZqwmLMiWelC8...",
    "expires_after_seconds": 1216800
  }
}
```

> This token lives much longer than the Access Token (weeks), so you don't need to fetch it every cycle — just cache it and reuse it until it's close to expiry.

### Step B: Generate a TOTP code locally

A 6-digit code generated on-device (like a 2FA app would), using the current `totp_version` and secret parameters. No network call needed for this step — it's pure local computation.

### Step C: Trade everything for the Access Token

```
GET https://open.spotify.com/api/token
    ?reason=init
    &productType=web-player
    &totp=396950
    &totpServer=396950
    &totpVer=9

Cookie: sp_dc=[YOUR_CAPTURED_WEBVIEW_COOKIE]
Client-Token: [TOKEN_FROM_STEP_A]
User-Agent: Mozilla/5.0 (X11; Linux x86_64...)
Accept: application/json
```

**Response:**
```json
{
  "clientId": "d8a5ed958d274c2e8ee717e6a4b0971d",
  "accessToken": "BQBRUUmfH5CGOPXmpfWhCvxyRuyv7Kpyi4...",
  "accessTokenExpirationTimestampMs": 1783532050328,
  "isAnonymous": false
}
```

This `accessToken` is what you actually use in your `Authorization: Bearer ...` header to hit the streaming/playback endpoints.

---

## Phase 3 — Streaming

- Use `accessToken` for all playback requests for up to 60 minutes.
- Watch `accessTokenExpirationTimestampMs`.
- **5 minutes before expiry**, silently re-run Step A → Step C (Step A only if the cached Client-Token is also close to expiry) so playback never stalls mid-song.

---

## Implementation Notes

| Concern | Recommendation |
|---|---|
| Hardcoded values break easily | Pull `client_id`, `client_version`, and `totp_version` from a remote JSON config (e.g. hosted on GitHub) so you can patch them without a full app release when Spotify changes something |
| `sp_dc` storage | Encrypt at rest; treat it like a password, not a normal pref |
| Token refresh timing | Trigger refresh **5 min before** `accessTokenExpirationTimestampMs`, not on expiry — avoids playback gaps |
| Client-Token lifespan | ~14 days (`expires_after_seconds` ≈ 1,216,800s) — cache separately from the Access Token, which only lasts ~60 min |
| Failure handling | If `sp_dc` is invalidated (user changed password, logged out elsewhere, etc.), the whole loop breaks — you'll need to detect a 401 here and prompt re-login |

---

### Worth flagging

This flow uses Spotify's **undocumented internal/private API**, not their public Web API — it works by having the app impersonate the official web client (same headers, same TOTP scheme, same endpoints the browser uses). That's outside Spotify's Developer Terms, and they've actively cracked down on apps built this way in the past (rate limiting, `sp_dc` invalidation, or IP-level blocks). Worth keeping in mind for something you plan to ship or distribute widely, versus a personal/local build.