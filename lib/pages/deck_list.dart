import 'package:flutter/material.dart';

class DeckList extends StatelessWidget {
  const DeckList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: const Text("Deck List"),
    );
  }
}
