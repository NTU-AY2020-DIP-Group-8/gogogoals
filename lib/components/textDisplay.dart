import 'package:flutter/material.dart';

import '../utils/constants.dart';

class TextDisplay extends StatelessWidget {
  final String firstText, hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const TextDisplay({
    Key key,
    this.firstText,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        firstText,
        style: TextStyle(color: kPrimaryColor),
      ),
      TextField(
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryLightColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    ]);
  }
}
