import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/core/player/bloc/player_bloc.dart';
import 'package:tsuki/core/player/bloc/player_event.dart';
import 'package:tsuki/core/player/data/model/playing_song.dart';
import 'package:tsuki/features/home/widgets/song_tile_small.dart';
import 'package:tsuki/features/search/bloc/search_bloc.dart';
import 'package:tsuki/features/search/bloc/search_event.dart';
import 'package:tsuki/features/search/bloc/search_state.dart';
import 'package:tsuki/core/theme/app_colors.dart';
import 'package:tsuki/core/widgets/tsuki_loader.dart';
import 'package:tsuki/features/search/widgets/history_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<SearchBloc>().add(LoadSearchHistory());
  }

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
                if (state is SearchHistoryLoaded) {
                  return ListView.builder(
                    itemCount: state.history.length,
                    itemBuilder: (context, index) {
                      final history = state.history[index];
                      return HistoryTile(
                        key: ValueKey(history.id),
                        title: history.title,
                        artist: history.artist,
                        thumbnail: history.thumbnail,
                        duration: history.duration,
                        id: history.id,
                        onPress: () {
                          context.read<SearchBloc>().add(
                            DeleteHistoryItem(song: history),
                          );
                        },
                      );
                    },
                  );
                }
                if (state is SearchLoading) {
                  return const TsukiLoader();
                }
                if (state is SearchCompleted) {
                  return ListView.builder(
                    itemCount: state.response.length,
                    itemBuilder: (context, index) {
                      final song = state.response[index];
                      return GestureDetector(
                        onLongPress: () {
                          context.read<SearchBloc>().add(
                            AddToSearchHistory(song: song),
                          );
                          // context.read<PlayerBloc>().add(StopSong());
                          context.read<PlayerBloc>().add(
                            PlaySong(
                              PlayingSong(
                                id: song.id,
                                title: song.title,
                                artist: song.title,
                                thumbnail: song.thumbnail,
                                duration: song.duration,
                              ),
                            ),
                          );
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.terminalSurface,
                                  border: Border.all(
                                    color: AppColors.terminalAmber,
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: song.thumbnail,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),

                                    const SizedBox(height: 16),

                                    Text(
                                      song.title,
                                      style: const TextStyle(
                                        color: AppColors.terminalAmber,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      song.artist,
                                      style: const TextStyle(
                                        color: AppColors.terminalAmber,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    ListTile(
                                      leading: const Icon(
                                        Icons.play_arrow,
                                        color: AppColors.terminalAmber,
                                      ),
                                      title: const Text(
                                        "Play",
                                        style: TextStyle(
                                          color: AppColors.terminalAmber,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),

                                    ListTile(
                                      leading: const Icon(
                                        Icons.playlist_add,
                                        color: AppColors.terminalAmber,
                                      ),
                                      title: const Text(
                                        "Add to Queue",
                                        style: TextStyle(
                                          color: AppColors.terminalAmber,
                                        ),
                                      ),
                                      onTap: () {},
                                    ),

                                    ListTile(
                                      leading: const Icon(
                                        Icons.favorite_border,
                                        color: AppColors.terminalAmber,
                                      ),
                                      title: const Text(
                                        "Like",
                                        style: TextStyle(
                                          color: AppColors.terminalAmber,
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          HapticFeedback.heavyImpact();
                        },
                        child: SongTileSmall(
                          title: song.title,
                          artist: song.artist,
                          thumbnail: song.thumbnail,
                          duration: song.duration,
                          id: song.id,
                        ),
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

class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.controller, required this.onTap});

  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextField(
        onSubmitted: (_) => widget.onTap(),
        controller: widget.controller,
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
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: AppColors.terminalAmber),
            onPressed: () {
              widget.controller.clear();

              context.read<SearchBloc>().add(LoadSearchHistory());
            },
          ),
        ),
      ),
    );
  }
}
