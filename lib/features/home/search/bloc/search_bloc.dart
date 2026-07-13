import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:tsuki/features/home/search/bloc/search_event.dart';
import 'package:tsuki/features/home/search/bloc/search_state.dart';
import 'package:tsuki/features/home/search/data/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;
  final YoutubeExplode yt = YoutubeExplode();
  final AudioPlayer player = AudioPlayer();

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

  // Call this when a song is tapped
  Future<void> playSong(String videoId) async {
    try {
      final manifest = await yt.videos.streams.getManifest(videoId);
      final audio = manifest.audioOnly.withHighestBitrate();

      print('Playing: ${audio.url}');

      await player.setUrl(audio.url.toString());
      player.play();
    } catch (e) {
      print('Failed to play song: $e');
    }
  }

  @override
  Future<void> close() {
    yt.close();
    player.dispose();
    return super.close();
  }
}
