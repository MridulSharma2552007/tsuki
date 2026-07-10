import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';

import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: List.generate(
          icons.length,
          (index) => Expanded(
            child: Material(
              color: Colors.transparent,

              child: InkWell(
                customBorder: const CircleBorder(),
                borderRadius: BorderRadius.circular(50),
                onTap: (() => onIndexChanged(index)),
                child: SizedBox(
                  width: 20,
                  height: 60,
                  child: Center(
                    child: SvgPicture.asset(
                      icons[index],
                      color: currentIndex == index
                          ? AppColors.background
                          : AppColors.inactive,
                      height: currentIndex == index ? 25 : 23,
                      width: currentIndex == index ? 25 : 23,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final List<String> icons = [
  'assets/icons/house.svg',
  'assets/icons/search.svg',
  'assets/icons/square-library.svg',
  'assets/icons/user.svg',
];
int selectedIndex = 0;
