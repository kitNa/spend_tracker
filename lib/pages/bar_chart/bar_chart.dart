import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:spend_tracker/routes.dart';

import '../../database/db_provider.dart';
import '../../models/balance.dart';

//Пакет діаграм для Flutter
// https://pub.dev/packages/charts_flutter

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<
        BarChartPage> //TickerProviderStateMixin Міксин гарантує, що анімація запускається лише тоді,
// коли віджет видимий. Це також дає віджету можливість отримувати сповіщення
// про зміну кадру. Отже, наші анімації насправді є просто перемальовуванням
// наших віджетів кожного разу, коли кадр змінюється. Це відбувається 60 разів
// на секунду. Flutter рендериться так швидко, що здається, ніби віджет
// анімований.
    with
        TickerProviderStateMixin {
  double _withdrawAmount = 0;
  double _depositAmount = 0;
  double _withdrawBarChartHeight = 0;
  double _depositBarChartHeight = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  // Вызывается при изменении зависимости этого объекта State .
  // Например, если предыдущий вызов build ссылался на InheritedWidget ,
  // который позже изменился, платформа вызовет этот метод, чтобы
  // уведомить этот объект об изменении. Этот метод также вызывается сразу
  // после initState . Из этого метода можно безопасно вызывать
  // BuildContext.dependentOnInheritedWidgetOfExactType .
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // context.read<T>() is same as Provider.of<T>(context, listen: false)
    // context.watch<T>() is same as Provider.of<T>(context)```
    // more info in item_page
    var dbProvider = context.watch<DBProvider>();
    var balance = await dbProvider.getBalance();
    _setHeightBalances(balance);
  }

  void _setHeightBalances(Balance balance) {
    var headersFootersHeight = 284;
    var maxAmount =
        balance.withdraw > balance.deposit ? balance.withdraw : balance.deposit;
    if (maxAmount == 0) {
      setState(() {
        _withdrawBarChartHeight = 0;
        _depositBarChartHeight = 0;
        _withdrawAmount = 0;
        _depositAmount = 0;
      });
      return;
    }
    // MediaQuery.of(context).size.height позволяет узнать висоту текущего
    // представления
    var maxHeight = MediaQuery.of(context).size.height - headersFootersHeight;
    var withdrawBarChartHeight = (balance.withdraw / maxAmount) * maxHeight;
    var depositBarChartHeight = (balance.deposit / maxAmount) * maxHeight;
    setState(() {
      _withdrawBarChartHeight = withdrawBarChartHeight;
      _depositBarChartHeight = depositBarChartHeight;
      _withdrawAmount = balance.withdraw;
      _depositAmount = balance.deposit;
    });
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat("#,##0.00", "en_US");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Bar Chart'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 40,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 196,
            child: Row(
              //положення початку віджета по вертикалі
              crossAxisAlignment: CrossAxisAlignment.start,
              //рівномірний розподіл відступів між віджетами по горизонталі
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //відступ по горизонталі (пропуски між віджетами)
                //Spacer(flex: 2),
                _BarLine(
                  amount: formatter.format(_withdrawAmount),
                  color: Colors.black87,
                  height: _withdrawBarChartHeight,
                  width: 100,
                  text: 'Withdraw',
                  animation: _animation,
                ),
                _BarLine(
                  amount: formatter.format(_depositAmount),
                  color: Colors.orange,
                  height: _depositBarChartHeight,
                  width: 100,
                  text: 'Deposit',
                  animation: _animation,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BarLine extends StatelessWidget {
  const _BarLine(
      {super.key,
      required this.amount,
      required this.color,
      required this.height,
      required this.width,
      required this.text,
      required this.animation});

  final String amount;
  final Color color;
  final double height;
  final double width;
  final String text;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      //вирівнювання по вертикалі
      mainAxisAlignment: MainAxisAlignment.end,
      //вирівнювання по горизонталі
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(amount),
        //AnimatedBuilder відповідає за створення віджета. Але замість того, щоб
        // створювати віджет для списку чи ф'ючерса, він створює віджет для
        // зміни анімації. AnimatedBuilder дозволяє нам анімувати будь-який тип
        // віджетів.
        AnimatedBuilder(
          //BuildContext нам не потрібен і дочірній віджет конструктора нам також
          // не потрібен. Тому ми використовуємо нижнє і подвійне підкреслення.
          // Подвійне підкреслення потрібне для запобігання повторенню оголошень
          // змінних.
          builder: (_, __) {
            // Ми хочемо анімувати контейнер так, щоб контейнер малював свою
            // висоту під час завантаження сторінки. Для цього ми
            // використовували animation.value. Пам'ятайте, що значення
            // animation.value має значення від 0 до 1 протягом 2 секунд.
            // Flutter перемальовує наш віджет зі швидкістю 60 кадрів на секунду,
            // тому ми можемо використовувати значення animation.value протягом
            // 120 кадрів і змінювати висоту контейнера.
            return Container(
              height: animation.value * height,
              width: width,
              color: color,
            );
          },
          animation: animation,
        ),
        Text(text),
      ],
    );
  }
}
