import 'package:flutter/material.dart';
import 'package:tsuki/core/theme/app_colors.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const Navbar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 20),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.terminalSurface,
          border: Border.all(color: AppColors.terminalAmber),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavItem(
              text: "HOME",
              selected: currentIndex == 0,
              onTap: () => onChanged(0),
            ),
            NavItem(
              text: "SEARCH",
              selected: currentIndex == 1,
              onTap: () => onChanged(1),
            ),
            NavItem(
              text: "PLAYLISTS",
              selected: currentIndex == 2,
              onTap: () => onChanged(2),
            ),
            NavItem(
              text: "SETTINGS",
              selected: currentIndex == 3,
              onTap: () => onChanged(3),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Text(
          selected ? "[ $text ]" : text,
          style: TextStyle(
            color: selected
                ? AppColors.terminalAmber
                : AppColors.terminalAmber.withOpacity(0.55),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
