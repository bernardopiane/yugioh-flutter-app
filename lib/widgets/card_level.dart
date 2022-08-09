import 'package:flutter/material.dart';

class CardLevel extends StatelessWidget {
  const CardLevel({Key? key, required this.level}) : super(key: key);
  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Image(
          image: AssetImage("assets/images/Level.webp"),
          height: 18,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          level.toString(),
        ),
      ],
    );
  }
}
