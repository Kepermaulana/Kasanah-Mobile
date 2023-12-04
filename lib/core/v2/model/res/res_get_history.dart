// To parse this JSON data, do
//
//     final resGetHistory = resGetHistoryFromJson(jsonString);

import 'dart:convert';

ResGetHistory resGetHistoryFromJson(String str) =>
    ResGetHistory.fromJson(json.decode(str));

String resGetHistoryToJson(ResGetHistory data) => json.encode(data.toJson());

class ResGetHistory {
  ResGetHistory({
    this.data,
  });

  Data? data;

  factory ResGetHistory.fromJson(Map<String, dynamic> json) => ResGetHistory(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.orders,
  });

  List<Order>? orders;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.id,
    this.transactionId,
    this.paymentStatus,
    this.orderStatus,
    this.paymentUrl,
    this.totalQuantity,
    this.totalPrice,
    this.method,
    this.evidenceImage,
    this.linkId,
    this.countdown,
    this.noInvoice,
    this.createdAt,
    this.items,
  });

  String? id;
  String? transactionId;
  String? paymentStatus;
  String? orderStatus;
  String? paymentUrl;
  int? totalQuantity;
  int? totalPrice;
  String? method;
  String? evidenceImage;
  String? linkId;
  String? countdown;
  String? noInvoice;
  String? createdAt;
  List<Item>? items;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        transactionId: json["transactionId"],
        paymentStatus: json["paymentStatus"],
        orderStatus: json["orderStatus"],
        paymentUrl: json["paymentUrl"],
        totalQuantity: json["totalQuantity"],
        totalPrice: json["totalPrice"],
        method: json["method"],
        evidenceImage: json["evidenceImage"],
        countdown: json["countdown"] == null ? null : json["countdown"],
        linkId: json["linkId"],
        noInvoice: json["noInvoice"],
        createdAt: json["createdAt"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  get products => null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "transactionId": transactionId,
        "paymentStatus": paymentStatus,
        "orderStatus": orderStatus,
        "paymentUrl": paymentUrl,
        "totalQuantity": totalQuantity,
        "totalPrice": totalPrice,
        "method": method,
        "evidenceImage": evidenceImage,
        "countdown": countdown == null ? null : countdown,
        "linkId": linkId,
        "noInvoice": noInvoice,
        "createdAt": createdAt,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    this.quantity,
    this.product,
  });

  String? id;
  int? quantity;
  Product? product;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        quantity: json["quantity"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "product": product!.toJson(),
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.price,
  });

  String? id;
  int? price;
  String? name;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        price: json["price"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "name": name,
      };
}
