class FilterOptions {
  List<String> cardTypes = [];
  List<String> attributes = [];
  List<String> spellTrapTypes = [];
  List<String> monsterTypes = [];
  List<int> levels = [];

  @override
  toString() {
    return "Current: ${cardTypes.toString()} - ${attributes.toString()} - ${spellTrapTypes.toString()} - ${monsterTypes.toString()} - ${levels.toString()} - ";
  }

  bool isDefaultFilter() {
    return cardTypes.isEmpty &&
        attributes.isEmpty &&
        levels.isEmpty &&
        monsterTypes.isEmpty &&
        spellTrapTypes.isEmpty;
  }
}
