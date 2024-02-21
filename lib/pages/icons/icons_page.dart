import 'package:flutter/material.dart';
import './icon_list.dart';

class IconsPage extends StatelessWidget {
  const IconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Icons'),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          //расстояние между элементами по горизонтальной оси
          spacing: 10,
          //расстояние между элементами по вертикали
          runSpacing: 10,
          children: icons
              .map(
                (iconData) => InkWell(
                  child: Opacity(
                    opacity: .7,
                    child: Icon(
                      iconData,
                      size: 60,
                      color: color,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop<IconData>(iconData);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
