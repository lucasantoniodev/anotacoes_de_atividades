import 'package:flutter/material.dart';

class CustomTextButtonWidget extends StatelessWidget {
  final String actionText;
  final VoidCallback? onPressed;
  final Color? color;
  const CustomTextButtonWidget(
      {super.key,
      required this.onPressed,
      required this.actionText,
      this.color = const Color.fromARGB(255, 31, 4, 107)});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed!,
        child: Text(actionText, style: TextStyle(color: color!)));
  }
}
