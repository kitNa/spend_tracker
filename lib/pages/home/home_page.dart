import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Spend Tracker',
        ),
        backgroundColor: Colors.amber,
      ),
      body: const Center(
        child: Text('My first page'),
      ),
    );
  }
}
