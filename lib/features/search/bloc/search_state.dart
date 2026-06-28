import 'package:tsuki/features/search/data/models/search_response.dart';
import 'package:tsuki/features/search/data/search_repository.dart';

abstract class SearchState {}

class InitialSearch extends SearchState {}

class SearchLoading extends SearchState {}

class SearchCompleted extends SearchState {
  final List<SearchResponse> response;
  SearchCompleted(this.response);
}

class SearchHistoryLoaded extends SearchState {
  final List<SearchResponse> history;
  SearchHistoryLoaded(this.history);
}
