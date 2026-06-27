import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final player = AudioPlayer();
  final apiHostController =
      TextEditingController(text: 'https://YOUR_API_ID.execute-api.ap-south-1.amazonaws.com');
  final videoIdController = TextEditingController(text: '4aeETEoNfOg');

  String? title;
  String? audioUrl;
  String? errorLog;
  bool isLoading = false;
  bool isPlaying = false;

  @override
  void dispose() {
    player.dispose();
    apiHostController.dispose();
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

    try {
      final host = apiHostController.text.trim();
      final videoId = videoIdController.text.trim();

      developer.log('Fetching playable URL for $videoId...');
      final response = await http
          .post(
            Uri.parse('$host/stream/playable'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'videoId': videoId}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode} ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

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
