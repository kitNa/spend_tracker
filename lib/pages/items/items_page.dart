import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../firebase/firebase_bloc.dart';


import '../../models/item.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<FirebaseBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Items'),
          backgroundColor: Colors.orangeAccent,
        ),
        body: StreamBuilder<List<Item>>(
          stream: bloc.items,
          //AsyncSnapshot помогает обрабатывать данные асинхронного вызова
          builder: (_, AsyncSnapshot<List<Item>> snapshot) {
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
            var items = snapshot.data;
            if (items!.isEmpty) {
              return const Center(
                child: Text('No Records'),
              );
            }

            //числовой формат, который конвертирует число в валюту США
            var formatter = NumberFormat("#,##0.00", "en_US");

            //ListView.builder имеет метод конструктора, который вызывается,
            // когда нужно отобразить элемент списка на экране.
            return ListView.builder(
              itemCount: items.length,
              //itemBuilder содержит метод сборки для каждой записи. Сигнатура —
              // это контекст с индексом. Нам не нужен контекст, поэтому
              // itemBuilder будет использовать нижнее подчеркивание
              // в качестве заполнителя.
              itemBuilder: (_, int index) {
                var item = items[index];
                // Виджет Dismissible позволяет свайпать елементы списка.
                // В даном примере, перетаскивание этого виджета в
                // DismissDirection приводит к тому, что дочерний элемент
                // исчезает из поля зрения. Если после анимации слайда значение
                // resizeDuration не равно нулю, виджет Dismissible анимирует
                // свою высоту (или ширину, в зависимости от того, что
                // перпендикулярно направлению отклонения) до нуля в течение
                // resizeDuration .
                return Dismissible(
                  key: ObjectKey(item.urlId),
                  // Cвойству ConfirmDismiss требуется функция,
                  // которая возвращает Future с логическим
                  // значением в качестве значения. Он передает объект
                  // DismissDirection, который позволяет нам определить,
                  // в каком направлении провел пользователь.
                  confirmDismiss: (DismissDirection direction) async {
                    //пролистывание справа налево.
                    if (direction == DismissDirection.endToStart) {
                      await bloc.deleteItem(item);
                      return true;
                    }
                    return false;
                  },
                  background: Container(
                    padding: const EdgeInsets.only(right: 5),
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color:
                            item.isDeposit ? Colors.green : Colors.orangeAccent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                    title: Text(item.description),
                    trailing: Text('\$${formatter.format(item.amount)}'),
                  ),
                );
              },
            );
          },
        ));
  }
}
