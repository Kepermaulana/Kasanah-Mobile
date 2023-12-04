// To parse this JSON data, do
//
//     final dataItem = dataItemFromJson(jsonString);

import 'dart:convert';

List<DataItem> dataItemFromJson(String str) =>
    List<DataItem>.from(json.decode(str).map((x) => DataItem.fromJson(x)));

String dataItemToJson(List<DataItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataItem {
  DataItem({
    this.id,
    this.quantity,
    this.productId,
    this.createdBy,
    this.subtotal,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.dataItemId,
  });

  String? id;
  int? quantity;
  String? productId;
  String? createdBy;
  int? subtotal;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? dataItemId;

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
        id: json["_id"],
        quantity: json["quantity"],
        productId: json["productId"],
        createdBy: json["createdBy"],
        subtotal: json["subtotal"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
        dataItemId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "quantity": quantity,
        "productId": productId,
        "createdBy": createdBy,
        "subtotal": subtotal,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "id": dataItemId,
      };
}
