import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'type_page.dart';

class TypesPage extends StatelessWidget {
  const TypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<FirebaseBloc>(context);

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
      body: StreamBuilder<List<ItemType>>(
        stream: bloc.itemTypes,
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
                //The hero refers to the widget that flies between screens.
                // Create a hero animation using Flutter’s Hero widget.
                // Fly the hero from one screen to another.
                // Animate the transformation of a hero’s shape from circular
                // to rectangular while flying it from one screen to another.
                // The Hero widget in Flutter implements a style of animation
                // commonly known as shared element transitions or shared
                // element animations.
                leading: Hero(
                    tag: type.urlId as Object,
                    child: Icon(type.iconData)),
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
