import 'package:flutter/material.dart';

import 'account_page.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Accounts'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountPage(),
                      )
                  );
                },
                icon: const Icon(Icons.add)),
          ]),
      body: const Center(
        child: Text('Accounts'),
      ),
    );
  }
}
