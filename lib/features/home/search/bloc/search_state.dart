import 'package:tsuki/features/home/search/data/models/search_model.dart';

abstract class SearchState {}

class SearchInitialized extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchModel> results;

  SearchLoaded(this.results);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
