import 'package:yugi_deck/generated/json/base/json_convert_content.dart';
import 'package:yugi_deck/card_info_entity.dart';

CardInfoEntity $CardInfoEntityFromJson(Map<String, dynamic> json) {
	final CardInfoEntity cardInfoEntity = CardInfoEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		cardInfoEntity.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		cardInfoEntity.name = name;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		cardInfoEntity.type = type;
	}
	final String? desc = jsonConvert.convert<String>(json['desc']);
	if (desc != null) {
		cardInfoEntity.desc = desc;
	}
	final int? atk = jsonConvert.convert<int>(json['atk']);
	if (atk != null) {
		cardInfoEntity.atk = atk;
	}
	final int? def = jsonConvert.convert<int>(json['def']);
	if (def != null) {
		cardInfoEntity.def = def;
	}
	final int? level = jsonConvert.convert<int>(json['level']);
	if (level != null) {
		cardInfoEntity.level = level;
	}
	final String? race = jsonConvert.convert<String>(json['race']);
	if (race != null) {
		cardInfoEntity.race = race;
	}
	final String? attribute = jsonConvert.convert<String>(json['attribute']);
	if (attribute != null) {
		cardInfoEntity.attribute = attribute;
	}
	final String? archetype = jsonConvert.convert<String>(json['archetype']);
	if (archetype != null) {
		cardInfoEntity.archetype = archetype;
	}
	final int? linkval = jsonConvert.convert<int>(json['linkval']);
	if (linkval != null) {
		cardInfoEntity.linkval = linkval;
	}
	final int? scale = jsonConvert.convert<int>(json['scale']);
	if (scale != null) {
		cardInfoEntity.scale = scale;
	}
	final List<String>? linkmarkers = jsonConvert.convertListNotNull<String>(json['linkmarkers']);
	if (linkmarkers != null) {
		cardInfoEntity.linkmarkers = linkmarkers;
	}
	final List<CardInfoCardSets>? cardSets = jsonConvert.convertListNotNull<CardInfoCardSets>(json['card_sets']);
	if (cardSets != null) {
		cardInfoEntity.cardSets = cardSets;
	}
	final List<CardInfoCardImages>? cardImages = jsonConvert.convertListNotNull<CardInfoCardImages>(json['card_images']);
	if (cardImages != null) {
		cardInfoEntity.cardImages = cardImages;
	}
	final List<CardInfoCardPrices>? cardPrices = jsonConvert.convertListNotNull<CardInfoCardPrices>(json['card_prices']);
	if (cardPrices != null) {
		cardInfoEntity.cardPrices = cardPrices;
	}
	return cardInfoEntity;
}

Map<String, dynamic> $CardInfoEntityToJson(CardInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['type'] = entity.type;
	data['desc'] = entity.desc;
	data['atk'] = entity.atk;
	data['def'] = entity.def;
	data['level'] = entity.level;
	data['race'] = entity.race;
	data['attribute'] = entity.attribute;
	data['archetype'] = entity.archetype;
	data['linkval'] = entity.linkval;
	data['scale'] = entity.scale;
	data['linkmarkers'] =  entity.linkmarkers;
	data['card_sets'] =  entity.cardSets?.map((v) => v.toJson()).toList();
	data['card_images'] =  entity.cardImages?.map((v) => v.toJson()).toList();
	data['card_prices'] =  entity.cardPrices?.map((v) => v.toJson()).toList();
	return data;
}

CardInfoCardSets $CardInfoCardSetsFromJson(Map<String, dynamic> json) {
	final CardInfoCardSets cardInfoCardSets = CardInfoCardSets();
	final String? setName = jsonConvert.convert<String>(json['set_name']);
	if (setName != null) {
		cardInfoCardSets.setName = setName;
	}
	final String? setCode = jsonConvert.convert<String>(json['set_code']);
	if (setCode != null) {
		cardInfoCardSets.setCode = setCode;
	}
	final String? setRarity = jsonConvert.convert<String>(json['set_rarity']);
	if (setRarity != null) {
		cardInfoCardSets.setRarity = setRarity;
	}
	final String? setRarityCode = jsonConvert.convert<String>(json['set_rarity_code']);
	if (setRarityCode != null) {
		cardInfoCardSets.setRarityCode = setRarityCode;
	}
	final String? setPrice = jsonConvert.convert<String>(json['set_price']);
	if (setPrice != null) {
		cardInfoCardSets.setPrice = setPrice;
	}
	return cardInfoCardSets;
}

Map<String, dynamic> $CardInfoCardSetsToJson(CardInfoCardSets entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['set_name'] = entity.setName;
	data['set_code'] = entity.setCode;
	data['set_rarity'] = entity.setRarity;
	data['set_rarity_code'] = entity.setRarityCode;
	data['set_price'] = entity.setPrice;
	return data;
}

CardInfoCardImages $CardInfoCardImagesFromJson(Map<String, dynamic> json) {
	final CardInfoCardImages cardInfoCardImages = CardInfoCardImages();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		cardInfoCardImages.id = id;
	}
	final String? imageUrl = jsonConvert.convert<String>(json['image_url']);
	if (imageUrl != null) {
		cardInfoCardImages.imageUrl = imageUrl;
	}
	final String? imageUrlSmall = jsonConvert.convert<String>(json['image_url_small']);
	if (imageUrlSmall != null) {
		cardInfoCardImages.imageUrlSmall = imageUrlSmall;
	}
	return cardInfoCardImages;
}

Map<String, dynamic> $CardInfoCardImagesToJson(CardInfoCardImages entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['image_url'] = entity.imageUrl;
	data['image_url_small'] = entity.imageUrlSmall;
	return data;
}

CardInfoCardPrices $CardInfoCardPricesFromJson(Map<String, dynamic> json) {
	final CardInfoCardPrices cardInfoCardPrices = CardInfoCardPrices();
	final String? cardmarketPrice = jsonConvert.convert<String>(json['cardmarket_price']);
	if (cardmarketPrice != null) {
		cardInfoCardPrices.cardmarketPrice = cardmarketPrice;
	}
	final String? tcgplayerPrice = jsonConvert.convert<String>(json['tcgplayer_price']);
	if (tcgplayerPrice != null) {
		cardInfoCardPrices.tcgplayerPrice = tcgplayerPrice;
	}
	final String? ebayPrice = jsonConvert.convert<String>(json['ebay_price']);
	if (ebayPrice != null) {
		cardInfoCardPrices.ebayPrice = ebayPrice;
	}
	final String? amazonPrice = jsonConvert.convert<String>(json['amazon_price']);
	if (amazonPrice != null) {
		cardInfoCardPrices.amazonPrice = amazonPrice;
	}
	final String? coolstuffincPrice = jsonConvert.convert<String>(json['coolstuffinc_price']);
	if (coolstuffincPrice != null) {
		cardInfoCardPrices.coolstuffincPrice = coolstuffincPrice;
	}
	return cardInfoCardPrices;
}

Map<String, dynamic> $CardInfoCardPricesToJson(CardInfoCardPrices entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['cardmarket_price'] = entity.cardmarketPrice;
	data['tcgplayer_price'] = entity.tcgplayerPrice;
	data['ebay_price'] = entity.ebayPrice;
	data['amazon_price'] = entity.amazonPrice;
	data['coolstuffinc_price'] = entity.coolstuffincPrice;
	return data;
}