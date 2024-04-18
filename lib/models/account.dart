import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../support/icon_helper.dart';

class Account {
  final int? id;
  final String? urlId;
  final String name;
  final int codePoint;
  final double balance;

  IconData get iconData => IconHelper.createIconData(codePoint);

  Account(
      {this.id,
      this.urlId,
      required this.name,
      required this.codePoint,
      required this.balance});

  Map<String, dynamic> toMap() => {
        'id': id,
        'urlId': urlId,
        'name': name,
        'codePoint': codePoint,
        'balance': balance
      };

  factory Account.fromMap(Map<String, dynamic> map) => Account(
        id: map['id'],
        urlId: map['urlId'],
        name: map['name'],
        codePoint: map['codePoint'],
        balance: map['balance'],
      );

  static List<Account> fromJson(String jsonString) {
    var map = json.decode(jsonString);
    List<Account> accounts = [];
    map.forEach((accountKey, data) {
      var fields = data['fields'];
      var name = fields['name']['stringValue'];
      accounts.add(Account(
        urlId: name,
        codePoint: fields['codePoint']['integerValue'],
        name: name,
        balance: fields['balance']['doubleValue'].toDouble(),
      ));
    });
    return accounts;
  }

  String toJson() {
    return json.encode({
      'fields': {
        'balance': {'doubleValue': balance},
        'name': {'stringValue': name},
        'codePoint': {'integerValue': codePoint}
      }
    });
  }
}
