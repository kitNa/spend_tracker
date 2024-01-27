import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;

  const CustomText(this.text, {super.key});

  @override
  Widget build(context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 65,
        decoration: TextDecoration.underline,
        color: Colors.black87,
      ),
    );
  }
}
