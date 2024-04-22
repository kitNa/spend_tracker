import 'dart:convert';

import 'package:flutter/material.dart';

import '../support/icon_helper.dart';

class ItemType{
  final int? id;
  final String? urlId;
  final String name;
  final int codePoint;

  ItemType({
    this.id,
    this.urlId,
    required this.codePoint,
    required this.name,
  });

  IconData get iconData => IconHelper.createIconData(codePoint);

  Map<String, dynamic> toMap() => {
    'id': id,
    'urlId': urlId,
    'name': name,
    'codePoint': codePoint,
  };

  factory ItemType.fromMap(Map<String, dynamic> map) => ItemType(
    id: map['id'],
    urlId: map['urlId'],
    name: map['name'],
    codePoint: map['codePoint'],
  );

  static List<ItemType> fromJson(String jsonString) {
    var map = json.decode(jsonString);
    List<ItemType> types = [];
    map.forEach((accountKey, data) {
      var fields = data['fields'];
      var name = fields['name']['stringValue'];
      types.add(ItemType(
        urlId: name,
        codePoint: fields['codePoint']['integerValue'],
        name: name,
      ));
    });
    return types;
  }

  String toJson() {
    return json.encode({
      'fields': {
        'name': {'stringValue': name},
        'codePoint': {'integerValue': codePoint}
      }
    });
  }
}
