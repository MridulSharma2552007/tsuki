import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YtMusicExtractorService {
  YtMusicExtractorService._();

  static final YtMusicExtractorService instance = YtMusicExtractorService._();

  final YoutubeExplode _yt = YoutubeExplode();

  static final _clients = [
    _ClientConfig(
      name: 'androidSdkless',
      clients: [],
      userAgent:
          'com.google.android.youtube/20.10.38 (Linux; U; Android 11) gzip',
    ),
    _ClientConfig(
      name: 'androidVr',
      clients: [YoutubeApiClient.androidVr],
      userAgent:
          'com.google.android.apps.youtube.vr.oculus/1.56.21 '
          '(Linux; U; Android 12; Quest 3) gzip',
    ),
    _ClientConfig(
      name: 'ios',
      clients: [YoutubeApiClient.ios],
      userAgent:
          'com.google.ios.youtube/20.10.4 '
          '(iPhone16,2; U; CPU iOS 18_3_2 like Mac OS X;)',
    ),
    _ClientConfig(
      name: 'tv',
      clients: [YoutubeApiClient.tv],
      userAgent: 'Mozilla/5.0 (ChromiumStylePlatform) Cobalt/Version,gzip(gfe)',
    ),
  ];

  Future<AudioSourceResult> getPlayableSource(String videoId) async {
    print('══════════════════════════════════════════');
    print('[YT] Extracting $videoId');

    for (final config in _clients) {
      print('\n── Trying ${config.name} ──');

      StreamManifest? manifest;

      try {
        if (config.clients.isEmpty) {
          manifest = await _yt.videos.streams.getManifest(videoId);
        } else {
          manifest = await _yt.videos.streams.getManifest(
            videoId,
            ytClients: config.clients,
          );
        }
      } catch (e) {
        print('Manifest failed: $e');
        continue;
      }

      if (manifest.audioOnly.isEmpty) {
        continue;
      }

      final stream = manifest.audioOnly.withHighestBitrate();

      print(
        'Selected ${stream.audioCodec} '
        '${stream.bitrate.bitsPerSecond}bps',
      );

      //
      // Try direct URL first
      //
      try {
        final response = await http
            .head(stream.url, headers: {'User-Agent': config.userAgent})
            .timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          print('✓ Direct URL works');

          return AudioSourceResult(
            source: stream.url.toString(),
            isFile: false,
          );
        }
      } catch (_) {}

      //
      // Download fallback
      //
      try {
        final extension = stream.container.name;

        final file = File(
          '${Directory.systemTemp.path}/'
          'audio_${config.name}_$videoId.$extension',
        );

        final response = await http
            .get(stream.url, headers: {'User-Agent': config.userAgent})
            .timeout(const Duration(seconds: 15));

        if (response.statusCode != 200) {
          continue;
        }

        if (response.bodyBytes.length < 10000) {
          continue;
        }

        await file.writeAsBytes(response.bodyBytes);

        print('✓ Download fallback');

        return AudioSourceResult(source: file.path, isFile: true);
      } catch (e) {
        print('Download failed: $e');
      }
    }

    throw Exception('Unable to extract playable source.');
  }

  void dispose() {
    _yt.close();
  }
}

class AudioSourceResult {
  final String source;
  final bool isFile;

  const AudioSourceResult({required this.source, required this.isFile});
}

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
