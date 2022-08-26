import 'package:flutter/material.dart';
import 'package:yugi_deck/globals.dart';

import 'card_info_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<CardInfoEntity>> fetchCardList(
    String url, BuildContext context) async {
  var response = await http.post(Uri.parse(url));

  List<CardInfoEntity> cardList = [];

  var json = jsonDecode(response.body);

  if (json["error"] != null) {
    var snackBar = SnackBar(
      content: Text(json["error"].toString()),
    );
    snackbarKey.currentState?.showSnackBar(snackBar);

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return cardList;
  }

  var lista = json["data"] as List;

  for (var element in lista) {
    CardInfoEntity cardInfo = CardInfoEntity.fromJson(element);
    cardList.add(cardInfo);
  }

  return cardList;
}
