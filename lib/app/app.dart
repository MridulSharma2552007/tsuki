import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_bloc.dart';
import 'package:tsuki/app/feature/auth/data/auth_api.dart';
import 'package:tsuki/app/feature/auth/data/auth_repository.dart';
import 'package:tsuki/app/router/app_routes.dart';
import 'package:tsuki/core/network/api_client.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(
        AuthRepository(AuthApi(ApiClient().dio)),
      ),
      child: MaterialApp.router(routerConfig: appRouter),
    );
  }
}
