import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SpotifyConnect extends StatefulWidget {
  const SpotifyConnect({super.key});

  @override
  State<SpotifyConnect> createState() => _SpotifyConnectState();
}

class _SpotifyConnectState extends State<SpotifyConnect> {
  InAppWebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://accounts.spotify.com/login"),
        ),

        onWebViewCreated: (c) {
          controller = c;
        },

        onLoadStop: (controller, url) async {
          print("Loaded: $url");

          // Read cookies for Spotify Accounts
          final cookies = await CookieManager.instance().getCookies(
            url: WebUri("https://accounts.spotify.com"),
          );

          print("========== COOKIES ==========");

          for (final cookie in cookies) {
            print("${cookie.name} = ${cookie.value}");
          }

          print("=============================");
        },
      ),
    );
  }
}
