import 'package:flutter/material.dart';

class CustomAlertDialogComponent extends StatelessWidget {
  final String actionTitle;
  final List<Widget> widgets;
  final List<Widget> actionsWidgets;

  const CustomAlertDialogComponent(
      {super.key, required this.actionTitle, required this.widgets, required this.actionsWidgets});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(actionTitle,
              style: const TextStyle(fontWeight: FontWeight.bold))),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: widgets),
      actions: actionsWidgets,
    );
  }
}
