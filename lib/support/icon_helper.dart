import 'package:flutter/cupertino.dart';

class IconHelper{
  static IconData createIconData(int codePoint){
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }
}
