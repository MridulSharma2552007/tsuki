import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tsuki/core/config/env.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final player = AudioPlayer();
  final apiHostController = TextEditingController();
  final videoIdController = TextEditingController(text: '4aeETEoNfOg');
  final cookieController = TextEditingController();

  String? title;
  String? audioUrl;
  String? errorLog;
  bool isLoading = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    apiHostController.text = Env.baseUrl;
  }

  @override
  void dispose() {
    player.dispose();
    apiHostController.dispose();
    videoIdController.dispose();
    cookieController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      isLoading = true;
      errorLog = null;
      title = null;
      audioUrl = null;
    });

    try {
      final host = apiHostController.text.trim();
      final videoId = videoIdController.text.trim();
      final cookies = cookieController.text.trim();

      final dio = Dio(BaseOptions(
        baseUrl: host,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      ));

      developer.log('Fetching playable URL for $videoId...');
      final response = await dio.post(
        '/stream/playable',
        data: {
          'videoId': videoId,
          if (cookies.isNotEmpty) 'cookies': cookies,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('error')) {
        throw Exception(data['error']);
      }

      final url = data['url'] as String;
      developer.log('Got audio URL: $url');

      setState(() {
        title = data['title'] as String? ?? 'Unknown';
        audioUrl = url;
        isLoading = false;
      });
    } catch (e, stack) {
      developer.log('Error: $e', error: e, stackTrace: stack);
      setState(() {
        errorLog = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _togglePlay() async {
    if (audioUrl == null) return;
    try {
      if (isPlaying) {
        await player.pause();
      } else {
        await player.setUrl(audioUrl!);
        await player.play();
      }
      setState(() => isPlaying = !isPlaying);
    } catch (e, stack) {
      developer.log('Play error: $e', error: e, stackTrace: stack);
      setState(() => errorLog = 'Playback error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YT Player')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: apiHostController,
              decoration: const InputDecoration(
                labelText: 'API Endpoint',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: videoIdController,
              decoration: const InputDecoration(
                labelText: 'YouTube Video ID',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cookieController,
              decoration: const InputDecoration(
                labelText: 'Cookies (optional)',
                hintText: 'name=value; name2=value2',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              maxLines: 2,
              minLines: 1,
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
              label: Text(isLoading ? 'Loading...' : 'Load'),
            ),
            const SizedBox(height: 24),
            if (title != null)
              Text(title!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            if (audioUrl != null)
              IconButton(
                iconSize: 64,
                onPressed: _togglePlay,
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                ),
              ),
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
