# Spotify Web Player - Reverse Engineering Notes

## Without Login (Anonymous)

### Token Endpoint

```
GET https://open.spotify.com/api/token?reason=init&productType=web-player&totp=<TOTP>&totpServer=<TOTP>&totpVer=61
```

### Required Cookies

| Cookie | Value |
|--------|-------|
| `OptanonAlertBoxClosed` | `2026-07-08T16:11:51.274Z` |
| `OptanonConsent` | `isGpcEnabled=0&datestamp=...&version=202601.2.0&...` |
| `sp_gaid` | `0088fc0404e9bee352eb0b7136674721ca330ee451c663d851e1a8` |
| `sp_landing` | `https://open.spotify.com/` |
| `sp_landingref` | `https://www.google.com/` |
| `sp_t` | `0d9174c4-9739-4a8b-b4a0-2e90c9188c79` |

### Response

```json
{
  "clientId": "d8a5ed958d274c2e8ee717e6a4b0971d",
  "accessToken": "BQA6qinAP5mhVKUIa1NDqQ4aykNoHAyhCnvrnjv3ng8CJh9yLAnd0-XWA_BLEdQACJ6dM1hp9TLLW-asDMOYW0tB86sEPzIzC58Q6eXZMeCwmygl-yxlMviSYpUaVUidkoISAvDBaGNt",
  "accessTokenExpirationTimestampMs": 1783834014356,
  "isAnonymous": true,
  "_notes": "Usage of this endpoint is not permitted under the Spotify Developer Terms and Developer Policy, and applicable law"
}
```

---

### Client Token Endpoint

```
POST https://clienttoken.spotify.com/v1/clienttoken
```

### Request Body

```json
{
  "client_data": {
    "client_version": "1.2.95.68.g4f513a82",
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

### Response

```json
{
  "response_type": "RESPONSE_GRANTED_TOKEN_RESPONSE",
  "granted_token": {
    "token": "AAEGYzky+...",
    "expires_after_seconds": 1216800,
    "refresh_after_seconds": 1209600,
    "domains": [
      { "domain": "spotify.com" },
      { "domain": "spotify.net" }
    ]
  }
}
```

---

## With Login (Authenticated)

### Token Endpoint

```
GET https://open.spotify.com/api/token?reason=init&productType=web-player&totp=<TOTP>&totpServer=<TOTP>&totpVer=61
```

### Required Cookies

| Cookie | Value |
|--------|-------|
| `OptanonAlertBoxClosed` | `2026-07-08T16:11:51.274Z` |
| `OptanonConsent` | `isGpcEnabled=0&datestamp=...&version=202601.2.0&...` |
| `sp_dc` | `AQA2zZcFMP9TjqMrIZCFU8ON9Y12fviF-...` |
| `sp_gaid` | `0088fc0404e9bee352eb0b7136674721ca330ee451c663d851e1a8` |
| `sp_key` | `7d5930d2-610d-4d49-a7e2-69ccd455317e` |
| `sp_landing` | `https://open.spotify.com/` |
| `sp_landingref` | `https://www.google.com/` |
| `sp_t` | `0d9174c4-9739-4a8b-b4a0-2e90c9188c79` |

### Response

```json
{
  "clientId": "d8a5ed958d274c2e8ee717e6a4b0971d",
  "accessToken": "BQAKqGFtzlShKaxzogkUWjRKgGKVD1eIqVP5s51mRTFWXT4sURJZBkUbv3X1lDlM6s1f_jkqLiHSBymiHyBOLgPdhS9pr4txkLkMxMzls-O7zDlXLizFqDdvv0slm-pNjvFNimKw2gENJSUXOnq-chuYWk2_EPPxci8ecGp9hdUd1OOrXuQPa8YI0VtIik2OAW9e6DRwFnYnYdOjdDPZxxh_x94tHM0XVTUeaDHoNc3zLKKnhMjiqExpipOOX_1JkrSM4yJNf0AMsvqG8wZuQPdpFOdFLTB7Uv2SLyINucwbhyitxGKynu3MjptAEXWLOb0O-bhjSb9t2Qn0ovDMHhYNj7fFGkjK3Q9y2t1iAWeQX7tN5Yp9ckmk52ZpmI3jhyZ2PcHLDN51V8DRaAM",
  "accessTokenExpirationTimestampMs": 1783834844681,
  "isAnonymous": false,
  "_notes": "Usage of this endpoint is not permitted under the Spotify Developer Terms and Developer Policy, and applicable law"
}
```

---

### Client Token Endpoint (Authenticated)

```
POST https://clienttoken.spotify.com/v1/clienttoken
```

### Request Body

```json
{
  "client_data": {
    "client_version": "1.2.95.69.g811550d2",
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

### Response

```json
{
  "response_type": "RESPONSE_GRANTED_TOKEN_RESPONSE",
  "granted_token": {
    "token": "AAH2IVMJ62V1jUI9YjJkbu/...",
    "expires_after_seconds": 1216800,
    "refresh_after_seconds": 1209600,
    "domains": [
      { "domain": "spotify.com" },
      { "domain": "spotify.net" }
    ]
  }
}
```

---

## Findings

- **TOTP** - Likely generated server-side; the server-side TOTP and device-local TOTP should match.
- **TOTP Version** - Always `61`.
- **Client ID** - Static across all requests:
  ```
  d8a5ed958d274c2e8ee717e6a4b0971d
  ```
