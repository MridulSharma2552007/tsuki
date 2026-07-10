import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SpotifyConnect extends StatefulWidget {
  const SpotifyConnect({super.key});

  @override
  State<SpotifyConnect> createState() => _SpotifyConnectState();
}

class _SpotifyConnectState extends State<SpotifyConnect> {
  InAppWebViewController? controller;
  final bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spotify Token Grabber"),
        bottom: _isProcessing 
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4.0), 
                child: LinearProgressIndicator()
              ) 
            : null,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://accounts.spotify.com/login"),
        ),
        onWebViewCreated: (c) {
          controller = c;
        },
        
        // -------------------------------------------------------------------------
        // CRITICAL STEP: Intercept the active network traffic to catch the token response!
        // -------------------------------------------------------------------------
        shouldInterceptRequest: (controller, request) async {
          final urlString = request.url.toString();

          // Check if this network request is the one fetching the core authentication tokens
          if (urlString.contains('/api/token')) {
            print("[*] Caught Spotify Token Request: $urlString");
            
            // Give the webview a brief millisecond window to finish getting the response data
            Future.delayed(const Duration(milliseconds: 500), () async {
              try {
                // Read the token directly from Spotify's local window performance logs or storage configurations
                final String? sessionData = await controller.evaluateJavascript(
                  source: """
                    (function() {
                      // Look for the specific configuration block Spotify attaches to the web view DOM layout
                      var configElement = document.getElementById('session') || document.getElementById('config');
                      if (configElement) {
                        return configElement.textContent;
                      }
                      return null;
                    })();
                  """
                );

                if (sessionData != null && sessionData.isNotEmpty) {
                  print("=======================================================");
                  print("[+] TOKENS FOUND IN RUNTIME TEXT DOM:");
                  print(sessionData);
                  print("=======================================================");
                }
              } catch (e) {
                print("[-] Failed to evaluate live storage layout: $e");
              }
            });
          }
          return null; // Return null so the webview continues loading the page normally
        },

        onLoadStop: (controller, url) async {
          print("Loaded Canvas: $url");

          // Fallback backup: Look inside Spotify's internal runtime playback configuration object
          try {
            final String? tokenViaJs = await controller.evaluateJavascript(source: """
              (function() {
                try {
                  // Attempt to read the loaded access token configuration out of Spotify's internal object tree
                  return Spotify.Entity.Player._auth._token || Spotify.Utils.Auth.getAccessToken();
                } catch(e) {
                  return null;
                }
              })();
            """);

            if (tokenViaJs != null) {
              print("=======================================================");
              print("[+] FOUND ACCESS TOKEN VIA RUNTIME INJECTION:");
              print("Bearer Token: $tokenViaJs");
              print("=======================================================");
            }
          } catch (_) {}
        },
      ),
    );
  }
}