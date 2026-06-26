import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/root/feature/home/bloc/home_bloc.dart';
import 'package:tsuki/root/feature/home/bloc/home_event.dart';
import 'package:tsuki/root/feature/home/bloc/home_state.dart';
import 'package:tsuki/root/feature/home/widgets/artist_home_big.dart';
import 'package:tsuki/root/feature/home/widgets/featured_artist.dart';
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
              child: Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[Featured]',
                      style: TextStyle(
                        color: AppColors.terminalAmber,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    FeaturedArtist(artists: state.featured.artists),
                  ],
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
