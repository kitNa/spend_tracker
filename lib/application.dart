import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/pages/accounts/accounts_page.dart';
import 'package:spend_tracker/pages/home/home_page.dart';
import 'database/db_provider.dart';

import 'routes.dart';

// Это обобщенный код, который будет содержать ссылку на созданный класс
// DbProvider. Метод builder создает экземпляр объекта DbProvider.
// Свойство dispose вызывается при закрытии приложения, и оно закрывает базу
// данных путем вызова метода dispose объекта DbProvider.

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DBProvider>(
      //builder:,
      dispose: (_, value) => value.dispose(),
      create: (BuildContext context)  => DBProvider(),
      child: MaterialApp(
         // title: Text('Spend Tracker'),
             // style: TextStyle(color: Colors.orange)),
          theme: ThemeData(primaryColor: Colors.black87),
          //home: HomePage(),
          initialRoute: '/',
          routes: routes),
    );
  }
}
