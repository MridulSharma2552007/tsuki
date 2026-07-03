import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/features/inits/presentation/onboard/widgets/page_zero_onboard.dart';

class OnBoard extends StatefulWidget {
  OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  final PageController controller = PageController();
  int currentPage = 0;

  void navigateTonext(PageController c, int currentPage) {
    c.animateToPage(
      currentPage + 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },

              children: [
                PageZeroOnboard(
                  onskip: () {},
                  showSkip: true,
                  heading: "Music that\nmatches how you\nfeel",
                  subheading:
                      "No genres to sort through. Just tell  us the mood, and we'll take it fromthere",
                  ontapbutton: () => navigateTonext(controller, 0),
                  buttonlabel: 'Get started',
                  onboardcolor: AppColors.moodSage,
                ),
                PageZeroOnboard(
                  showSkip: false,
                  heading: "Play anything \n anywhere",
                  subheading:
                      "No subscription, no ads breaking \n the mood. Just tap a song and it \n plays\n ",
                  ontapbutton: () => navigateTonext(controller, 1),
                  buttonlabel: "Next",
                  onboardcolor: AppColors.moodAmber,
                ),
                PageZeroOnboard(
                  showSkip: false,
                  heading: "Your library,\n gathered in one \n place",
                  subheading:
                      " Bring in the playlists and songs\n you already love. We'll take it from here",
                  ontapbutton: () {},
                  buttonlabel: 'Get Started',
                  onboardcolor: AppColors.moodSage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
