import 'package:flutter/material.dart';

import '../support/icon_helper.dart';

class ItemType{
  final int? id;
  final String name;
  final int codePoint;

  ItemType({
    required this.codePoint,
    required this.name,
    required this.id
  });

  IconData get iconData => IconHelper.createIconData(codePoint);

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'codePoint': codePoint,
  };

  factory ItemType.fromMap(Map<String, dynamic> map) => ItemType(
    id: map['id'],
    name: map['name'],
    codePoint: map['codePoint'],
  );
}
