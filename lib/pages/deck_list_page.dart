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

  // @override
  // void initState() {
  //   super.initState();
  //   // _loadData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: TextFormField(
                    autofocus: true,
                    decoration:
                        const InputDecoration(label: Text("Deck name: ")),
                    onFieldSubmitted: (value) {
                      setState(() {
                        inputDeckName = value;
                      });
                      Navigator.pop(context, true);
                    },
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
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("Add"),
                    ),
                  ],
                );
              }).then((value) {
            if (value != null) {
              if (inputDeckName != "") {
                Provider.of<DeckList>(context, listen: false)
                    .addDeck(Deck(inputDeckName.toString()));
                inputDeckName = "";
              }
            }
          });
        },
        backgroundColor: Colors.amber[800],
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Deck List"),
      ),
      body: SafeArea(
        // minimum: const EdgeInsets.all(8),
        child: ListView(
          children: [..._buildDeckList(context)],
        ),
      ),
    );
  }

  List<Widget> _buildDeckList(BuildContext context) {
    List<Widget> widgets = [];

    Provider.of<DeckList>(context).decks.forEach((element) {
      widgets.add(
        ListTile(
          contentPadding: const EdgeInsets.all(8),
          title: Text(element.name),
          trailing: PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'rename',
                  child: Text('Rename'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                )
              ];
            },
            onSelected: (String value) {
              if (value == "delete") {
                Provider.of<DeckList>(context, listen: false)
                    .deleteDeck(element.id!.toString());
              } else if (value == "rename") {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: TextFormField(
                          autofocus: true,
                          decoration:
                              const InputDecoration(label: Text("Deck name: ")),
                          onFieldSubmitted: (value) {
                            setState(() {
                              inputDeckName = value;
                            });
                            Navigator.pop(context, true);
                          },
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
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Add"),
                          ),
                        ],
                      );
                    }).then((value) {
                  if (value != null) {
                    if (inputDeckName != "") {
                      Provider.of<DeckList>(context, listen: false)
                          .renameDeck(element, inputDeckName!);
                      inputDeckName = "";
                    }
                  }
                });
              } else {
                debugPrintStack();
              }
            },
          ),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DeckDetail(deck: element)),
            )
          },
        ),
      );
    });
    return widgets;
  }
}
