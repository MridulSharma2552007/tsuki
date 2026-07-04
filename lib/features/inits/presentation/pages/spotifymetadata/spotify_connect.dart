import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpotifyConnect extends StatefulWidget {
  const SpotifyConnect({super.key});

  @override
  State<SpotifyConnect> createState() => _SpotifyConnectState();
}

class _SpotifyConnectState extends State<SpotifyConnect> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://accounts.spotify.com/login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: WebViewWidget(controller: controller),
    );
  }
}
