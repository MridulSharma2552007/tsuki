abstract class SearchEvent {}

class Search extends SearchEvent {
  final String q;
  Search({required this.q});
}
