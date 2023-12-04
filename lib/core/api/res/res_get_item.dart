// To parse this JSON data, do
//
//     final resGetItem = resGetItemFromJson(jsonString);

import 'dart:convert';

ResGetItem resGetItemFromJson(String str) =>
    ResGetItem.fromJson(json.decode(str));

String resGetItemToJson(ResGetItem data) => json.encode(data.toJson());

class ResGetItem {
  ResGetItem({
    this.data,
  });

  Data? data;

  factory ResGetItem.fromJson(Map<String, dynamic> json) => ResGetItem(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.items,
  });

  List<Item>? items;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    this.quantity,
    this.subtotal,
    this.product,
    this.order,
  });

  String? id;
  int? quantity;
  int? subtotal;
  Product? product;
  Order? order;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        quantity: json["quantity"],
        subtotal: json["subtotal"],
        product: Product.fromJson(json["product"]),
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "subtotal": subtotal,
        "product": product!.toJson(),
        "order": order == null ? null : order!.toJson(),
      };
}

class Order {
  Order({
    this.id,
    this.transactionId,
    this.paymentStatus,
    this.paymentUrl,
    this.orderStatus,
    this.totalQuantity,
    this.totalPrice,
  });

  String? id;
  dynamic? transactionId;
  String? paymentStatus;
  dynamic? paymentUrl;
  String? orderStatus;
  int? totalQuantity;
  int? totalPrice;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        transactionId: json["transactionId"],
        paymentStatus: json["paymentStatus"],
        paymentUrl: json["paymentUrl"],
        orderStatus: json["orderStatus"],
        totalQuantity: json["totalQuantity"],
        totalPrice: json["totalPrice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transactionId": transactionId,
        "paymentStatus": paymentStatus,
        "paymentUrl": paymentUrl,
        "orderStatus": orderStatus,
        "totalQuantity": totalQuantity,
        "totalPrice": totalPrice,
      };
}

class Product {
  Product(
      {this.id,
      this.name,
      this.price,
      this.images,
      this.stock,
      this.isSold,
      this.publish});

  String? id;
  String? name;
  int? price;
  List<String>? images;
  int? stock;
  bool? isSold;
  bool? publish;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      images: List<String>.from(json["images"].map((x) => x)),
      stock: json["stock"],
      isSold: json['isSold'],
      publish: json['publisj']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "stock": stock,
        "isSold": isSold,
        "publish": publish,
      };
}
