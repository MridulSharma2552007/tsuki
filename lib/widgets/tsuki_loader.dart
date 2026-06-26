import 'dart:async';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/widgets.dart';

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
      currentFrame = (currentFrame + 1) % frames.length;
    });
  }

  @override
  void dispose() {
    time?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Loading${frames[currentFrame]}"));
  }
}
