import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../database/db_provider.dart';
import '../../models/balance.dart';

//Пакет діаграм для Flutter
// https://pub.dev/packages/charts_flutter

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  double _withdrawAmount = 0;
  double _depositAmount = 0;
  double _withdrawBarChartHeight = 0;
  double _depositBarChartHeight = 0;

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
                ),
                _BarLine(
                  amount: formatter.format(_depositAmount),
                  color: Colors.orange,
                  height: _depositBarChartHeight,
                  width: 100,
                  text: 'Deposit',
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
      required this.text});

  final String amount;
  final Color color;
  final double height;
  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      //вирівнювання по вертикалі
      mainAxisAlignment: MainAxisAlignment.end,
      //вирівнювання по горизонталі
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(amount),
        Container(
          height: height,
          width: width,
          color: color,
        ),
        Text(text),
      ],
    );
  }
}
