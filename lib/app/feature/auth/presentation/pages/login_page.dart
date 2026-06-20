import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tsuki/core/config/env.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String message = 'Not tested';
  @override
  void initState() {
    super.initState();
    _login();
  }

  Future<void> _login() async {
    try {
      final dio = Dio();

      final response = await dio.get('${Env.baseUrl}/health');

      print(response.data);

      setState(() {
        message = response.data['message'];
      });
    } catch (e) {
      print(e);

      setState(() {
        message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(message)));
  }
}
