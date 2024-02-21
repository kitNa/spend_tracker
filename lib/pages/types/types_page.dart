import 'package:flutter/material.dart';
import 'type_page.dart';

class TypesPage extends StatelessWidget {
  const TypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Types'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TypePage()));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: const Center(
        child: Text('Types'),
      ),
    );
  }
}
