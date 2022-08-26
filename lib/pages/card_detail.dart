import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/pages/card_set_page.dart';
import 'package:yugi_deck/widgets/card_attribute.dart';
import 'package:yugi_deck/widgets/card_level.dart';

class CardDetail extends StatelessWidget {
  const CardDetail({Key? key, required this.card}) : super(key: key);
  final CardInfoEntity card;

  @override
  Widget build(BuildContext context) {
    Uri imageUrl = Uri.parse(
        "https://storage.googleapis.com/ygoprodeck.com/pics/${card.id.toString()}.jpg");

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(context, imageUrl),
                    const SizedBox(height: 8),
                    if (card.attribute != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CardAttribute(attribute: card.attribute!),
                          CardLevel(level: card.level!)
                        ],
                      ),
                    if (card.attribute == null) Text("[${card.type}]"),
                    if (card.race != null)
                      //TODO: Create race widget
                      Text("[${card.race} / ${card.type}]"),
                    const SizedBox(height: 8),
                    Text(card.desc!),
                    const SizedBox(height: 8),
                    if (card.level != null)
                      Text("ATK/ ${card.atk} DEF/ ${card.def}"),
                    const SizedBox(height: 8),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: _buildCardSet(card.cardSets!),
                    // ),
                    if (card.cardSets != null)
                      _buildCardSet(context, card.cardSets!)
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(context, imageUrl),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          if (card.attribute != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardAttribute(attribute: card.attribute!),
                                CardLevel(level: card.level!)
                              ],
                            ),
                          if (card.attribute == null) Text("[${card.type}]"),
                          if (card.race != null)
                            //TODO: Create race widget
                            Text("[${card.race} / ${card.type}]"),
                          const SizedBox(height: 8),
                          Text(card.desc!),
                          const SizedBox(height: 8),
                          if (card.level != null)
                            Text("ATK/ ${card.atk} DEF/ ${card.def}"),
                          const SizedBox(height: 8),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: _buildCardSet(card.cardSets!),
                          // ),
                          if (card.cardSets != null)
                            _buildCardSet(context, card.cardSets!)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  _buildCardSet(context, List<CardInfoCardSets> cardSets) {
    List<Widget> widgets = [];

    for (var element in cardSets) {
      widgets.add(
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CardSetPage(setName: element.setName!)));
          },
          style: ListTileStyle.list,
          title: Text("${element.setName} - ${element.setRarity}"),
        ),
      );
    }

    return ExpandablePanel(
      theme: ExpandableThemeData(
        iconColor: Theme.of(context).colorScheme.secondary
      ),
      header: const Text(
        "How to Obtain",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      collapsed: Text("Available in ${widgets.length} packs"),
      expanded: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ListTile.divideTiles(
          tiles: widgets,
          color: Colors.grey.shade400,
        ).toList(),
      ),
    );
  }

  _buildImage(context, imageUrl) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          //Dismiss on click: false
          pageBuilder: (context, animation, secondaryAnimation) {
            return Container(
              color: Colors.black,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                  ),
                  Expanded(
                    child: Center(
                      child: PhotoView(
                        imageProvider: CachedNetworkImageProvider(
                          imageUrl.toString(),
                        ),
                        minScale: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl.toString(),
          height: 550,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            heightFactor: 30,
            widthFactor: 30,
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
