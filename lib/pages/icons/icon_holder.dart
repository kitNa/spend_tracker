import 'package:flutter/material.dart';
import 'icons_page.dart';

typedef OnIconChange = void Function(IconData iconData);

class IconHolder extends StatefulWidget {
  const IconHolder ({
    super.key,
    required this.newIcon,
    required this.onIconChange,
  });

  final IconData newIcon;
  final OnIconChange onIconChange;

  @override
  State<IconHolder> createState() => _IconHolderState();
}

class _IconHolderState extends State<IconHolder> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickAvatar(),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.black87,
          ),
        ),
        child: Icon(
          widget.newIcon,
          size: 60,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }

  void _pickAvatar() async {
    var iconData = await Navigator.push(
      context,
        MaterialPageRoute(
          builder: (context) => const IconsPage(),
        ),
    );
    widget.onIconChange(iconData);
  }
}
