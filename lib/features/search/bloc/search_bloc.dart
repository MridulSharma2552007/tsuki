import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/features/search/bloc/search_event.dart';
import 'package:tsuki/features/search/bloc/search_state.dart';
import 'package:tsuki/features/search/data/search_repository.dart';

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
    on<LoadSearchHistory>((event, emit) async {
      emit(SearchLoading());
      try {
        final response = await repository.getSearchHistory();
        emit(SearchHistoryLoaded(response));
        print(
          "<======================History Loaded=========================>",
        );
      } catch (e) {
        print(e);
      }
    });
    on<AddToSearchHistory>((event, emit) async {
      try {
        await repository.addToSearchHistory(event.song);
        print(
          "<======================Adding To History=========================>",
        );
      } catch (e) {
        print(e);
      }
    });
    on<DeleteHistoryItem>((event, emit) async {
      try {
        await repository.deleteItemSearchHistory(event.song);

        final history = await repository.getSearchHistory();

        add(LoadSearchHistory());
      } catch (e) {
        print(e);
      }
    });
  }
}
