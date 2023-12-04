// To parse this JSON data, do
//
//     final resGetProduct = resGetProductFromJson(jsonString);

import 'dart:convert';

List<ResGetProduct> resGetProductFromJson(String str) =>
    List<ResGetProduct>.from(
        json.decode(str).map((x) => ResGetProduct.fromJson(x)));

String resGetProductToJson(List<ResGetProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResGetProduct {
  ResGetProduct({
    this.name,
    this.price,
    this.description,
    this.category,
    this.isSold,
    this.images,
    this.stock,
    this.sku,
    // this.vendor,
    this.publish,
    this.id,
  });

  String? name;
  int? price;
  String? description;
  Category? category;
  bool? isSold;
  List<String>? images;
  int? stock;
  String? sku;
  // Vendor? vendor;
  bool? publish;
  String? id;

  factory ResGetProduct.fromJson(Map<String, dynamic> json) => ResGetProduct(
        name: json["name"],
        price: json["price"],
        description: json["description"],
        category: Category.fromJson(json["category"]),
        isSold: json["isSold"] == null ? null : json["isSold"],
        images: List<String>.from(json["images"].map((x) => x)),
        stock: json["stock"],
        sku: json["sku"] == null ? null : json["sku"],
        // vendor: Vendor.fromJson(json["vendor"]),
        publish: json["publish"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "description": description,
        "category": category!.toJson(),
        "isSold": isSold == null ? null : isSold,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "stock": stock,
        "sku": sku == null ? null : sku,
        // "vendor": vendor!.toJson(),
        "publish": publish,
        "id": id,
      };
}

class Category {
  Category({
    this.name,
    this.image,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  String? name;
  String? image;
  String? id;
  String? createdAt;
  String? updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        image: json["image"] == null ? null : json["image"],
        id: json["id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image == null ? null : image,
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class Vendor {
  Vendor({
    this.name,
    this.pic,
    this.noTlp,
    this.address,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  String? name;
  String? pic;
  String? noTlp;
  String? address;
  String? id;
  String? createdAt;
  String? updatedAt;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        name: json["name"],
        pic: json["pic"] == null ? null : json["pic"],
        noTlp: json["noTlp"],
        address: json["address"],
        id: json["id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "pic": pic == null ? null : pic,
        "noTlp": noTlp,
        "address": address,
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
