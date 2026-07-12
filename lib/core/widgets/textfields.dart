import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';

class CustomSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onSubmitted;
  const CustomSearchTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),

          child: TextField(
            onSubmitted: onSubmitted,
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              prefixIcon: Icon(Icons.search),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
