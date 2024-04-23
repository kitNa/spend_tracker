import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/firebase/apis.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'routes.dart';

// Это обобщенный код, который будет содержать ссылку на созданный класс
// DbProvider. Метод builder создает экземпляр объекта DbProvider.
// Свойство dispose вызывается при закрытии приложения, и оно закрывает базу
// данных путем вызова метода dispose объекта DbProvider.

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<DBProvider>(
      dispose: (_, value) => value.dispose(),
      create: (context) => DBProvider(),
      child: Provider<FirebaseBloc>(
        dispose: (_, value) => value.dispose(),
        create: (_) => FirebaseBloc(apis: Apis()),
        child: MaterialApp(
          theme: ThemeData(primaryColor: Colors.black87),
          initialRoute: '/',
          routes: routes,
          navigatorObservers: [routeObserver],
        ),
      )
    );
  }
}
