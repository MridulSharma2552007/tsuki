import 'package:tsuki/root/feature/search/data/models/search_response.dart';
import 'package:tsuki/root/feature/search/data/search_repository.dart';

abstract class SearchState {}

class InitialSearch extends SearchState {}

class SearchLoading extends SearchState {}

class SearchCompleted extends SearchState {
  final List<SearchResponse> response;
  SearchCompleted(this.response);
}
