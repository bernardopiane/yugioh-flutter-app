import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/models/deck.dart';
import 'package:yugi_deck/models/deck_list.dart';
import 'package:yugi_deck/pages/deck_detail.dart';

class DeckListPage extends StatefulWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  State<DeckListPage> createState() => _DeckListPageState();
}

class _DeckListPageState extends State<DeckListPage> {
  String? inputDeckName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: TextFormField(
                          decoration:
                              const InputDecoration(label: Text("Deck name: ")),
                          onChanged: (value) {
                            setState(() {
                              inputDeckName = value;
                            });
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Add"))
                        ],
                      );
                    }).then((value) {
                  if (inputDeckName != "") {
                    Provider.of<DeckList>(context, listen: false)
                        .addDeck(Deck(inputDeckName.toString()));
                    inputDeckName = "";
                  }
                });
              },
              child: const Text("Add to Deck")),
          const ListTile(
            title: Text("Deck List"),
          ),
          ..._buildDeckList(context)
        ],
      ),
    );
  }

  List<Widget> _buildDeckList(BuildContext context) {
    List<Widget> widgets = [];
    Provider.of<DeckList>(context).decks.forEach((element) {
      widgets.add(ListTile(
        title: Text(element.name),
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeckDetail(deck: element)),
          )
        },
      ));
    });
    return widgets;
  }
}
