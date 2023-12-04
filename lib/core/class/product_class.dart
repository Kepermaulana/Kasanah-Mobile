import 'package:kasanah_mobile/core/class/user_class.dart';

class Product {
  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.originalPrice,
    this.sku,
    this.weight,
    this.images,
    this.stock,
    this.isPublish,
    this.categoryName,
    this.categoryNameData,
    this.categoryId,
    this.vendor,
    this.userProduct,
    this.sellerName,
  });
  String? id;
  String? name;
  String? description;
  int? price;
  int? originalPrice;
  String? sku;
  double? weight;
  List<String>? images;
  int? stock;
  bool? isPublish;
  String? categoryNameData;
  String? categoryId;
  List<String>? categoryName;
  String? vendor;
  String? userProduct;
  String? sellerName;
}

class CategoryProduct {
  CategoryProduct({
    this.id,
    this.category,
    this.images,
    this.products,
  });
  String? id;
  String? category;
  List<String>? images;
  List<Product>? products;
}

class CartItem {
  CartItem({this.id, this.product, this.userId, this.quantity, this.isChecked});
  String? id;
  Product? product;
  String? userId;
  int? quantity;
  bool? isChecked;
}

class Wallet {
  Wallet({
    this.id,
    this.saldo,
    this.debit,
    this.kredit,
    this.type,
    this.description,
    this.createdAt,
    this.createdBy,
  });
  String? id;
  int? saldo;
  int? debit;
  int? kredit;
  String? type;
  String? description;
  String? createdAt;
  List<PUser>? createdBy;
}

class BannerType {
  BannerType({
    this.type,
    this.action,
    this.actionType,
    this.actionId
  });
  String? type;
  Map? action;
  String? actionType;
  String? actionId;
}
