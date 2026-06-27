import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tsuki/core/theme/app_colors.dart';

class TsukiHeader extends StatefulWidget {
  const TsukiHeader({super.key});

  @override
  State<TsukiHeader> createState() => _TsukiHeaderState();
}

class _TsukiHeaderState extends State<TsukiHeader> {
  final loadingFrames = ['|', '/', '-', '\\'];
  int currentFrame = 0;
  Timer? time;
  @override
  void initState() {
    super.initState();
    time = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        currentFrame = (currentFrame + 1) % loadingFrames.length;
      });
    });
  }

  @override
  void dispose() {
    time?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "[TSUKI]${loadingFrames[currentFrame]}",
              style: const TextStyle(
                color: AppColors.terminalAmber,
                fontFamily: 'Courier',
                fontSize: 30,
              ),
            ),
          ],
        ),
        Text('心に響く音 .v1.0.1', style: TextStyle(color: AppColors.terminalAmber)),
      ],
    );
  }
}
