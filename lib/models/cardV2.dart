class CardV2 {
  final int? id;
  final String? name;
  final String? type;
  final String? desc;
  final int? atk;
  final int? def;
  final int? level;
  final String? race;
  final String? attribute;
  final String? archetype;
  final int? linkval;
  final List<String>? linkmarkers;
  final int? scale;
  final List<CardSets>? cardSets;
  final List<CardImages>? cardImages;
  final List<CardPrices>? cardPrices;

  CardV2({
    this.id,
    this.name,
    this.type,
    this.desc,
    this.atk,
    this.def,
    this.level,
    this.race,
    this.attribute,
    this.archetype,
    this.linkval,
    this.linkmarkers,
    this.scale,
    this.cardSets,
    this.cardImages,
    this.cardPrices,
  });

  CardV2.fromJson(Map<String, dynamic> json)
      :  id = json['id'] as int?,
        name = json['name'] as String?,
        type = json['type'] as String?,
        desc = json['desc'] as String?,
        atk = json['atk'] as int?,
        def = json['def'] as int?,
        level = json['level'] as int?,
        race = json['race'] as String?,
        attribute = json['attribute'] as String?,
        archetype = json['archetype'] as String?,
        linkval = json['linkval'] as int?,
        linkmarkers = (json['linkmarkers'] as List?)?.map((dynamic e) => e as String).toList(),
        scale = json['scale'] as int?,
        cardSets = (json['card_sets'] as List?)?.map((dynamic e) => CardSets.fromJson(e as Map<String,dynamic>)).toList(),
        cardImages = (json['card_images'] as List?)?.map((dynamic e) => CardImages.fromJson(e as Map<String,dynamic>)).toList(),
        cardPrices = (json['card_prices'] as List?)?.map((dynamic e) => CardPrices.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'type' : type,
    'desc' : desc,
    'atk' : atk,
    'def' : def,
    'level' : level,
    'race' : race,
    'attribute' : attribute,
    'archetype' : archetype,
    'linkval' : linkval,
    'linkmarkers' : linkmarkers,
    'scale' : scale,
    'card_sets' : cardSets?.map((e) => e.toJson()).toList(),
    'card_images' : cardImages?.map((e) => e.toJson()).toList(),
    'card_prices' : cardPrices?.map((e) => e.toJson()).toList()
  };
}

class CardSets {
  final String? setName;
  final String? setCode;
  final String? setRarity;
  final String? setRarityCode;
  final String? setPrice;

  CardSets({
    this.setName,
    this.setCode,
    this.setRarity,
    this.setRarityCode,
    this.setPrice,
  });

  CardSets.fromJson(Map<String, dynamic> json)
      : setName = json['set_name'] as String?,
        setCode = json['set_code'] as String?,
        setRarity = json['set_rarity'] as String?,
        setRarityCode = json['set_rarity_code'] as String?,
        setPrice = json['set_price'] as String?;

  Map<String, dynamic> toJson() => {
    'set_name' : setName,
    'set_code' : setCode,
    'set_rarity' : setRarity,
    'set_rarity_code' : setRarityCode,
    'set_price' : setPrice
  };
}

class CardImages {
  final int? id;
  final String? imageUrl;
  final String? imageUrlSmall;
  final String? imageUrlCroppped;

  CardImages({
    this.id,
    this.imageUrl,
    this.imageUrlSmall,
    this.imageUrlCroppped,
  });

  CardImages.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        imageUrl = json['image_url'] as String?,
        imageUrlSmall = json['image_url_small'] as String?,
        imageUrlCroppped = json['image_url_croppped'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'image_url' : imageUrl,
    'image_url_small' : imageUrlSmall,
    'image_url_croppped' : imageUrlCroppped
  };
}

class CardPrices {
  final String? cardmarketPrice;
  final String? tcgplayerPrice;
  final String? ebayPrice;
  final String? amazonPrice;
  final String? coolstuffincPrice;

  CardPrices({
    this.cardmarketPrice,
    this.tcgplayerPrice,
    this.ebayPrice,
    this.amazonPrice,
    this.coolstuffincPrice,
  });

  CardPrices.fromJson(Map<String, dynamic> json)
      : cardmarketPrice = json['cardmarket_price'] as String?,
        tcgplayerPrice = json['tcgplayer_price'] as String?,
        ebayPrice = json['ebay_price'] as String?,
        amazonPrice = json['amazon_price'] as String?,
        coolstuffincPrice = json['coolstuffinc_price'] as String?;

  Map<String, dynamic> toJson() => {
    'cardmarket_price' : cardmarketPrice,
    'tcgplayer_price' : tcgplayerPrice,
    'ebay_price' : ebayPrice,
    'amazon_price' : amazonPrice,
    'coolstuffinc_price' : coolstuffincPrice
  };
}