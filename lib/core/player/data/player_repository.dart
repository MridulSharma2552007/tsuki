import 'package:tsuki/core/player/data/model/playing_song.dart';
import 'package:tsuki/core/player/service/player_service.dart';

class PlayerRepository {
  final PlayerService service;

  PlayerRepository(this.service);

  Future<void> play(PlayingSong song) async {
    await service.play(song.id);
  }

  Future<void> pause() async {
    await service.pause();
  }

  Future<void> resume() async {
    await service.resume();
  }

  Future<void> stop() async {
    await service.stop();
  }

  Future<void> seek(position) async {
    await service.seek(position);
  }
}
