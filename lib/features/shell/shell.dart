import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/features/home/explore/explore_page.dart';
import 'package:tsuki/features/home/library/library_page.dart';
import 'package:tsuki/features/home/search/search_page.dart';
import 'package:tsuki/features/shell/nav_bar.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int currentIndex = 0;
  final pages = const [
    ExplorePage(),
    SearchPage(),
    LibraryPage(),
    Placeholder(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          IndexedStack(index: currentIndex, children: pages),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: NavBar(
              currentIndex: currentIndex,
              onIndexChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
