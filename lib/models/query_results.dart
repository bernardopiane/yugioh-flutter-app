import 'package:flutter/material.dart';
import 'package:yugi_deck/card_info_entity.dart';

class QueryResults extends ChangeNotifier{

  List<CardInfoEntity> cards = [];

  QueryResults(this.cards);

  setResult(List<CardInfoEntity> res){
    cards = res;
    notifyListeners();
  }
}