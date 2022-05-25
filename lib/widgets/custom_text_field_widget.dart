import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool? focus;
  final String title;
 

  const CustomTextFieldWidget(
      {Key? key,
      required this.controller,
      this.focus = false,
      required this.title,
     })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: focus!,
      controller: controller,
      decoration: InputDecoration(labelText: title, hintText: '$title da tarefa'),
    );
  }
}
