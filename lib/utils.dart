import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yugi_deck/globals.dart';
import 'package:yugi_deck/models/card_v2.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// Future<List<CardV2>> fetchCardList(
//     String url, BuildContext context) async {
//   var response = await http.post(Uri.parse(url));
//
//   List<CardInfoEntity> cardList = [];
//   List<CardV2> cardV2List = [];
//
//   var json = jsonDecode(response.body);
//
//   if (json["error"] != null) {
//     var snackBar = SnackBar(
//       content: Text(json["error"].toString()),
//     );
//     snackbarKey.currentState?.showSnackBar(snackBar);
//
//     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     return cardV2List;
//   }
//
//   var lista = json["data"] as List;
//
//
//   for (var element in lista) {
//     CardInfoEntity cardInfo = CardInfoEntity.fromJson(element);
//     CardV2 card = CardV2.fromJson(element);
//     cardV2List.add(card);
//     cardList.add(cardInfo);
//   }
//
//   debugPrint(cardV2List.elementAt(0).name);
//
//   return cardV2List;
// }

Future<List<CardV2>> fetchCardList(String url, BuildContext context) async {
  try {
    var response =
        await http.post(Uri.parse(url)).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      List<CardV2> cardV2List = [];
      var jsonData = jsonDecode(response.body);

      if (jsonData["error"] != null) {
        showSnackBar(jsonData["error"].toString());

        return cardV2List;
      }

      var data = jsonData["data"] as List<dynamic>;

      for (var element in data) {
        CardV2 card = CardV2.fromJson(element);
        cardV2List.add(card);
      }

      return cardV2List;
    } else {
      showSnackBar(
          "Failed to fetch card data. Status code: ${response.statusCode}");
      return [];
    }
  } on TimeoutException {
    showSnackBar("Request timed out. Please check your internet connection.");
    return [];
  } on SocketException {
    showSnackBar("No internet connection.");
    return [];
  } catch (e) {
    showSnackBar("An error occurred. Please try again later.");
    return [];
  }
}

bool isExtraDeck(CardV2 card) {
  if (card.type!.contains("Fusion Monster") ||
      card.type!.contains("Link Monster") ||
      card.type!.contains("Pendulum Effect Fusion Monster") ||
      card.type!.contains("Synchro Monster") ||
      card.type!.contains("Synchro Pendulum Effect Monster") ||
      card.type!.contains("Synchro Tuner Monster") ||
      card.type!.contains("XYZ Monster") ||
      card.type!.contains("XYZ Pendulum Effect Monster")) {
    return true;
  }
  return false;
}

bool isBelowDeckLimit(List<CardV2> cards, bool isExtraDeck) {
  if (isExtraDeck && cards.length < 15) {
    return true;
  }
  if (!isExtraDeck && cards.length < 60) {
    return true;
  }
  return false;
}

Future<List<CardV2>> searchCards(List<CardV2> cards, String searchPhrase) {
  final Completer<List<CardV2>> completer = Completer<List<CardV2>>();
  final List<CardV2> searchResults = [];

  for (var card in cards) {
    if (card.name!.toLowerCase().contains(searchPhrase.toLowerCase()) ||
        card.desc!.toLowerCase().contains(searchPhrase.toLowerCase())) {
      searchResults.add(card);
    }
  }

  completer.complete(searchResults);
  return completer.future;
}

Future<List<CardV2>> convertToFuture(List<CardV2> cardList) {
  return Future.value(cardList);
}

void showSnackBar(String message) {
  snackbarKey.currentState?.clearSnackBars();
  SnackBar snackBar = SnackBar(
    content: Text(message),
  );
  snackbarKey.currentState?.showSnackBar(snackBar);
}
