import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/home/widgets/custom_text.dart';
import 'package:spend_tracker/pages/home/widgets/menu.dart';
import 'package:spend_tracker/pages/index.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PopupMenuButton(
        child: const Icon(
          Icons.add_circle,
          size: 60,
          color: Colors.orangeAccent,
        ),
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(
            value: 1,
            child: Text('Deposit'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('Withdraw'),
          ),
        ],
        onSelected: (var value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItemPage(
                isDeposit: value == 1,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: const Menu(),
      appBar: AppBar(
        // leading: Image.asset('images/logo.png'),
        centerTitle: true,
        title: const Text('Spend Tracker',
            style: TextStyle(color: Colors.orange, fontSize: 30)),
        actions: <Widget>[
          IconButton(
              onPressed: () => print('click'),
              icon: const Icon(
                Icons.refresh,
                color: Colors.orangeAccent,
                size: 30,
              ),
              tooltip: 'update')
        ],
        backgroundColor: Colors.black87,
      ),
      body: Center(
          //widthFactor: 100,
          //heightFactor: 100,

          child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          // Container(
          //   // margin устанавливает отступи вокруг контейнера
          //   margin: EdgeInsets.only(bottom: 10),
          //
          //   // // constraints утсанавливает ограничение на размер контейнера
          //   constraints: const BoxConstraints(maxWidth: 1000),
          //
          //   // //дочерний эллемент не будет видно,если его размер превышает размер
          //   контейнера
          //   // constraints: const BoxConstraints(maxWidth: 100, maxHeight: 10),
          //
          //   // //padding позволяет нарисовать рамочку вокруг дочернего эллемента
          //   //padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
          //   //padding: const EdgeInsets.all(40),
          //   //padding: const EdgeInsets.only(top: 20, left: 20),
          //   //padding: EdgeInsets.symmetric(horizontal: 30),
          //
          //   // //alignment устанавливает выравнивание дочернего елемента
          //   контейнера
          //   alignment: Alignment.center,
          //
          //   // устанавливает ширину и высоту контейнера
          //   //width: 300,
          //   //height: 300,
          //
          //   // color устанавливает цвет подложки контейнера
          //   color: Colors.orange,
          //
          //   // child объявляет дочерний эллемент контейнера
          //   child: const Text('Home',
          //       style: TextStyle(
          //           fontSize: 65, fontWeight: FontWeight.bold)),
          // ),

          // const Text(
          //   'Your amount',
          //   style: TextStyle(
          //       fontSize: 50, color: Colors.black, fontWeight: FontWeight.bold),
          // ),

          _TotalBudget(100000),

          Image.network(
            'https://kuznya.biz/wp-content/uploads/2016/06/CHto-takoe-Kuznya.jpg',
            height: 300,
            width: 900,
          ),

          // const Text(
          //   'My',
          //   style: TextStyle(fontSize: 65, fontWeight: FontWeight.bold),
          // ),
          // const CustomText('page'),
        ],
      )),
    );
  }
}

class _TotalBudget extends StatelessWidget {
  var amount;

  _TotalBudget(this.amount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 70, bottom: 70, left: 40, right: 40),

      // использует BoxDecoration "под капотом", по этому выбросит ошибку,
      // если вызывать вместе с decoration: BoxDecoration(color: Colors.orange)
      // color: Colors.orange,

      decoration: const BoxDecoration(
        color: Colors.orange,

        //border устанавливает рамочку без скругления
        // border:
        // Border.all(color: Colors.black87, width: 5, style: BorderStyle.solid),

        //что бы установить разные граници для каждой стороны следует
        // использовать:
        //border: Border(bottom: BorderSide(color: Colors.black87))),

        //  borderRadius позволяет скруглить углы
        borderRadius: BorderRadius.all(Radius.circular(5)),

        //оформление каждого угла по отдельности
        // borderRadius: BorderRadius.only(topRight: Radius.circular(5))),

        // gradient позволяет создать радиальний градиент
        // gradient: RadialGradient(colors: [Colors.orange, Colors.black87], radius: 5),

        // gradient позволяет создать линейный градиент, используя минимум
        // два цвета.
        gradient: LinearGradient(
            colors: [Colors.orange, Colors.black87, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),

        //  LinearGradient Может принимать параметры Stop, количество которых должно
        //  соответствующие количеству цветов, что бы указать
        //  когда следуют прекратить заливку каждого цвета и перейти к
        //  следующему.
        // gradient: LinearGradient(
        //     colors: [Colors.orange, Colors.black87, Colors.white], stops: [0.8, 0.2, 0.5],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight),

        //boxShadow позволяет создать тень, принимая массив  BoxShadow,
        // каждый из которых задает цвет и ширину своей тени
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(6, 6),
          ),
          BoxShadow(
            color: Colors.black87,
            offset: Offset(2, 2),
          )
        ],
      ),

      child: Text('\$ ${amount.toString()}',
          style: const TextStyle(
              fontSize: 65, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
