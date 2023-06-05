import 'package:flutter/material.dart';
import 'package:yugi_deck/models/card_race.dart';

class Race extends StatelessWidget {
  const Race({Key? key, required this.filter}) : super(key: key);
  final String? filter;

  @override
  Widget build(BuildContext context) {
    List<String> tempVar = [];

    switch(filter) {
      case "monster":
        tempVar = monsterRaceList;
        break;
      case "trap":
        tempVar = trapRaceList;
        break;
      case "spell":
        tempVar = spellRaceList;
        break;
      default:
        break;
    }

    return Text("Race Widget: ${tempVar.toString()}");
  }
}
