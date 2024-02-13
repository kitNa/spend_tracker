import 'package:flutter/material.dart';
import 'package:spend_tracker/routes.dart';


class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer (
      child: Column(
        children: <Widget>[
           ListTile(
             title: const Text('Accounts'),
               onTap: () => Navigator.of(context).pushNamed('/accounts'),
           ),
           ListTile(
             title: const Text('Budget Items'),
             onTap: () => Navigator.of(context).pushNamed('/items'),
           ),
          ListTile(
            title: const Text('Types'),
            onTap: () => Navigator.of(context).pushNamed('/types'),
          ),
        ],
      )
    );
  }

  widget({required Text child}) {}
}
