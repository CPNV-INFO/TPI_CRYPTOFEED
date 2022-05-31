import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CryptosData CryptosDataFromJson(String str) =>
    CryptosData.fromJson(json.decode(str));

class CryptosData {
  CryptosData({
    required this.cryptos,
  });

  List<Cryptos> cryptos;

  factory CryptosData.fromJson(List<dynamic> json) => CryptosData(
        cryptos: List<Cryptos>.from(json.map((x) => Cryptos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "articles": List<dynamic>.from(cryptos.map((x) => x.toJson())),
      };
}

class Cryptos {
  Cryptos(
      {required this.id,
      required this.name,
      required this.image,
      required this.current_price});

  String id;
  String name;
  Image image;
  CurrentPrice current_price;

  factory Cryptos.fromJson(Map<String, dynamic> json) => Cryptos(
        id: json['id'].toString(),
        name: json['name'].toString(),
        image: Image.fromJson(json['image']),
        current_price:
            CurrentPrice.fromJson(json['market_data']['current_price']),
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "image": image, "current_price": current_price};
}

class Image {
  Image({required this.thumb, required this.small, required this.large});

  String thumb;
  String small;
  String large;

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(thumb: json['thumb'], small: json['small'], large: json['large']);

  Map<String, dynamic> toJson() =>
      {"thumb": thumb, "small": small, "large": large};
}

class CurrentPrice {
  CurrentPrice({required this.usd, required this.chf, required this.eur});

  String usd;
  String chf;
  String eur;

  factory CurrentPrice.fromJson(Map<String, dynamic> json) => CurrentPrice(
      usd: json['usd'].toString(),
      chf: json['chf'].toString(),
      eur: json['eur'].toString());

  Map<String, dynamic> toJson() => {"usd": usd, "chf": chf, "eur": eur};
}
