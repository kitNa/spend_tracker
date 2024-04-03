import 'package:flutter/cupertino.dart';
import 'package:spend_tracker/pages/index.dart';

final routes = {
  '/': (BuildContext context) => const HomePage(),
  '/accounts': (BuildContext context) => const AccountsPage(),
  '/items': (BuildContext context) => const ItemsPage(),
  '/types': (BuildContext context) => const TypesPage(),
  '/bar_chart': (BuildContext context) => const BarChartPage(),
  '/animation': (BuildContext context) => AnimationPage(),
};

// Flutter дозволяє нам підключитися до системи маршрутизації за допомогою
// кількох класів: RouteObserver і RouteAware. RouteAware — це міксин, який ми
// додаємо до віджета, який хоче підписатися на події маршруту. RouteObserver —
// це клас, на який підписуються віджети RouteAware. RouteObserver сповіщає
// віджети RouteAware про зміни маршруту.

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
