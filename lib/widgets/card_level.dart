import 'package:flutter/material.dart';

class CardLevel extends StatelessWidget {
  const CardLevel({Key? key, required this.level}) : super(key: key);
  final int level;

  @override
  Widget build(BuildContext context) {
    return Text(level.toString());
  }
}
