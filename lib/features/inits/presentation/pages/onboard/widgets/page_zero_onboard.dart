import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/app/theme/app_text_theme.dart';
import 'package:tsuki/core/widgets/buttons.dart';

class PageZeroOnboard extends StatelessWidget {
  final bool showSkip;
  final String heading;
  final String subheading;
  final VoidCallback ontapbutton;
  final VoidCallback? onskip;

  final Color onboardcolor;

  const PageZeroOnboard({
    super.key,
    required this.showSkip,
    required this.heading,
    required this.subheading,
    required this.ontapbutton,
    this.onskip,

    required this.onboardcolor,
  });

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.sizeOf(context).height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenheight / 20),

        SizedBox(
          height: 40,
          child: showSkip
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: onskip,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Skip', style: AppTextTheme.secondary),
                      ),
                    ),
                  ],
                )
              : null,
        ),
        SizedBox(height: 80),
        introcontainer(screenheight: screenheight, onboardcolor: onboardcolor),
        SizedBox(height: screenheight / 15),
        Text(
          heading,
          style: AppTextTheme.screenTitleLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenheight / 20),
        Text(
          subheading,
          style: AppTextTheme.secondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class introcontainer extends StatelessWidget {
  const introcontainer({
    super.key,
    required this.screenheight,
    required this.onboardcolor,
  });

  final double screenheight;
  final Color onboardcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenheight / 5,
      width: screenheight / 5,
      decoration: BoxDecoration(
        color: onboardcolor,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
