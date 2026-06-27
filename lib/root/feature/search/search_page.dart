import 'package:flutter/material.dart';
import 'package:tsuki/app/feature/auth/presentation/shared/widgets_auth.dart';
import 'package:tsuki/utils/app_colors.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: CustomTextField(
              obj: "Search",
              textEditingController: controller,
            ),
          ),
        ],
      ),
    );
  }
}
