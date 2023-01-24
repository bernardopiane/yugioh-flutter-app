import 'package:flutter/material.dart';
import 'package:yugi_deck/globals.dart';
import 'package:yugi_deck/models/card_v2.dart';

import 'card_info_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<CardV2>> fetchCardList(
    String url, BuildContext context) async {
  var response = await http.post(Uri.parse(url));

  List<CardInfoEntity> cardList = [];
  List<CardV2> cardV2List = [];

  var json = jsonDecode(response.body);

  if (json["error"] != null) {
    var snackBar = SnackBar(
      content: Text(json["error"].toString()),
    );
    snackbarKey.currentState?.showSnackBar(snackBar);

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return cardV2List;
  }

  var lista = json["data"] as List;


  for (var element in lista) {
    CardInfoEntity cardInfo = CardInfoEntity.fromJson(element);
    CardV2 card = CardV2.fromJson(element);
    cardV2List.add(card);
    cardList.add(cardInfo);
  }

  debugPrint(cardV2List.elementAt(0).name);

  return cardV2List;
}

bool isExtraDeck(CardV2 card) {
  if ((card.type!.contains("Fusion Monster") ||
      card.type!.contains("Link Monster") ||
      card.type!.contains("Pendulum Effect Fusion Monster") ||
      card.type!.contains("Synchro Monster") ||
      card.type!.contains("Synchro Pendulum Effect Monster") ||
      card.type!.contains("Synchro Tuner Monster") ||
      card.type!.contains("XYZ Monster") ||
      card.type!.contains("XYZ Pendulum Effect Monster"))) {
    return true;
  }
  return false;
}


bool isBelowDeckLimit(List<CardV2> cards, bool isExtraDeck){
  if(isExtraDeck){
    if(cards.length < 15){
      return true;
    }
  } else {
    if(cards.length < 60){
      return true;
    }
  }
  return false;
}