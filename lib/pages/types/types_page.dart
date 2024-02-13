import 'package:flutter/material.dart';

class TypesPage extends StatelessWidget {
  const TypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Types'),
      ),
      body: const Center(
        child: Text('Types'),
      ),
    );
  }
}
