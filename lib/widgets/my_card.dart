import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';
import 'package:yugi_deck/pages/card_detail.dart';

class MyCard extends StatelessWidget {
  final CardInfoEntity cardInfo;
  final bool fullImage = false;
  final noTap;
  const MyCard({Key? key, required this.cardInfo, fullImage = false, this.noTap = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uri imageUrl;
    if (fullImage) {
      imageUrl = Uri.parse(
          "https://storage.googleapis.com/ygoprodeck.com/pics/${cardInfo.id.toString()}.jpg");
    } else {
      imageUrl = Uri.parse(
          "https://storage.googleapis.com/ygoprodeck.com/pics_small/${cardInfo.id.toString()}.jpg");
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
          child: IgnorePointer(
            ignoring: noTap ? true : false,
            child: InkWell(
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
