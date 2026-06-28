import 'package:tsuki/features/search/data/models/search_response.dart';

abstract class SearchEvent {}

class Search extends SearchEvent {
  final String q;
  Search({required this.q});
}

class LoadSearchHistory extends SearchEvent {}

class AddToSearchHistory extends SearchEvent {
  final SearchResponse song;

  AddToSearchHistory({required this.song});
}
