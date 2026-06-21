import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuki/core/storage/secure_storage_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final SecureStorageService storage = SecureStorageService();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            storage.clearTokens();
            context.go('/');
          },
          child: Icon(Icons.clear),
        ),
      ),
    );
  }
}
