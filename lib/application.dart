import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/home/home_page.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
