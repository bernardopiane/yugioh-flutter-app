import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/pages/card_set_page.dart';
import 'package:yugi_deck/widgets/card_attribute.dart';
import 'package:yugi_deck/widgets/card_level.dart';
import 'package:yugi_deck/widgets/card_title.dart';
import 'package:yugi_deck/widgets/highlighted_text.dart';

import '../variables.dart';

class CardDetail extends StatelessWidget {
  const CardDetail({Key? key, required this.card}) : super(key: key);
  final CardV2 card;

  @override
  Widget build(BuildContext context) {
    Uri imageUrl = Uri.parse(
        "https://images.ygoprodeck.com/images/cards/${card.id.toString()}.jpg");

    return Scaffold(
      appBar: AppBar(
        title: CardTitle(
          title: card.name!,
        ),
      ),
      body: Container(
        child: Platform.isWindows
            ? buildLandscapeView(context, imageUrl)
            : OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return buildPortraitView(context, imageUrl);
                  } else {
                    return buildLandscapeView(context, imageUrl);
                  }
                },
              ),
      ),
    );
  }

  SingleChildScrollView buildLandscapeView(BuildContext context, Uri imageUrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
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
                if (card.attribute != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (card.attribute != null)
                        CardAttribute(attribute: card.attribute!),
                      if (card.level != null) CardLevel(level: card.level!),
                    ],
                  ),
                if (card.attribute == null) Text("[${card.type}]"),
                if (card.race != null) Text("[${card.race} / ${card.type}]"),
                const SizedBox(height: 8),
                HighlightedText(
                  text: card.desc!,
                  highlightedWords: highlightedWords,
                ),
                const SizedBox(height: 8),
                if (card.level != null)
                  Text("ATK/ ${card.atk} DEF/ ${card.def}"),
                if (card.linkval != null)
                  Text("LINK-${card.linkval.toString()}"),
                if (card.scale != null) Text("Scale: ${card.scale.toString()}"),
                if (card.linkmarkers != null)
                  Text("Points to: ${card.linkmarkers.toString()}"),
                // const SizedBox(height: 8),
                // if (card.cardSets != null)
                //   _buildCardSet(context, card.cardSets!)
              ],
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildPortraitView(BuildContext context, Uri imageUrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(context, imageUrl),
          const SizedBox(height: 8),
          if (card.attribute != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (card.attribute != null)
                  CardAttribute(attribute: card.attribute!),
                if (card.level != null) CardLevel(level: card.level!),
              ],
            ),
          const SizedBox(height: 8),
          if (card.race != null)
            Text(
              "[${card.race} / ${card.type}]",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: Theme.of(context).textTheme.titleLarge?.fontFamily,
              ),
            ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: card.desc!
                .split('\n')
                .map(
                  (line) => Text(
                    "$line \n",
                    style: TextStyle(
                      fontStyle: line.startsWith(RegExp(r'[0-9]'))
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (card.atk != null)
                Text(
                  "ATK/ ${card.atk}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              if (card.def != null)
                Text(
                  " DEF/ ${card.def}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (card.linkval != null) Text("LINK-${card.linkval.toString()}"),
          const SizedBox(height: 8),
          if (card.scale != null) Text("Scale: ${card.scale.toString()}"),
          const SizedBox(height: 8),
          if (card.linkmarkers != null)
            Text("Points to: ${card.linkmarkers.toString()}"),
          // SizedBox(height: 8),
          // if (card.cardSets != null) _buildCardSet(context, card.cardSets!)
        ],
      ),
    );
  }

  _buildCardSet(context, List<CardSets> cardSets) {
    List<Widget> widgets = [];

    for (var element in cardSets) {
      widgets.add(
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardSetPage(setName: element.setName!),
              ),
            );
          },
          style: ListTileStyle.list,
          title: Text("${element.setName} - ${element.setRarity}"),
        ),
      );
    }

    return ExpandablePanel(
      theme: ExpandableThemeData(
        iconColor: Theme.of(context).colorScheme.secondary,
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
                        minScale: 0.5,
                        maxScale: 1.5,
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
