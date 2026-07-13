import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/app/theme/app_text_theme.dart';
import 'package:tsuki/core/widgets/song_tile.dart';
import 'package:tsuki/core/widgets/textfields.dart';
import 'package:tsuki/features/home/search/bloc/search_bloc.dart';
import 'package:tsuki/features/home/search/bloc/search_event.dart';
import 'package:tsuki/features/home/search/bloc/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  void search(String query) async {
    context.read<SearchBloc>().add(SearchSongs(query));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          SizedBox(height: screenHeight * 0.06),

          Text(
            'What sounds good\n today?',
            style: AppTextTheme.screenTitleLarge,
          ),

          SizedBox(height: screenHeight * 0.05),

          CustomSearchTextField(
            controller: _controller,
            label: 'Search...',
            onSubmitted: search,
          ),

          const SizedBox(height: 20),

          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchLoaded) {
                final results = state.results;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final song = results[index];
                    return GestureDetector(
                      onTap: () {
                        context.read<SearchBloc>().playSong(song.id);
                      },
                      child: SongTile(
                        title: song.title,
                        artist: song.author,
                        duration: song.duration,
                        imageUrl: song.thumbnailUrl,
                        channelid: song.channelId,
                      ),
                    );
                  },
                );
              } else if (state is SearchError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          SizedBox(height: screenHeight * 0.1),
        ],
      ),
    );
  }
}
