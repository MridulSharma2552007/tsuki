import 'package:tsuki/core/player/data/model/playing_song.dart';

abstract class PlayerEvent {}

class PlaySong extends PlayerEvent {
  final PlayingSong song;

  PlaySong(this.song);
}

class PauseSong extends PlayerEvent {}

class ResumeSong extends PlayerEvent {}

class SeekSong extends PlayerEvent {
  final Duration position;

  SeekSong(this.position);
}

class StopSong extends PlayerEvent {}

class PlayNextSong extends PlayerEvent {}

class PlayPreviousSong extends PlayerEvent {}
