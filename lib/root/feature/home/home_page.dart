import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/root/feature/home/bloc/home_bloc.dart';
import 'package:tsuki/root/feature/home/bloc/home_event.dart';
import 'package:tsuki/root/feature/home/bloc/home_state.dart';
import 'package:tsuki/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetFeaturedFeed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.terminalSurface,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeDataLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: state.featured.artists.map((artist) {
                    return Text(artist.name);
                  }).toList(),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
