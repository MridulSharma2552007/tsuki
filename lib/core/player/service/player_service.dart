import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlayerService {
  final YoutubeExplode _yt = YoutubeExplode();
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String videoId) async {
    final manifest = await _yt.videos.streams.getManifest(
      videoId,
      ytClients: [YoutubeApiClient.ios, YoutubeApiClient.androidVr],
      requireWatchPage: false,
    );
    // find best audio
    final stream = manifest.audioOnly.withHighestBitrate();
    //stop song
    await player.stop();
    //set url
    await _player.setUrl(stream.url.toString());
    //play
    await _player.play();
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position) => _player.seek(position);

  AudioPlayer get player => _player;

  void dispose() {
    _player.dispose();
    _yt.close();
  }
}
