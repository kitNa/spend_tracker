import 'package:flutter/material.dart';
import 'account_page.dart';

//Библиотека провайдера позволит нам получить класс dbProvider.
import 'package:provider/provider.dart';

//Библиотека intl даст нам доступ к классу numberFormat. Это позволяет
// нам легко форматировать нашу валюту.
import 'package:intl/intl.dart';

import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/models/account.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DBProvider>(context);

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
                        ));
                  },
                  icon: const Icon(Icons.add)),
            ]),
        //FutureBuilder - это виджет, который разработан специально для работы
        // с фьючерсами. FutureBuilder присоединен к свойству body Scaffold, и
        // этот Scaffold возвращается из метода build. Метод build вызывается
        // каждый раз при создании виджета. Помните, что это StatelessWidget,
        // поэтому всякий раз, когда фреймворк обнаруживает изменение, виджет
        // создается заново и вызывается метод сборки.
        body: FutureBuilder<List<Account>>(
          //метод getAllAccounts вызывается каждый раз при вызове метода сборки.
          future: dbProvider.getAccounts(),
          //AsyncSnapshot помогает обрабатывать данные асинхронного вызова
          builder: (_, AsyncSnapshot<List<Account>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            //FutureBuilder возвращает список, поэтому  snapshot
            // будет содержать список учетных записей.
            var accounts = snapshot.data;
            if (accounts!.isEmpty) {
              return const Center(
                child: Text('No Records'),
              );
            }

            //числовой формат, который конвертирует число в валюту США
            var formatter = NumberFormat("#,##0.00", "en_US");

            //ListView.builder имеет метод конструктора, который вызывается,
            // когда нужно отобразить элемент списка на экране.
            return ListView.builder(
              itemCount: accounts.length,
              //itemBuilder содержит метод сборки для каждой записи. Сигнатура —
              // это контекст с индексом. Нам не нужен контекст, поэтому
              // itemBuilder будет использовать нижнее подчеркивание
              // в качестве заполнителя.
              itemBuilder: (_, int index) {
                var account = accounts[index];
                return ListTile(
                  //The hero refers to the widget that flies between screens.
                  // Create a hero animation using Flutter’s Hero widget.
                  // Fly the hero from one screen to another.
                  // Animate the transformation of a hero’s shape from circular
                  // to rectangular while flying it from one screen to another.
                  // The Hero widget in Flutter implements a style of animation
                  // commonly known as shared element transitions or shared
                  // element animations.
                  leading: Hero(
                      tag: account.id as Object,
                      child: Icon(account.iconData)),
                  title: Text(account.name),
                  trailing: Text('\$${formatter.format(account.balance)}'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AccountPage(
                                  account: account,
                                )));
                  },
                );
              },
            );
          },
        ));
  }
}
