import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/core/widgets/buttons.dart';
import 'package:tsuki/features/inits/presentation/pages/onboard/widgets/page_zero_onboard.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  final PageController controller = PageController();
  int currentPage = 0;

  void navigateTonext(PageController c, int currentPage) {
    if (currentPage < 2) {
      c.animateToPage(
        currentPage + 1,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/shell');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const BouncingScrollPhysics(),
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },

              children: [
                PageZeroOnboard(
                  onskip: () => context.go('/shell'),
                  showSkip: true,
                  heading: "Music that\nmatches how you\nfeel",
                  subheading:
                      "No genres to sort through. Just tell  us the mood, and we'll take it fromthere",
                  ontapbutton: () => navigateTonext(controller, 0),

                  onboardcolor: AppColors.moodSage,
                ),
                PageZeroOnboard(
                  showSkip: false,
                  heading: "Play anything \n anywhere",
                  subheading:
                      "No subscription, no ads breaking \n the mood. Just tap a song and it \n plays\n ",
                  ontapbutton: () => navigateTonext(controller, 1),

                  onboardcolor: AppColors.moodAmber,
                ),
                PageZeroOnboard(
                  showSkip: false,
                  heading: "Your library,\n gathered in one \n place",
                  subheading:
                      " Bring in the playlists and songs\n you already love. We'll take it from here",
                  ontapbutton: () {},

                  onboardcolor: AppColors.moodSage,
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? AppColors.surface
                      : AppColors.inactive,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(height: screenheight / 20),
          PrimaryButton(
            onPress: () => navigateTonext(controller, currentPage),
            label: currentPage < 2 ? "Next" : "Get started",
          ),
          SizedBox(height: screenheight / 10),
        ],
      ),
    );
  }
}
