import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const LabelButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 12.0
          ),
        ),
      ),
    );
  }
}