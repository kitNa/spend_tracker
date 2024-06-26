import 'package:flutter/material.dart';
import 'icons_page.dart';

typedef OnIconChange = void Function(IconData iconData);

class IconHolder extends StatefulWidget {
  const IconHolder({
    super.key,
    this.tagId,
    this.tagUrlId,
    required this.newIcon,
    required this.onIconChange,
  });

  final IconData newIcon;
  final OnIconChange onIconChange;
  final int? tagId;
  final String? tagUrlId;

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
        //The hero refers to the widget that flies between screens.
        // Create a hero animation using Flutter’s Hero widget.
        // Fly the hero from one screen to another.
        // Animate the transformation of a hero’s shape from circular
        // to rectangular while flying it from one screen to another.
        // The Hero widget in Flutter implements a style of animation
        // commonly known as shared element transitions or shared
        // element animations.
        child: Hero(
          tag: widget.tagId == null? widget.tagUrlId as Object : widget.tagId as Object,
          child: Icon(
            widget.newIcon,
            size: 60,
            color: Colors.orangeAccent,
          ),
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
