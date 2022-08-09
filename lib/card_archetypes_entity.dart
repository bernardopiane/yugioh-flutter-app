import 'package:yugi_deck/generated/json/base/json_field.dart';
import 'package:yugi_deck/generated/json/card_archetypes_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class CardArchetypesEntity {

	@JSONField(name: "archetype_name")
	String? archetypeName;
  
  CardArchetypesEntity();

  factory CardArchetypesEntity.fromJson(Map<String, dynamic> json) => $CardArchetypesEntityFromJson(json);

  Map<String, dynamic> toJson() => $CardArchetypesEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}