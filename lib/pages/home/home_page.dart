import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spend_tracker/database/db_provider.dart';
import 'package:spend_tracker/firebase/firebase_bloc.dart';
import 'package:spend_tracker/pages/home/widgets/menu.dart';
import 'package:spend_tracker/pages/index.dart';
import 'package:spend_tracker/routes.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Flutter дозволяє нам підключитися до системи маршрутизації за допомогою
// кількох класів: RouteObserver і RouteAware. RouteAware — це міксин, який ми
// додаємо до віджета, який хоче підписатися на події маршруту. RouteObserver —
// це клас, на який підписуються віджети RouteAware. RouteObserver сповіщає
// віджети RouteAware про зміни маршруту.
class _HomePageState extends State<
        HomePage> //https://api.flutter.dev/flutter/widgets/WidgetsBindingObserver-class.html
//https://api.flutter.dev/flutter/widgets/RouteAware-class.html
    with
        RouteAware,
        WidgetsBindingObserver,
        SingleTickerProviderStateMixin {
  double _balance = 0;
  double _opacity = 0.2;
  double _fontSize = 10;
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(
      begin: 0,
      end: 360,
    ).animate(_controller)
      //дві крапки - це каскадна нотація в Dart. Це дозволяє нам робити послідовні
      //виклики методів на одному і тому ж об'єкті. Можна об'єднати стільки
      // викликів скільки потрібно.
      ..addStatusListener((AnimationStatus status) {
        //addStatusListener дозволяє нам додати зворотний виклик, який очікує на
        // зміни в анімації. Тут ми перевіряємо, чи анімація завершена, і якщо
        // так, то змінюємо її на протилежну.
        if (status == AnimationStatus.dismissed) {
          //reverse метод змінить анімацію до початкового значення, але
          // анімуватиме процес протягом вказаного _controller часу.
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          //Якщо статус закрито, ми переміщуємо анімацію вперед.
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    // Коли віджет підписаний на routeObserver, ми також повинні його видалити.
    // Пам'ятайте, що в життєвому циклі віджета State метод dispose викликається,
    // коли стан видаляється з дерева назавжди.
    routeObserver.unsubscribe(this);
    // Те саме стосуэться і WidgetsBinding
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
  }

  @override
  // Вызывается при изменении зависимости этого объекта State .
  // Например, если предыдущий вызов build ссылался на InheritedWidget ,
  // который позже изменился, платформа вызовет этот метод, чтобы
  // уведомить этот объект об изменении. Этот метод также вызывается сразу
  // после initState .
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // context.read<T>() is same as Provider.of<T>(context, listen: false)
    // context.watch<T>() is same as Provider.of<T>(context)```
    // more info in item_page
    var block = Provider.of<FirebaseBloc>(context);
    setState(() {
      _balance = block.balance.total;
      routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
      WidgetsBinding.instance.addObserver(this);
      _opacity = 1.0;
      _fontSize = 40;
    });
  }

  //Завдяки цьому методу ми можемо знати, коли програма призупинена або неактивна.
  // Це може допомогти, якщо нам потрібно очистити або зберегти дані. Він також
  // повідомляє нам, коли додаток відновлюється. Це може бути корисно, якщо ви
  // хочете вимагати від користувачів повторної автентифікації, коли програма
  // відновлюється після призупинення роботи у фоновому режимі. Ми хочемо, щоб
  // програма поверталася на головний екран після відновлення роботи, а не на
  // місце, де робота була призупинена.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //заміняємо все що є в стеку домашньою сторінкою
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  //дідPopNext викликається, коли ми повертаємося назад або витягуємо попередній
  //екран зі стека, щоб бути точнішим.
  @override
  void didPopNext() async {
    // var dbProvider = context.read<DBProvider>();
    // var balance = await dbProvider.getBalance();
    // _balance = balance.total;
    var block = Provider.of<FirebaseBloc>(context);
    _balance = block.balance.total;
    print('home_page did pop next');
  }

  //didPushNext викликається, коли ми переходимо на інший екран.
  @override
  void didPushNext() async {
    // var dbProvider = context.read<DBProvider>();
    // var balance = await dbProvider.getBalance();
    // _balance = balance.total;
    var block = Provider.of<FirebaseBloc>(context);
    _balance = block.balance.total;
    print('home_page did push next');
  }

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

          // Існує кілька рівнів анімації з Flutter: неявна, перехідна та явна
          // анімація. Усі неявні віджети анімації походять від
          // ImplicitlyAnimatedWidget. Віджети переходів є підкласом
          // AnimatedWidget. Основна відмінність полягає у тому, що віджети
          // переходу надають вам більше контролю над анімацією, ніж неявний
          // віджет, але з більшим контролем приходить складність. Для роботи з
          // віджетами переходів нам потрібно використовувати пару класів і
          // міксин. Нам потрібно:
          // - SingleTickerProviderStateMixin. Він
          // допомагає переконатися, що анімація запускається лише тоді, коли
          // віджет видимий.
          // - AnimationController: керує відтворенням анімації і зберігає
          // конфігурацію та значення анімації.

          //Віджет AnimatedContainer дозволяє нам анімувати такі властивості,
          // як колір, оформлення, ширина та висота.

          //AnimatedOpacity анімує появу об'єкта через зміну прозорості
          AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 4),
              child: _TotalBudget(
                _balance,
                fontSize: _fontSize,
              )),
          //    return AnimatedBuilder(
          //         animation: _animation,
          //         builder: (_, __) {
          //           //За допомогою віджета Трансформування ви можете обертати,
          //           // масштабувати або зміщувати дочірній віджет за допомогою
          //           // різних конструкторів.
          //           return Transform.rotate(
          //             //Тут ми змінюємо ракурс: нашого Зображення. Для нашої формули ми
          //             // використовуємо постійну числа пі з математичної бібліотеки, яку
          //             // ми імпортували. Це призведе до того, що наше зображення буде
          //             // обертатися в міру того, як тривалість буде змінюватися від 0 до
          //             // 5 секунд.
          //             angle: _controller.value * 2.0 * math.pi,
          //               child: Image.asset(
          //                   'lib/assets/images/image.jpg',
          //               width: _animation.value,
          //               height: _animation.value,),
          //           );
          //         },
          //     );
          AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              //За допомогою віджета Трансформування ви можете обертати,
              // масштабувати або зміщувати дочірній віджет за допомогою
              // різних конструкторів.
              return Transform.rotate(
                //Тут ми змінюємо ракурс: нашого Зображення. Для нашої формули ми
                // використовуємо постійну числа пі з математичної бібліотеки, яку
                // ми імпортували. Це призведе до того, що наше зображення буде
                // обертатися в міру того, як тривалість буде змінюватися від 0 до
                // 5 секунд.
                angle: _controller.value * 2.0 * math.pi,
                child: Image.network(
                  'https://kuznya.biz/wp-content/uploads/2016/06/CHto-takoe-Kuznya.jpg',
                  width: _animation.value,
                  height: _animation.value,
                ),
              );
            },
          )

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
  final double amount;
  final double fontSize;

  _TotalBudget(this.amount, {required this.fontSize});

  final NumberFormat formatter = NumberFormat("#,##0.00", "en_US");

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

      child: Center(
        //AnimatedDefaultTextStyle дозволяє інімувати розмір через змінну
        //fontSize
        child: AnimatedDefaultTextStyle(
          duration: const Duration(seconds: 3),
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          child: Text(
            '\$${formatter.format(amount)}',
          ),
        ),
      ),
    );
  }
}
