import 'package:flutter/material.dart';


//Пакет діаграм для Flutter
// https://pub.dev/packages/charts_flutter

class BarChartPage extends StatelessWidget {
  const BarChartPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: const Row(
              //положення початку віджета по вертикалі
              crossAxisAlignment: CrossAxisAlignment.start,
              //рівномірний розподіл відступів між віджетами по горизонталі
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //відступ по горизонталі (пропуски між віджетами)
                //Spacer(flex: 2),
                 _BarLine(
                  amount: 567,
                  color: Colors.black87,
                  height: 100,
                  width: 100,
                  text: 'Withdraw',
                ),
                _BarLine(
                  amount: 1879,
                  color: Colors.orange,
                  height: 400,
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
  const _BarLine({
    super.key,
    required this.amount,
    required this.color,
    required this.height,
    required this.width,
    required this.text
  });

  final int amount;
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
        Text('\$$amount'),
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
