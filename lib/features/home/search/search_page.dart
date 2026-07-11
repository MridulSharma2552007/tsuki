import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_text_theme.dart';
import 'package:tsuki/core/widgets/textfields.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SizedBox(height: screen_height * 0.06),
          Text(
            'What sounds good\n today?',
            style: AppTextTheme.screenTitleLarge,
          ),
          SizedBox(height: screen_height * 0.05),
          CustomSearchTextField(controller: _controller, label: 'Search...'),
        ],
      ),
    );
  }
}
