import 'package:flutter/material.dart';

class TextArea extends StatelessWidget {
  const TextArea({
    Key? key,
    required this.controller,
    required this.description,
    this.textColor,
  }) : super(key: key);

  final TextEditingController controller;
  final String description;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: textColor ?? Colors.white,
        ),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintText: description,
        ),
      ),
    );
  }
}
