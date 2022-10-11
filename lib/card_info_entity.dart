import 'package:yugi_deck/generated/json/base/json_field.dart';
import 'package:yugi_deck/generated/json/card_info_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class CardInfoEntity {

	int? id;
	String? name;
	String? type;
	String? desc;
	int? atk;
	int? def;
	int? level;
	String? race;
	String? attribute;
	String? archetype;
	int? linkval;
	int? scale;
	List<String>? linkmarkers;
	@JSONField(name: "card_sets")
	List<CardInfoCardSets>? cardSets;
	@JSONField(name: "card_images")
	List<CardInfoCardImages>? cardImages;
	@JSONField(name: "card_prices")
	List<CardInfoCardPrices>? cardPrices;
  
  CardInfoEntity();

  factory CardInfoEntity.fromJson(Map<String, dynamic> json) => $CardInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $CardInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CardInfoCardSets {

	@JSONField(name: "set_name")
	String? setName;
	@JSONField(name: "set_code")
	String? setCode;
	@JSONField(name: "set_rarity")
	String? setRarity;
	@JSONField(name: "set_rarity_code")
	String? setRarityCode;
	@JSONField(name: "set_price")
	String? setPrice;
  
  CardInfoCardSets();

  factory CardInfoCardSets.fromJson(Map<String, dynamic> json) => $CardInfoCardSetsFromJson(json);

  Map<String, dynamic> toJson() => $CardInfoCardSetsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CardInfoCardImages {

	int? id;
	@JSONField(name: "image_url")
	String? imageUrl;
	@JSONField(name: "image_url_small")
	String? imageUrlSmall;
  
  CardInfoCardImages();

  factory CardInfoCardImages.fromJson(Map<String, dynamic> json) => $CardInfoCardImagesFromJson(json);

  Map<String, dynamic> toJson() => $CardInfoCardImagesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CardInfoCardPrices {

	@JSONField(name: "cardmarket_price")
	String? cardmarketPrice;
	@JSONField(name: "tcgplayer_price")
	String? tcgplayerPrice;
	@JSONField(name: "ebay_price")
	String? ebayPrice;
	@JSONField(name: "amazon_price")
	String? amazonPrice;
	@JSONField(name: "coolstuffinc_price")
	String? coolstuffincPrice;
  
  CardInfoCardPrices();

  factory CardInfoCardPrices.fromJson(Map<String, dynamic> json) => $CardInfoCardPricesFromJson(json);

  Map<String, dynamic> toJson() => $CardInfoCardPricesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}