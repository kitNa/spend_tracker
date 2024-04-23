import 'dart:convert';

import 'package:spend_tracker/models/account.dart';

class Item {
  final int? id;
  final String? urlId;
  final String description;
  final double amount;
  final bool isDeposit;
  final String date;
  final int? accountId;
  final int? typeId;
  final String? accountUrlId;
  final String? typeUrlId;

  Item({this.id,
    this.urlId,
    required this.description,
    required this.amount,
    required this.isDeposit,
    required this.date,
    this.accountId,
    this.typeId,
    this.accountUrlId,
    this.typeUrlId});

  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'urlId': urlId,
        'description': description,
        'amount': amount,
        'isDeposit': isDeposit,
        'date': date,
        'accountId': accountId,
        'typeId': typeId,
        'accountUrlId': accountUrlId,
      };

  factory Item.fromMap(Map<String, dynamic> map) =>
      Item(
          id: map['id'],
          urlId: map['urlId'],
          description: map['description'],
          amount: map['amount'],
          isDeposit: map['isDeposit'] == 1 || map['isDeposit'] == true,
          date: map['date'],
          accountId: map['accountId'],
          typeId: map['typeId'],
          accountUrlId: map['accountUrlId'],
          typeUrlId: map['typeUrlId']
      );

  static List<Item> fromJson(String jsonString) {
    var map = json.decode(jsonString);
    List<Item> items = [];
    map.forEach((accountKey, data) {
      var fields = data['fields'];
    //  var name = fields['name']['stringValue'];
      items.add(Item(
        urlId: data['urlId'],
        description: fields['description']['stringValue'],
        amount: (fields['amount']['doubleValue']).toDouble(),
        isDeposit:  fields['isDeposit']['booleanValue'],
        date: fields['date']['stringValue'],
        accountUrlId: fields['accountUrlId']['stringValue'],
        typeUrlId: fields['typeUrlId']['stringValue'],
      ));
    });
    return items;
  }

  String toJson() {
    return json.encode({
      'fields': {
        'accountUrlId': {'stringValue': accountUrlId},
        'amount': {'doubleValue': amount},
        'date': {'stringValue': date},
        'description': {'stringValue': description},
        'isDeposit': {'booleanValue': isDeposit},
        'typeUrlId': {'stringValue': typeUrlId},
      }
    });
  }
}
