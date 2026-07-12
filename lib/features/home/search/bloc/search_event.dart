abstract class SearchEvent {}

class SearchSongs extends SearchEvent {
  final String query;

  SearchSongs(this.query);
}
