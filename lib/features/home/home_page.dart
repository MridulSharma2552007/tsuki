import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/features/home/bloc/home_bloc.dart';
import 'package:tsuki/features/home/bloc/home_event.dart';
import 'package:tsuki/features/home/bloc/home_state.dart';
import 'package:tsuki/features/home/widgets/featured_album.dart';
import 'package:tsuki/features/home/widgets/featured_artist.dart';
import 'package:tsuki/features/home/widgets/featured_songs.dart';
import 'package:tsuki/core/theme/app_colors.dart';
import 'package:tsuki/core/widgets/tsuki_loader.dart';

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
            return TsukiLoader();
          }

          if (state is HomeDataLoaded) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
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
                      SizedBox(height: 20),
                      Text(
                        '[Featured Albums]',
                        style: TextStyle(
                          color: AppColors.terminalAmber,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                      FeaturedAlbum(albums: state.featured.albums),
                      SizedBox(height: 20),
                      Text(
                        "[Featured Songs]",
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.terminalAmber,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: FeaturedSongs(songs: state.featured.songs),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
