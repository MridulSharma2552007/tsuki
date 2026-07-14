import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:tsuki/features/home/search/bloc/search_event.dart';
import 'package:tsuki/features/home/search/bloc/search_state.dart';
import 'package:tsuki/features/home/search/data/search_repository.dart';

class _ClientConfig {
  final String name;
  final List<YoutubeApiClient> clients;
  final String userAgent;

  const _ClientConfig({
    required this.name,
    required this.clients,
    required this.userAgent,
  });
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(SearchInitialized()) {
    on<SearchSongs>(_onSearchSongs);
  }

  Future<void> _onSearchSongs(
    SearchSongs event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final results = await repository.search(event.query);
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
