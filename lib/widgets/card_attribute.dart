import 'package:flutter/material.dart';

class CardAttribute extends StatelessWidget {
  const CardAttribute({Key? key, required this.attribute}) : super(key: key);
  final String attribute;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: AssetImage("assets/images/$attribute.png"),
          height: 32,
        ),
        const SizedBox(width: 4),
        Text(
          attribute,
          style: const TextStyle(
            fontFamily: "ITC Stone Serif Small Caps Bold",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )
      ],
    );
  }
}
