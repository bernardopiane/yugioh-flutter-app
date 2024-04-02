import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yugi_deck/models/deck.dart';
import 'package:yugi_deck/models/deck_list_getx.dart';
import 'package:yugi_deck/pages/deck_detail.dart';

class DeckListPage extends StatefulWidget {
  const DeckListPage({Key? key}) : super(key: key);

  @override
  State<DeckListPage> createState() => _DeckListPageState();
}

class _DeckListPageState extends State<DeckListPage> {
  String? inputDeckName;

  final DeckListGetX deckListGetX = Get.put(DeckListGetX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(labelText: "Deck name"),
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
                      if (inputDeckName != null && inputDeckName!.isNotEmpty) {
                        final DeckListGetX deckProvider =
                            Get.find<DeckListGetX>();

                        deckProvider.addDeck(Deck(inputDeckName!));
                        inputDeckName = "";
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.amber[800],
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Deck List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.import_export), // Replace with your icon
            onPressed: () {
              _showInputDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.only(top: 8),
            children: _buildDeckList(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDeckList(BuildContext context) {
    final DeckListGetX deckListGetX = Get.find<DeckListGetX>();

    return deckListGetX.decks.map((element) {
      return Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          title: Text(element.name),
          trailing: PopupMenuButton<String>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(
                  value: 'rename',
                  child: Text('Rename'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ];
            },
            onSelected: (String value) {
              if (value == "delete") {
                final DeckListGetX deckListGetX = Get.find<DeckListGetX>();

                deckListGetX.deleteDeck(element.id!);
              } else if (value == "rename") {
                _showRenameDialog(context, element);
              }
            },
          ),
          onTap: () {
            Get.to(() => DeckDetail(deck: element));
          },
        ),
      );
    }).toList();
  }

  void _showRenameDialog(BuildContext context, Deck deck) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(labelText: "Deck name"),
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
                if (inputDeckName != null && inputDeckName!.isNotEmpty) {
                  final DeckListGetX deckListGetX = Get.find<DeckListGetX>();

                  deckListGetX.renameDeck(deck, inputDeckName!);
                  inputDeckName = "";
                  Navigator.pop(context);
                }
              },
              child: const Text("Rename"),
            ),
          ],
        );
      },
    );
  }
}

void _showInputDialog(BuildContext context) {
  String userInput = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter a String'),
        content: TextField(
          onChanged: (value) {
            userInput = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog

              if (userInput.isNotEmpty) {
                _importDeckFromBase64(userInput, context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void _importDeckFromBase64(String data, BuildContext context) {
  final DeckListGetX deckListGetX = Get.find<DeckListGetX>();

  Uuid uuid = const Uuid();
  Deck newDeck = Deck.fromBase64(data);
  newDeck.id = uuid.v4();
  deckListGetX.addDeck(newDeck);
}
