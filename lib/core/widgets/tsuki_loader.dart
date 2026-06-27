import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:tsuki/core/theme/app_colors.dart';

class TsukiLoader extends StatefulWidget {
  const TsukiLoader({super.key});

  @override
  State<TsukiLoader> createState() => _TsukiLoaderState();
}

class _TsukiLoaderState extends State<TsukiLoader> {
  final List frames = ['|', '/', '-', '\\'];
  int currentFrame = 0;
  Timer? time;

  @override
  void initState() {
    super.initState();
    time = Timer.periodic(Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() {
        currentFrame = (currentFrame + 1) % frames.length;
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
    return Center(
      child: Text(
        "Loading ${frames[currentFrame]}",
        style: TextStyle(color: AppColors.terminalAmber, fontSize: 20),
      ),
    );
  }
}
