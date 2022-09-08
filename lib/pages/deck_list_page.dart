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
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: ListView(
          children: [
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: TextFormField(
                            decoration: const InputDecoration(
                                label: Text("Deck name: ")),
                            onFieldSubmitted: (value){
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
                child: const Text("Add to Deck")),
            const ListTile(
              title: Text("Deck List"),
            ),
            ..._buildDeckList(context)
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDeckList(BuildContext context) {
    List<Widget> widgets = [];

    Provider.of<DeckList>(context).decks.forEach((element) {
      widgets.add(
        ListTile(
          title: Text(element.name),
          onLongPress: (){
          //  TODO display actions
          },
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

  // void _loadData() {
  //   final directory = getApplicationDocumentsDirectory().then((value) {
  //     //TODO Create directory if not found
  //     Directory("${value.path}/decks").exists().then((directoryExists) {
  //       if (!directoryExists) {
  //         Directory("${value.path}/decks")
  //             .create()
  //             .then((value) => debugPrint("Directory created"));
  //       } else {
  //         debugPrint("Directory exists");
  //       }
  //     });
  //
  //     final deckDir = Directory("${value.path}/decks");
  //     deckDir.list().forEach((element) {
  //       debugPrint(element.toString());
  //       if (element.isAbsolute) {
  //         // File file = File(element.path);
  //         final File file = File(element.path);
  //         file.readAsString().then((value) {
  //           // debugPrint("File: ${element.toString()} - Content: $value");
  //           var json = jsonDecode(value);
  //           Deck deck = Deck(element.toString());
  //           List<CardInfoEntity> cardList = [];
  //           json.forEach((element) {
  //             CardInfoEntity card = CardInfoEntity.fromJson(element);
  //             cardList.add(card);
  //           });
  //           deck.addMultipleCards(cardList);
  //           // debugPrint(deck.toString());
  //         });
  //       }
  //     });
  //
  //     //TODO Read data and display
  //
  //     // final File file = File('${value.path}/${widget.deck.name}.txt');
  //   });
  // }
}
