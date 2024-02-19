import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/accounts/accounts_page.dart';
import 'package:spend_tracker/pages/home/home_page.dart';

import 'routes.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       // title: Text('Spend Tracker'),
           // style: TextStyle(color: Colors.orange)),
        theme: ThemeData(primaryColor: Colors.black87),
        //home: HomePage(),
        initialRoute: '/',
        routes: routes);
  }
}
