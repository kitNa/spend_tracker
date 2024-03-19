import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'type_page.dart';

class TypesPage extends StatelessWidget {
  const TypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<DBProvider>(context);

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
      body: FutureBuilder<List<ItemType>>(
        future: dbProvider.getTypes(),
        builder: (_, AsyncSnapshot<List<ItemType>> snapshot) {
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
          var types = snapshot.data;
          if (types!.isEmpty) {
            return const Center(
              child: Text('No Records'),
            );
          }

          //ListView.builder имеет метод конструктора, который вызывается,
          // когда нужно отобразить элемент списка на экране.
          return ListView.builder(
            itemCount: types.length,
            //itemBuilder содержит метод сборки для каждой записи. Сигнатура —
            // это контекст с индексом. Нам не нужен контекст, поэтому
            // itemBuilder будет использовать нижнее подчеркивание
            // в качестве заполнителя.
            itemBuilder: (_, int index) {
              var type = types[index];
              return ListTile(
                leading: Icon(type.iconData),
                title: Text(type.name),
               onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TypePage(
                            type: type,
                          )));
                },
              );
            },
          );
        },
      )
    );
  }
}
