import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spend_tracker/firebase/apis.dart';

//Клас, який буде використовувати API і використовувати потоки для повідомлення
// спостерігачів про статус входу
class FirebaseBloc {
  FirebaseBloc({required this.apis});
  final Apis apis;

  //контролер потоку, який пропустить булеве значення через потік, щоб
  // визначити, чи був вхід успішним.
  final _securityPubSub = PublishSubject<bool>();

  //Observable для використання інтерфейсом користувача.
  //Observable<bool>
  get loginStatus {
    return _securityPubSub.stream;
  }

  //метод входу, який викликає API входу, перевіряє результати, передає
  // результати в потік
  void login(String email, String password) async {
    try {
      await apis.login(email, password);
      _securityPubSub.add(true);
    } catch (err) {
      _securityPubSub.sink.addError(err.toString());
    }
  }

  //Коли у нас є трансляція, яка відкрита, нам потрібно закрити її, якщо вона
  // більше не потрібна.
  void dispose() {
    _securityPubSub.close();
  }
}
