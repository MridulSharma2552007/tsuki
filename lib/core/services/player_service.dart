import 'package:media_kit/media_kit.dart';
import 'package:tsuki/core/services/yt_music_extractor_Service.dart';

class PlayerService {
  PlayerService._();

  static final PlayerService instance = PlayerService._();

  final Player player = Player();
  Future<void> play(AudioSourceResult source) async {
    await player.stop();
    await player.open(Media(source.source));
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> seek(Duration position) async {
    await player.seek(position);
  }
}
