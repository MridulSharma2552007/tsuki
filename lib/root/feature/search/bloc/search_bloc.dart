import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/root/feature/search/bloc/search_event.dart';
import 'package:tsuki/root/feature/search/bloc/search_state.dart';
import 'package:tsuki/root/feature/search/data/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(InitialSearch()) {
    on<Search>((event, emit) async {
      emit(SearchLoading());
      try {
        final response = await repository.Search(event.q);
        emit(SearchCompleted(response));
      } catch (e) {
        print(e);
      }
    });
  }
}
