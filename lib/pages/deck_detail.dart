import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/models/deck.dart';
import 'package:yugi_deck/models/deck_list_getx.dart';
import 'package:yugi_deck/utils.dart';
import 'package:yugi_deck/variables.dart';
import 'package:yugi_deck/widgets/card_width_slider.dart';
import 'package:yugi_deck/widgets/my_card.dart';
import 'package:yugi_deck/pages/card_add_page.dart';

class DeckDetail extends StatefulWidget {
  const DeckDetail({Key? key, required this.deck}) : super(key: key);
  final Deck deck;

  @override
  State<DeckDetail> createState() => _DeckDetailState();
}

class _DeckDetailState extends State<DeckDetail> {
  late final SharedPreferences prefs;

  late Future<List<CardV2>> data;

  List<CardV2> deckCards = [];
  List<CardV2> extraCards = [];

  String? inputCardName;

  double cardWidth = 100;

  bool displayDeleteView = false;

  bool hasChanged = false;

  int howManyInDeck = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => setState(() {
          prefs = value;
          if (prefs.getDouble("cardWidth") != null) {
            cardWidth = prefs.getDouble("cardWidth")!;
          }
        }));
    setState(() {
      data = fetchCardList(
          "https://db.ygoprodeck.com/api/v7/cardinfo.php?staple=yes", context);
      if (widget.deck.cards != null) {
        deckCards = widget.deck.cards!;
      }
      if (widget.deck.extra != null) {
        extraCards = widget.deck.extra!;
      }
    });
    //  Load from local file if exists
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        bottomNavigationBar: Material(
          color: Theme.of(context).dialogBackgroundColor,
          elevation: 2,
          child: TabBar(
            labelColor: Theme.of(context).textTheme.bodyMedium?.color,
            tabs: [
              Tab(
                child: Text("Main - ${deckCards.length.toString()}"),
              ),
              Tab(
                child: Text("Extra - ${extraCards.length.toString()}"),
              ),
            ],
          ),
        ),
        appBar: displayDeleteView
            ? AppBar(
                title: const Text("Remove card(s)"),
                actions: [
                  IconButton(
                    onPressed: () {
                      toggleDeleteView();
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              )
            : AppBar(
                title: Text(widget.deck.name),
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleClick(value),
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'adjustSize',
                          child: ListTile(
                            leading: Icon(Icons.photo_size_select_large),
                            title: Text('Adjust Card Size'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'copyToClipboard',
                          child: ListTile(
                            leading: Icon(Icons.copy),
                            title: Text('Copy to Clipboard'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'toggleDeleteView',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete a Card'),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
        floatingActionButton: !displayDeleteView
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardAddPage(
                        deck: widget.deck,
                        addCard: _addCard,
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.amber[800],
                child: const Icon(Icons.add),
              )
            : null,
        body: TabBarView(
          children: [
            SafeArea(
              minimum: const EdgeInsets.all(8),
              child: GridView.builder(
                  itemCount: deckCards.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: cardWidth,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: cardAspRatio,
                  ),
                  itemBuilder: (BuildContext ctx, index) {
                    if (displayDeleteView) {
                      return Stack(
                        children: [
                          MyCard(
                            cardInfo: deckCards.elementAt(index),
                            fullImage: true,
                            noTap: true,
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: FloatingActionButton(
                                onPressed: () {
                                  deleteCard(deckCards.elementAt(index));
                                },
                                backgroundColor: Colors.red,
                                mini: true,
                                child: const Icon(Icons.close),
                              )),
                        ],
                      );
                    } else {
                      return MyCard(
                        cardInfo: deckCards.elementAt(index),
                        fullImage: true,
                      );
                    }
                  }),
            ),
            SafeArea(
              minimum: const EdgeInsets.all(8),
              child: GridView.builder(
                  itemCount: extraCards.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: cardWidth,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: cardAspRatio,
                  ),
                  itemBuilder: (BuildContext ctx, index) {
                    if (displayDeleteView) {
                      return Stack(
                        children: [
                          MyCard(
                            cardInfo: extraCards.elementAt(index),
                            fullImage: true,
                            noTap: true,
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: FloatingActionButton(
                                onPressed: () {
                                  deleteCard(extraCards.elementAt(index));
                                },
                                backgroundColor: Colors.red,
                                mini: true,
                                child: const Icon(Icons.close),
                              )),
                        ],
                      );
                    } else {
                      return MyCard(
                        cardInfo: extraCards.elementAt(index),
                        fullImage: true,
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  addToState(CardV2 element) {
    //TODO: Check if api returns extra deck type - remove hardcoded
    if (isExtraDeck(element)) {
      if (extraCards.length <= 15) {
        setState(() {
          extraCards.add(element);
          extraCards.sort((a, b) => a.name!.compareTo(b.name!));
          hasChanged = true;
        });
        _saveDeck();
      }
    } else {
      if (deckCards.length <= 60) {
        setState(() {
          deckCards.add(element);
          deckCards.sort((a, b) => a.name!.compareTo(b.name!));
          hasChanged = true;
        });
        _saveDeck();
      }
    }
  }

  void _saveDeck() async {

    final DeckListGetX dataProvider = Get.find<DeckListGetX>();

    dataProvider.setCards(widget.deck, deckCards);
    dataProvider.setExtra(widget.deck, extraCards);

    await dataProvider.saveToFile(widget.deck);

    hasChanged = false;
  }

  void changeWidth(double value) {
    setState(() {
      cardWidth = value;
    });
  }

  void toggleDeleteView() {
    setState(() {
      displayDeleteView = !displayDeleteView;
    });
  }

  void deleteCard(CardV2 card) {
    if (isExtraDeck(card)) {
      setState(() {
        extraCards.remove(card);
        hasChanged = true;
      });
      _saveDeck();
    } else {
      setState(() {
        deckCards.remove(card);
        hasChanged = true;
      });
      _saveDeck();
    }
  }

  void _addCard(CardV2 card) {
    try {
      setState(() {
        widget.deck.addCard(card);
      });
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      showSnackBar(e.toString());
      return; // Add a return statement here to exit the method
    } finally {
      widget.deck.sortDeck();
      hasChanged = true;
    }
    _saveDeck();
  }

  void _copyToClipboardAndShowMessage() {
    String base64String = widget.deck.toBase64();

    FlutterClipboard.copy(base64String).then((value) {
      showSnackBar("Data has been copied to the clipboard.");
    });
  }

  _handleClick(String value) {
    switch (value) {
      case "adjustSize":
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return CardWidthSlider(
              notifyParent: changeWidth,
              currentWidth: cardWidth,
            );
          },
        );
        break;

      case "copyToClipboard":
        _copyToClipboardAndShowMessage();
        break;

      case "toggleDeleteView":
        toggleDeleteView();
        break;

      default:
    }
  }
}
