import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spend_tracker/pages/home/widgets/custom_text.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('images/logo.png'),
        centerTitle: true,
        title: const Text(
          'Spend Tracker',
        ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'My',
            style: TextStyle(fontSize: 65, fontWeight: FontWeight.bold),
          ),
          const Text(
            'first',
            style: TextStyle(fontSize: 65, color: Colors.amber),
          ),
          const CustomText('page'),
          Image.network(
            'https://kuznya.biz/wp-content/uploads/2016/06/CHto-takoe-Kuznya.jpg',
            height: 300,
            //width: 900,
          ),
        ],
      )),
    );
  }
}
