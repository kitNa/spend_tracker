import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spend_tracker/models/item.dart';
import 'package:spend_tracker/models/item_type.dart';
import 'package:sqflite/sqflite.dart';
import 'package:spend_tracker/models/account.dart';

//It's better to call AccountRepository, but I follow the example in the lesson
class DBProvider {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initialize();
    return _database!;
  }

  Future<int> createAccount(Account account) async {
    final db = await database;
    return await db.insert('Account', account.toMap());
  }

  Future<int> updateAccount(Account account) async {
    final db = await database;
    return await db.update('Account', account.toMap(),
        where: 'id = ?', whereArgs: [account.id]);
  }

  Future<Account?> getAccountByID(int id) async {
    final db = await database;
    return db.query('Account', where: 'id = ?', whereArgs: [id]) as Account;
  }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    var res = await db.query('Account');
    List<Account> list =
        res.isNotEmpty ? res.map((a) => Account.fromMap(a)).toList() : [];
    return list;
  }

  Future<int> createType(ItemType type) async {
    final db = await database;
    return await db.insert('ItemType', type.toMap());
  }

  Future<int> updateType(ItemType type) async {
    final db = await database;
    return await db.update('ItemType', type.toMap(),
        where: 'id = ?', whereArgs: [type.id]);
  }

  Future createItem(Item item) async {
    final db = await database;
    var accounts =
        await db.query('Account', where: "id = ?", whereArgs: [item.accountId]);
    var account = Account.fromMap(accounts[0]);
    var balance = account.balance;

    if (item.isDeposit) {
      balance += item.amount;
    } else {
      balance -= item.amount;
    }

    //нужно обновить учетную запись и создать элемент. Но нам нужно обернуть его
    // в транзакцию. Для этого в SQLite мы используем метод transaction на
    // экземпляре db.
    await db.transaction((txn) async {
      await txn.rawUpdate('UPDATE Account SET balance = ${balance.toString}' +
          'WHERE id = ${account.id.toString()}');
      await txn.insert('Item', item.toMap());
    });
  }

  void dispose() {
    _database?.close();
  }

  Future<List<ItemType>> getTypes() async {
    final db = await database;
    var res = await db.query('ItemType');
    List<ItemType> list =
        res.isNotEmpty ? res.map((t) => ItemType.fromMap(t)).toList() : [];
    return list;
  }

  Future<Database> _initialize() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'spend_tracker.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onOpen: (db) {
        print('Database Open');
      },
      onCreate: _onCreate,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Account ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "codePoint INTEGER,"
        "balance REAL"
        ")");
    await db.execute("CREATE TABLE ItemType ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "codePoint INTEGER"
        ")");
    await db.execute("CREATE TABLE Item ("
        "id INTEGER PRIMARY KEY,"
        "description TEXT,"
        "typeId INTEGER,"
        "amount REAL,"
        "date TEXT,"
        "isDeposit INTEGER,"
        "accountId INTEGER,"
        "FOREIGN KEY(typeId) REFERENCES Type(id),"
        "FOREIGN KEY(accountId) REFERENCES Account(id)"
        ")");
    // await db.execute("INSERT INFO Account (id, name, codePoint, balance)"
    //     "values(1, 'Checking', 59471, 0.00)");
    // await db.execute("INSERT INFO Account (id, name, codePoint, balance)"
    //     "values(2, 'Saving', 59471, 0.00)");
    // await db.execute("INSERT INFO ItemType (id, name, codePoint)"
    //     "values(1, 'Paycheck', 59471)");
    // await db.execute("INSERT INFO ItemType (id, name, codePoint)"
    //     "values(2, 'ATM Withdraw', 59471)");
  }
}
