// To parse this JSON data, do
//
//     final resGetOrder = resGetOrderFromJson(jsonString);

import 'dart:convert';

List<ResGetOrder> resGetOrderFromJson(String str) => List<ResGetOrder>.from(
    json.decode(str).map((x) => ResGetOrder.fromJson(x)));

String resGetOrderToJson(List<ResGetOrder> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResGetOrder {
  ResGetOrder({
    this.transactionId,
    this.paymentStatus,
    this.orderStatus,
    this.paymentUrl,
    this.items,
    this.totalQuantity,
    this.totalPrice,
    this.method,
    this.evidenceImage,
    this.linkId,
    this.id,
  });

  String? transactionId;
  String? paymentStatus;
  String? orderStatus;
  String? paymentUrl;
  List<Item>? items;
  int? totalQuantity;
  int? totalPrice;
  String? method;
  String? evidenceImage;
  String? linkId;
  String? id;

  factory ResGetOrder.fromJson(Map<String, dynamic> json) => ResGetOrder(
        transactionId: json["transactionId"],
        paymentStatus: json["paymentStatus"],
        orderStatus: json["orderStatus"],
        paymentUrl: json["paymentUrl"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        totalQuantity: json["totalQuantity"],
        totalPrice: json["totalPrice"],
        method: json["method"],
        evidenceImage: json["evidenceImage"],
        linkId: json["linkId"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "paymentStatus": paymentStatus,
        "orderStatus": orderStatus,
        "paymentUrl": paymentUrl,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
        "totalQuantity": totalQuantity,
        "totalPrice": totalPrice,
        "method": method,
        "evidenceImage": evidenceImage,
        "linkId": linkId,
        "id": id,
      };
}

class Item {
  Item({
    this.quantity,
    this.subtotal,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  int? quantity;
  int? subtotal;
  String? id;
  String? createdAt;
  String? updatedAt;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        quantity: json["quantity"],
        subtotal: json["subtotal"],
        id: json["id"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "subtotal": subtotal,
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
