import 'package:flutter/material.dart';
import 'package:tsuki/root/feature/home/home_page.dart';
import 'package:tsuki/root/feature/home/widgets/tsuki_header.dart';
import 'package:tsuki/root/feature/playlist/playlist_page.dart';
import 'package:tsuki/root/feature/search/search_page.dart';
import 'package:tsuki/root/feature/settings/settings_page.dart';
import 'package:tsuki/root/navbar.dart';
import 'package:tsuki/utils/app_colors.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentIndex = 0;
  final pages = [HomePage(), SearchPage(), PlaylistPage(), SettingsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.terminalSurface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 40, bottom: 10),
            child: TsukiHeader(),
          ),
          Expanded(
            child: IndexedStack(index: currentIndex, children: pages),
          ),
          Navbar(
            currentIndex: currentIndex,
            onChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
