import 'package:flutter/cupertino.dart';
import 'package:spend_tracker/pages/index.dart';

final routes = {
  '/': (BuildContext context) => HomePage(),
  '/accounts': (BuildContext context) => const AccountsPage(),
  '/items': (BuildContext context) => const ItemsPage(),
  '/types': (BuildContext context) => const TypesPage(),
};
