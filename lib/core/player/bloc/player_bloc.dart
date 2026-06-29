import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/core/player/bloc/player_event.dart';
import 'package:tsuki/core/player/bloc/player_state.dart';
import 'package:tsuki/core/player/data/player_repository.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayerRepository repository;

  PlayerBloc(this.repository) : super(PlayerInitial()) {
    on<PlaySong>(_playSong);
    on<PauseSong>(_pauseSong);
    on<ResumeSong>(_resumeSong);
    on<SeekSong>(_seekSong);
    on<StopSong>(_stopSong);
    on<PlayNextSong>(_playNextSong);
    on<PlayPreviousSong>(_playPreviousSong);
  }

  Future<void> _playSong(PlaySong event, Emitter<PlayerState> emit) async {
    try {
      emit(PlayerLoading());

      await repository.play(event.song);

      emit(
        PlayerPlaying(
          song: event.song,
          position: Duration.zero,
          duration: Duration.zero,
        ),
      );
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> _pauseSong(PauseSong event, Emitter<PlayerState> emit) async {
    await repository.pause();
  }

  Future<void> _resumeSong(ResumeSong event, Emitter<PlayerState> emit) async {
    await repository.resume();
  }

  Future<void> _seekSong(SeekSong event, Emitter<PlayerState> emit) async {
    await repository.seek(event.position);
  }

  Future<void> _stopSong(StopSong event, Emitter<PlayerState> emit) async {
    await repository.stop();

    emit(PlayerInitial());
  }

  Future<void> _playNextSong(
    PlayNextSong event,
    Emitter<PlayerState> emit,
  ) async {
    // TODO: Queue later
  }

  Future<void> _playPreviousSong(
    PlayPreviousSong event,
    Emitter<PlayerState> emit,
  ) async {
    // TODO: Queue later
  }
}
