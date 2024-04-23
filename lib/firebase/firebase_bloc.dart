//import 'dart:html';

//import 'package:flutter/material.dart';
//import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spend_tracker/firebase/apis.dart';
import 'package:spend_tracker/models/item_type.dart';
import '../models/account.dart';
import '../models/balance.dart';
import '../models/item.dart';

//Клас, який буде використовувати API і використовувати потоки для повідомлення
// спостерігачів про статус входу
class FirebaseBloc {
  FirebaseBloc({required this.apis});

  final Apis apis;

  //контролер потоку, який пропустить булеве значення через потік, щоб
  // визначити, чи був вхід успішним.
  final PublishSubject<bool> _securityPubSub = PublishSubject<bool>();

  //Різниця між Поведінковим суб'єктом і Суб'єктом публікації для наших цілей
  // полягає в тому, що Суб'єкт Публікації не запам'ятовує останнє значення,
  // а Суб'єкт поведінки запам'ятовує.
  final BehaviorSubject<List<Account>> _accountsBehavSub =
      BehaviorSubject<List<Account>>();
  final BehaviorSubject<List<ItemType>> _typesBehavSub =
      BehaviorSubject<List<ItemType>>();
  final BehaviorSubject<List<Item>> _itemsBehavSub =
      BehaviorSubject<List<Item>>();

  //Observable для використання інтерфейсом користувача.
  //Observable<bool>
  Stream<bool> get loginStatus {
    return _securityPubSub.stream;
  }

  //потрібно відкрити потік з властивістю getter.
  Stream<List<Account>> get accounts {
    return _accountsBehavSub.stream;
  }

  Stream<List<ItemType>> get itemTypes {
    return _typesBehavSub.stream;
  }

  Stream<List<Item>> get items {
    return _itemsBehavSub.stream;
  }

  Future deleteItem(Item item) async {
    try {
      await apis.deleteItem(item);
      await getItems();
    } catch (err) {
      _itemsBehavSub.sink.addError(err.toString());
    }
  }

  Future getItems() async {
    try {
      var items = await apis.getItems();
      _itemsBehavSub.sink.add(items);
    } catch (err) {
      _itemsBehavSub.sink.addError(err.toString());
    }
  }

  Future createItem(Item item) async {
    try {
      await apis.createItem(item);
      await getItems();
    } catch (err) {
      _itemsBehavSub.sink.addError(err.toString());
    }
  }

  Future getTypes() async {
    try {
      var types = await apis.getTypes();
      _typesBehavSub.sink.add(types);
    } catch (err) {
      _typesBehavSub.sink.addError(err.toString());
    }
  }

  Future createType(ItemType type) async {
    try {
      await apis.createType(type);
      await getTypes();
    } catch (err) {
      _typesBehavSub.sink.addError(err.toString());
    }
  }

  Future updateType(ItemType type) async {
    try {
      await apis.createType(type);
      await getTypes();
    } catch (err) {
      _typesBehavSub.sink.addError(err.toString());
    }
  }

  Balance get balance {
    final items = _itemsBehavSub.value;
    double withdraw = 0;
    double deposit = 0;
    for (var item in items) {
      if (item.isDeposit) {
        deposit += item.amount;
      } else {
        withdraw += item.amount;
      }
    }
    return Balance(
        withdraw: withdraw, deposit: deposit, total: deposit - withdraw,);
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
      await getAccounts();
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  Future updateAccount(Account account) async {
    try {
      await apis.createAccount(account);
      await getAccounts();
    } catch (err) {
      _accountsBehavSub.sink.addError(err.toString());
    }
  }

  //метод входу, який викликає API входу, перевіряє результати, передає
  // результати в потік
  void login(String email, String password) async {
    try {
      var futures = <Future>[];
      futures.add(getItems());
      futures.add(getTypes());
      futures.add(getItems());
      await Future.wait(futures);
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
    _typesBehavSub.close();
    _itemsBehavSub.close();
  }
}
