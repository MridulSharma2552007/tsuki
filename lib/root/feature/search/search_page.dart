import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/root/feature/home/widgets/song_tile_small.dart';
import 'package:tsuki/root/feature/search/bloc/search_bloc.dart';
import 'package:tsuki/root/feature/search/bloc/search_event.dart';
import 'package:tsuki/root/feature/search/bloc/search_state.dart';
import 'package:tsuki/utils/app_colors.dart';
import 'package:tsuki/widgets/tsuki_loader.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.terminalSurface,
      body: Column(
        children: [
          SearchBar(
            controller: controller,
            onTap: () {
              context.read<SearchBloc>().add(Search(q: controller.text));
            },
          ),

          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const TsukiLoader();
                }
                if (state is SearchCompleted) {
                  return ListView.builder(
                    itemCount: state.response.length,
                    itemBuilder: (context, index) {
                      final song = state.response[index];
                      return SongTileSmall(
                        title: song.title,
                        artist: song.artist,
                        thumbnail: song.thumbnail,
                        duration: song.duration,
                        id: song.id,
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key, required this.controller, required this.onTap});

  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextField(
        onSubmitted: (_) => onTap(),
        controller: controller,
        style: const TextStyle(
          color: AppColors.terminalAmber,
          fontFamily: 'Courier',
          fontSize: 14,
        ),
        cursorColor: AppColors.terminalAmber,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(
            color: AppColors.terminalAmber.withOpacity(0.4),
            fontFamily: 'Courier',
            letterSpacing: 2,
          ),
          filled: true,
          fillColor: AppColors.terminalSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: AppColors.terminalAmber, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: AppColors.terminalAmber, width: 2),
          ),
          prefixText: '> ',
          prefixStyle: const TextStyle(
            color: AppColors.terminalAmber,
            fontFamily: 'Courier',
          ),
        ),
      ),
    );
  }
}
