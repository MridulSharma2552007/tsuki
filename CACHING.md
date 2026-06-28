# Caching

Tsuki stores some data locally on your device so the app loads faster and works even when you're offline or have a slow connection.

---

## What's cached & for how long

| Data | Duration | Why |
|---|---|---|
| **Home feed** (featured albums & artists) | **5 days** | The featured home screen doesn't change often, so it can be safely reused for almost a week. |
| **Search results** | **4 days** | Song search results are cached per query so repeating a search is instant. |
| **Album/artist artwork** | **~30 days** | Thumbnails and cover images are cached automatically by the image library Tsuki uses. |
| **Search history** | **Forever** | Your recent searches are saved until you clear them — there's no expiration. |

---

## How it works

- **Home**: When you open the app, it shows you the last saved home feed right away, even if it's old. If it's been more than 5 days, it refreshes the feed in the background — you'll see the updated content next time you visit.
- **Search**: The first time you search for something, it fetches results from the server and saves them for 4 days. If you search for the same thing again within 4 days, you get instant results with no loading.
- **Images**: Album art and artist pictures are downloaded once and reused for about a month.

---

## Force refresh

- Pull-to-refresh on the home screen to get the latest featured feed immediately.
- There's no way to manually clear caches from within the app yet.
