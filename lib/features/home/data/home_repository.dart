import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:tsuki/features/home/data/home_api.dart';
import 'package:tsuki/features/home/data/model/featured_response.dart';

class HomeRepository {
  final _box = Hive.box('home_cache');
  static const _cacheKey = 'home_data';
  static const _cachedAtKey = 'cached_at';
  static const _cacheDuration = Duration(days: 5);

  final HomeApi api;

  HomeRepository(this.api);

  Future<FeaturedResponse> getFeaturedFeed() async {
    final cached = _box.get(_cacheKey);
    final cachedAtMillis = _box.get(_cachedAtKey) as int?;

    final isStale =
        cached == null ||
        cachedAtMillis == null ||
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(cachedAtMillis),
            ) >
            _cacheDuration;

    if (!isStale) {
      return FeaturedResponse.fromJson(jsonDecode(cached));
    }

    // Stale-while-revalidate: show old data instantly if we have it,
    // refresh in the background instead of making the user wait.
    if (cached != null) {
      _refreshInBackground();
      return FeaturedResponse.fromJson(jsonDecode(cached));
    }

    // No cache at all (first launch) — must fetch synchronously.
    return _fetchAndCache();
  }

  Future<FeaturedResponse> _fetchAndCache() async {
    final data = await api.getfeaturedFeed();
    await _box.put(_cacheKey, jsonEncode(data));
    await _box.put(_cachedAtKey, DateTime.now().millisecondsSinceEpoch);
    return FeaturedResponse.fromJson(data);
  }

  void _refreshInBackground() {
    _fetchAndCache(); // fire and forget
  }
}
