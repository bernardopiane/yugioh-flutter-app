import 'package:flutter/material.dart';

class CardAttribute extends StatelessWidget {
  const CardAttribute({Key? key, required this.attribute}) : super(key: key);
  final String attribute;

  @override
  Widget build(BuildContext context) {
    return Text(attribute);
  }
}
