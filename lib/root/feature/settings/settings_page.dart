import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        "https://lh3.googleusercontent.com/pZ_UQsFXAT20pP0z3kByflRTEXDW2scHw4PH_egN6wHq-z_dc_Ob50kdyFzYqYYMM3-b0zXpf4mNlhsY=w544-h544-p-l90-rj",
        width: 300,
        height: 300,
      ),
    );
  }
}
