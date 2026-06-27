import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/features/auth/bloc/auth_bloc.dart';
import 'package:tsuki/features/auth/data/auth_api.dart';
import 'package:tsuki/features/auth/data/auth_repository.dart';
import 'package:tsuki/app/router/app_routes.dart';
import 'package:tsuki/core/network/api_client.dart';
import 'package:tsuki/core/storage/secure_storage_service.dart';
import 'package:tsuki/features/home/bloc/home_bloc.dart';
import 'package:tsuki/features/home/data/home_api.dart';
import 'package:tsuki/features/home/data/home_repository.dart';
import 'package:tsuki/features/search/bloc/search_bloc.dart';
import 'package:tsuki/features/search/data/search_api.dart';
import 'package:tsuki/features/search/data/search_repository.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            AuthRepository(
              AuthApi(ApiClient().dio),
              storage: SecureStorageService(),
            ),
          ),
        ),

        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(HomeRepository(HomeApi(ApiClient().dio))),
        ),
        BlocProvider(
          create: (_) =>
              SearchBloc(SearchRepository(SearchApi(ApiClient().dio))),
        ),
      ],
      child: MaterialApp.router(routerConfig: appRouter),
    );
  }
}
