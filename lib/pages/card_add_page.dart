import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/utils.dart';
import 'package:yugi_deck/widgets/app_bar_search.dart';
import 'package:yugi_deck/widgets/my_card.dart';
import 'package:badges/badges.dart' as badges;

import '../data.dart';
import '../models/deck.dart';
import '../variables.dart';

class CardAddPage extends StatefulWidget {
  const CardAddPage({Key? key, required this.deck, required this.addCard})
      : super(key: key);
  final Deck deck;
  final Function addCard;

  @override
  CardAddPageState createState() => CardAddPageState();
}

class CardAddPageState extends State<CardAddPage> {
  Future<List<CardV2>> cardResult = Future<List<CardV2>>.value([]);

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            AppBarSearch(searchController: _controller, search: _searchQuery),
      ),
      body: FutureBuilder<List<CardV2>>(
        future: cardResult,
        builder: (BuildContext context, AsyncSnapshot<List<CardV2>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is still loading
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there was an error while fetching the data
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If the future completed successfully, but there is no data
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: Icon(
                  Icons.warning,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            // If the future completed successfully and data is available
            List<CardV2> cardList = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: cardAspRatio,
              ),
              itemCount: cardList.length,
              itemBuilder: (BuildContext ctx, index) {
                int quantity = 0;
                if (isExtraDeck(cardList[index])) {
                  quantity = widget.deck.extra
                          ?.where((card) => cardList[index].id == card.id)
                          .length ??
                      0;
                } else {
                  quantity = widget.deck.cards
                          ?.where((card) => cardList[index].id == card.id)
                          .length ??
                      0;
                }
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        try {
                          widget.addCard(cardList[index]);
                        } catch (e) {
                          debugPrint("Error: ${e.toString()}");
                        } finally {
                          setState(() {
                            quantity++;
                          });
                        }
                      },
                      onLongPress: () {
                        // TODO: Navigate to card page
                      },
                      child: MyCard(
                        cardInfo: cardList[index],
                        noTap: true,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: badges.Badge(
                        badgeContent: Text(quantity.toString()),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  _searchQuery(String query) {
    setState(() {
      cardResult = searchCards(
          Provider.of<DataProvider>(context, listen: false).cards, query);
    });
  }
}
