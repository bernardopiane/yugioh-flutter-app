import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:yugi_deck/models/card_v2.dart';
import 'package:yugi_deck/utils.dart';

import '../generated/json/base/json_field.dart';

@JsonSerializable()
class Deck {
  String? id;
  String name;
  String? description;

  List<CardV2>? cards;
  List<CardV2>? extra;

  DateTime? lastUpdated;

  Deck.withId(this.name, this.id);

  Deck(this.name) {
    id = const Uuid().v4();
    lastUpdated = DateTime.now(); // Set the savedDate when the deck is created
    cards = [];
    extra = [];
  }

  Deck.complete({
    this.id,
    required this.name,
    this.description,
    this.cards,
    this.extra,
    this.lastUpdated,
  });

  Deck.fromDB(this.name, this.id, this.description, this.cards, this.extra,
      this.lastUpdated);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'cards': cards?.map((card) => card.toJson()).toList(),
        'extra': extra?.map((card) => card.toJson()).toList(),
        'lastUpdated': lastUpdated
            ?.toIso8601String(), // Convert DateTime to ISO8601 string
      };

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck.complete(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cards: (json['cards'] as List<dynamic>?)
          ?.map((cardJson) => CardV2.fromJson(cardJson))
          .toList(),
      extra: (json['extra'] as List<dynamic>?)
          ?.map((cardJson) => CardV2.fromJson(cardJson))
          .toList(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  int getCardsLength() {
    int len = 0;
    for (var card in cards!) {
      if (!isExtraDeck(card)) {
        len++;
      }
    }
    return len;
  }

  int getExtraLength() {
    int len = 0;
    for (var card in cards!) {
      if (isExtraDeck(card)) {
        len++;
      }
    }
    return len;
  }

  setDescription(String desc) {
    description = desc;
    updateSavedDate();
  }

  void addCard(CardV2 card) {
    // Initialize cards and extra with no cards
    initializeDeck();

    debugPrint("Entered addCard");
    if (isExtraDeck(card)) {
      if (extra != null && extra!.length >= 15) {
        throw Exception('Extra deck can have a maximum of 15 cards');
      }
      if (extra != null && hasThreeCopies(extra!, card)) {
        throw Exception('Deck already contains 3 copies of the card');
      }
      if (extra != null) {
        extra!.add(card);
      }
    } else {
      if (cards != null && cards!.length >= 60) {
        throw Exception('Deck can have a maximum of 60 cards');
      }
      if (cards != null && hasThreeCopies(cards!, card)) {
        throw Exception('Deck already contains 3 copies of the card');
      }
      if (cards != null) {
        cards!.add(card);
      }
    }
    updateSavedDate();
  }

  void initializeDeck() {
    // If variable is not initialized, initialize it with empty lists
    cards ??= [];
    extra ??= [];
    updateSavedDate();
  }

  setCards(List<CardV2> cardList) {
    cards = cardList;
    updateSavedDate();
  }

  setExtra(List<CardV2> cardList) {
    extra = cardList;
    updateSavedDate();
  }

  removeCard(CardV2 card) {
    // CardInDeck cardInDeck = CardInDeck(card);
    cards!.remove(card);
    updateSavedDate();
  }

  removeExtra(CardV2 card) {
    // CardInDeck cardInDeck = CardInDeck(card);
    extra!.remove(card);
    updateSavedDate();
  }

  rename(String newName) {
    name = newName;
    updateSavedDate();
  }

  bool hasThreeCopies(List<CardV2> array, CardV2 card) {
    // Filter the array based on the ID
    List<CardV2> filtered =
        array.where((element) => element.id == card.id).toList();

    // Check if the filtered result has at least 3 copies
    return filtered.length >= 3;
  }

  sortDeck() {
    // cards?.sort(compareCards);
    cards?.sort((a, b) {
      // First, sort by type (monster > spell > trap)
      if (a.type!.contains("Monster") && !b.type!.contains("Monster")) {
        return -1;
      } else if (a.type!.contains("Spell") && b.type!.contains("Trap")) {
        return -1;
      } else if (a.type!.contains("Spell") && b.type!.contains("Monster")) {
        return 1;
      } else if (a.type!.contains("Trap") && !b.type!.contains("Trap")) {
        return 1;
      }

      // Then, sort by name
      return a.name!.compareTo(b.name!);
    });
    lastUpdated = DateTime.now();
  }

  // Update savedDate to the current time
  void updateSavedDate() {
    lastUpdated = DateTime.now();
  }

  Future<void> loadDataFromDB(Map<String, dynamic> firestoreData) async {
    try {
      // Convert the savedDate from Firestore to DateTime
      final dbSavedDate = DateTime.parse(firestoreData['savedDate']);

      // Compare saved dates
      if (dbSavedDate
          .isAfter(lastUpdated ?? DateTime.fromMillisecondsSinceEpoch(0))) {
        // Firestore data is newer, update local data
        name = firestoreData['name'];
        description = firestoreData['description'];
        lastUpdated = dbSavedDate;

        cards = firestoreData['cards'];
        extra = firestoreData['extra'];
      }
    } catch (e) {
      // TODO Handle errors (e.g., parsing error, invalid data, etc.)
      if (kDebugMode) {
        print('Error loading data from Firestore: $e');
      }
    }
  }

  void copyFrom(
      {required String name,
      String? description,
      List<CardV2>? cards,
      List<CardV2>? extra,
      DateTime? lastUpdated}) {
    this.name = name;
    this.description = description;
    this.cards = cards;
    this.extra = extra;
    this.lastUpdated = lastUpdated;
  }

  //   Base64
  // TODO Create buttons to share and import deck using base64
  String toBase64() {
    String jsonString = jsonEncode(toJson());
    String base64String = base64Encode(utf8.encode(jsonString));
    return base64String;
  }

  // Decode base64 string to Deck object
  static Deck fromBase64(String base64String) {
    String jsonString = utf8.decode(base64Decode(base64String));
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Deck.fromJson(jsonMap);
  }
}
