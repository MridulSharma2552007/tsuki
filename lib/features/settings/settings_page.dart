import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final player = AudioPlayer();
  final videoIdController = TextEditingController(text: '4aeETEoNfOg');

  String? title;
  String? audioUrl;
  String? errorLog;
  bool isLoading = false;
  bool isPlaying = false;

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    player.positionStream.listen((pos) {
      if (mounted) setState(() => position = pos);
    });
    player.durationStream.listen((dur) {
      if (mounted && dur != null) setState(() => duration = dur);
    });
    player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
        if (state.processingState == ProcessingState.completed) {
          player.seek(Duration.zero);
          player.pause();
        }
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    videoIdController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      isLoading = true;
      errorLog = null;
      title = null;
      audioUrl = null;
    });

    final videoId = videoIdController.text.trim();

    // On Android, the Deno JS solver is not available (no deno binary).
    // Use iOS client which auto-fetches visitorData (required to avoid
    // "Sign in to confirm you're not a bot"). Skip the watch page fetch
    // to avoid the rate-limited GET youtube.com/watch request.
    // The iOS client hits /sw.js_data for visitor data + /youtubei/v1/player.
    final yt = YoutubeExplode();

    try {
      developer.log('Fetching manifest for $videoId...');

      // Use innertube-only clients and disable the watch page fetch.
      // The watch page GET (youtube.com/watch?v=...) is what triggers
      // the rate limit. With requireWatchPage: false, the library only
      // calls /youtubei/v1/player which doesn't get rate-limited.
      // mediaConnect and androidVr return pre-signed URLs (no JS solver needed).
      // Use iOS client (provides visitorData) + androidVr (high quality streams).
      // Multiple clients merge their stream pools — androidVr often has
      // higher bitrate audio than iOS alone.
      final manifest = await yt.videos.streamsClient.getManifest(
        videoId,
        ytClients: [YoutubeApiClient.ios, YoutubeApiClient.androidVr],
        requireWatchPage: false,
      );

      final audioStreams = manifest.audioOnly.toList()
        ..sort((a, b) => b.bitrate.compareTo(a.bitrate));
      if (audioStreams.isEmpty) {
        throw Exception('No audio-only streams found for this video');
      }

      final best = audioStreams.first;
      final url = best.url.toString();

      developer.log(
        'Available audio streams: ${audioStreams.map((s) => '${s.bitrate.kiloBitsPerSecond}kbps ${s.container.name} ${s.audioCodec}').join(', ')}',
      );
      developer.log(
        'Selected: ${best.bitrate.kiloBitsPerSecond} kbps, ${best.container.name}, ${best.audioCodec}',
      );

      // Skip yt.videos.get() — it fetches the watch page which triggers
      // the same rate limit. Just use the video ID as display text.
      final videoTitle = 'Playing: $videoId';

      await player.setUrl(url);

      setState(() {
        title = videoTitle;
        audioUrl = url;
        isLoading = false;
      });
    } catch (e, stack) {
      developer.log('Error: $e', error: e, stackTrace: stack);
      setState(() {
        errorLog = e.toString();
        isLoading = false;
      });
    } finally {
      yt.close();
    }
  }

  Future<void> _togglePlay() async {
    if (audioUrl == null) return;
    try {
      if (isPlaying) {
        await player.pause();
      } else {
        await player.play();
      }
    } catch (e, stack) {
      developer.log('Play error: $e', error: e, stackTrace: stack);
      setState(() => errorLog = 'Playback error: $e');
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YT Audio Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: videoIdController,
              decoration: const InputDecoration(
                labelText: 'YouTube Video ID',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: isLoading ? null : _load,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(isLoading ? 'Loading...' : 'Load & Play'),
            ),
            const SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '✓ Direct innertube API (no watch page)',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.green),
              ),
            ],
            const SizedBox(height: 24),
            if (audioUrl != null) ...[
              // Seek bar
              Slider(
                value: position.inMilliseconds
                    .clamp(
                      0,
                      duration.inMilliseconds > 0 ? duration.inMilliseconds : 1,
                    )
                    .toDouble(),
                max: duration.inMilliseconds > 0
                    ? duration.inMilliseconds.toDouble()
                    : 1.0,
                onChanged: (value) {
                  player.seek(Duration(milliseconds: value.toInt()));
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(position),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      _formatDuration(duration),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                iconSize: 64,
                onPressed: _togglePlay,
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
              ),
            ],
            if (errorLog != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  errorLog!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
