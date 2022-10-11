class CardArchetype {
  String? archetypeName;

  CardArchetype({this.archetypeName});

  CardArchetype.fromJson(Map<String, dynamic> json) {
    archetypeName = json['archetype_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['archetype_name'] = archetypeName;
    return data;
  }
}