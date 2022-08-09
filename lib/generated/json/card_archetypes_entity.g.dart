import 'package:yugi_deck/generated/json/base/json_convert_content.dart';
import 'package:yugi_deck/card_archetypes_entity.dart';

CardArchetypesEntity $CardArchetypesEntityFromJson(Map<String, dynamic> json) {
	final CardArchetypesEntity cardArchetypesEntity = CardArchetypesEntity();
	final String? archetypeName = jsonConvert.convert<String>(json['archetype_name']);
	if (archetypeName != null) {
		cardArchetypesEntity.archetypeName = archetypeName;
	}
	return cardArchetypesEntity;
}

Map<String, dynamic> $CardArchetypesEntityToJson(CardArchetypesEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['archetype_name'] = entity.archetypeName;
	return data;
}