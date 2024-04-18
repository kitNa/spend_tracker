//import 'dart:html';

//import 'package:flutter/material.dart';
//import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spend_tracker/firebase/apis.dart';
import '../models/account.dart';

//Клас, який буде використовувати API і використовувати потоки для повідомлення
// спостерігачів про статус входу
class FirebaseBloc {
  FirebaseBloc({required this.apis});

  final Apis apis;

  //контролер потоку, який пропустить булеве значення через потік, щоб
  // визначити, чи був вхід успішним.
  final _securityPubSub = PublishSubject<bool>();

  //Різниця між Поведінковим суб'єктом і Суб'єктом публікації для наших цілей
  // полягає в тому, що Суб'єкт Публікації не запам'ятовує останнє значення,
  // а Суб'єкт поведінки запам'ятовує.
  final _accountsBehavSub = BehaviorSubject<List<Account>?>();

  //Observable для використання інтерфейсом користувача.
  //Observable<bool>
  get loginStatus {
    return _securityPubSub.stream;
  }

  //потрібно відкрити потік з властивістю getter.
  get accounts {
    _accountsBehavSub.stream.doOnListen(() {
      Future<void>.delayed(const Duration(seconds: 1))
          .then((value) => getAccounts());
    });
  }

  Future getAccounts() async {
    try {
      var accounts = await apis.getAccounts();
      _accountsBehavSub.sink.add(accounts);
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  Future createAccount(Account account) async {
    try {
      await apis.createAccount(account);
      _accountsBehavSub.sink.add(null);
      await getAccounts();
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  Future updateAccount(Account account) async {
    try {
      await apis.createAccount(account);
      _accountsBehavSub.sink.add(null);
      await getAccounts();
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
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
    _accountsBehavSub.close();
  }
}
