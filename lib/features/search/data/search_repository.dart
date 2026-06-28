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

  //impossible to edit hive items directly so converting to json to list to json and putting back in hive
  Future<void> addToSearchHistory(SearchResponse song) async {
    final historyBox = Hive.box('search_history');
    final historykey = 'search_history';

    //get existing data as json

    final json = await historyBox.get(historykey);

    //convert to list
    List<dynamic> history = [];

    if (json != null) {
      history = jsonDecode(json);
    }
    //remove duplicate one with same id
    history.removeWhere((e) => e['id'] == song.id);

    //add new one on top
    history.insert(0, song.toJson());
    //put back to hive
    await historyBox.put(historykey, jsonEncode(history));
  }

  Future<List<SearchResponse>> getSearchHistory() async {
    final historyBox = Hive.box('search_history');
    final historykey = 'search_history';
    final json = historyBox.get(historykey);

    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((e) => SearchResponse.fromJson(e)).toList();
  }

  Future<void> deleteItemSearchHistory(SearchResponse song) async {
    final historyBox = Hive.box('search_history');
    final historykey = 'search_history';

    final json = await historyBox.get(historykey);
    List<dynamic> history = [];
    if (json != null) {
      history = jsonDecode(json);
    }
    history.removeWhere((e) => e['id'] == song.id);
    await historyBox.put(historykey, jsonEncode(history));
  }
}
