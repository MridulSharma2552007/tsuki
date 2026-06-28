import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuki/features/search/data/models/search_response.dart';
import 'package:tsuki/features/search/data/search_api.dart';

class SearchRepository {
  final _box = Hive.box('search_cache');
  static const _cacheDuration = Duration(days: 4);

  final SearchApi api;

  //for local Lookupkey
  String _normalize(String query) =>
      query.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  SearchRepository(this.api);

  Future<List<SearchResponse>> Search(String q) async {
    final key = _normalize(q);
    if (key.isEmpty) {
      return [];
    }
    final entry = _box.get(key) as Map?;
    final isStale =
        entry == null ||
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(entry['cachedAt'] as int),
            ) >
            _cacheDuration;
    if (!isStale) {
      final songs = jsonDecode(entry['data'] as String) as List<dynamic>;
      return songs
          .map((e) => SearchResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    final data = await api.search(q);
    final songs = data['songs'] as List<dynamic>;
    await _box.put(key, {
      'data': jsonEncode(songs),
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    });
    return songs
        .map((e) => SearchResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
