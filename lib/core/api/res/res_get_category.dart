// To parse this JSON data, do
//
//     final resGetCategory = resGetCategoryFromJson(jsonString);

import 'dart:convert';

ResGetCategory resGetCategoryFromJson(String str) =>
    ResGetCategory.fromJson(json.decode(str));

String resGetCategoryToJson(ResGetCategory data) => json.encode(data.toJson());

class ResGetCategory {
  ResGetCategory({
    required this.category,
  });

  List<Category> category;

  factory ResGetCategory.fromJson(Map<String, dynamic> json) => ResGetCategory(
        category: List<Category>.from(
            json["category"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.image,
    this.categoryId,
  });

  String? id;
  String? name;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? image;
  String? categoryId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
        image: json["image"] == null ? null : json["image"],
        categoryId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdBy": createdBy,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "image": image == null ? null : image,
        "id": categoryId,
      };
}
