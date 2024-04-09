import 'package:flutter/cupertino.dart';
import 'package:spend_tracker/pages/index.dart';

final routes = {
  '/': (_) => const LoginPage(),
  '/home': (_) => const HomePage(),
  '/accounts': (_) => const AccountsPage(),
  '/items': (_) => const ItemsPage(),
  '/types': (_) => const TypesPage(),
  '/bar_chart': (_) => const BarChartPage(),
  '/animation': (_) => const AnimationPage(),
};

// Flutter дозволяє нам підключитися до системи маршрутизації за допомогою
// кількох класів: RouteObserver і RouteAware. RouteAware — це міксин, який ми
// додаємо до віджета, який хоче підписатися на події маршруту. RouteObserver —
// це клас, на який підписуються віджети RouteAware. RouteObserver сповіщає
// віджети RouteAware про зміни маршруту.

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
