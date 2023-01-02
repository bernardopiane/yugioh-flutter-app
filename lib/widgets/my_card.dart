import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/models/cardV2.dart';
import 'package:yugi_deck/pages/card_detail.dart';

class MyCard extends StatelessWidget {
  final CardV2 cardInfo;
  final bool fullImage;
  final bool noTap;
  final longPress;
  const MyCard({Key? key, required this.cardInfo, this.fullImage = false, this.noTap = false, this.longPress = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uri imageUrl;
    if (fullImage) {
      imageUrl = Uri.parse(
          "https://images.ygoprodeck.com/images/cards/${cardInfo.id.toString()}.jpg");
    } else {
      imageUrl = Uri.parse(
          "https://images.ygoprodeck.com/images/cards_small/${cardInfo.id.toString()}.jpg");
    }
    // return InkWell(
    //   onTap: () {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => CardDetail(card: cardInfo),
    //       ),
    //     );
    //   },
    //   child: CachedNetworkImage(
    //     imageUrl: imageUrl.toString(),
    //     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
    //       heightFactor: 30,
    //       widthFactor: 30,
    //       child: CircularProgressIndicator(value: downloadProgress.progress),
    //     ),
    //     errorWidget: (context, url, error) => const Icon(Icons.error),
    //   ),
    // );
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(

          imageUrl: imageUrl.toString(),
          fit: BoxFit.contain,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            heightFactor: 30,
            widthFactor: 30,
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Material(
          color: Colors.transparent,
          //Ignore on tap event
          child: IgnorePointer(
            ignoring: noTap ? true : false,
            child: InkWell(
              onLongPress: longPress,
              onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CardDetail(card: cardInfo),
                    ),
                  );
              },
            ),
          ),
        )
      ],
    );
  }
}
