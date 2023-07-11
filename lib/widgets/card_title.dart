import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  const CardTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 32,
        letterSpacing: 1.2,
        height: 1.5,
        fontFamily: 'Matrix Regular Small Caps',
      ),
    );
  }
}
