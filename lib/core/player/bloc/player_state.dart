import 'package:tsuki/core/player/data/model/playing_song.dart';

abstract class PlayerState {}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerPlaying extends PlayerState {
  final PlayingSong song;

  final Duration position;

  final Duration duration;

  PlayerPlaying({
    required this.song,
    required this.position,
    required this.duration,
  });
}

class PlayerPaused extends PlayerState {}

class PlayerError extends PlayerState {
  final String message;

  PlayerError(this.message);
}
