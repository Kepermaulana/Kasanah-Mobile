import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasanah_mobile/core/api/api.dart';

Future<Map> getPublishedProduct(int limit, int skip) async {
  try {
    // var res =
    //     await http.get(Uri.parse("$kMgApi/product?productIsPublish=true&\$limit=$_limit&\$skip=$_skip"));
    var res = await http.get(Uri.parse(
        "$kMgApi/product?productIsPublish=true&\$limit=$limit&\$skip=$skip"));
    var b = jsonDecode(res.body);
    if (b.length > 0 && res.statusCode < 300) {
      return {"res": "ok", "body": b};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "product-empty"};
}

Future<Map> getByCategoryProduct(String category) async {
  try {
    String categoryId = await _getByTypeCategoryProductId(category);
    var res = await http.get(Uri.parse(
        "$kMgApi/product?\$lookup=*&productIsPublish=true&productCategories=$categoryId"));
    var b = jsonDecode(res.body);
    if (b.length > 0) {
      return {"res": "ok", "body": b};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "product-empty"};
}

Future<Map> getByDetailCategoryProduct(String categoryId) async {
  try {
    var res = await http.get(Uri.parse(
        "$kMgApi/product?\$lookup=*&productIsPublish=true&productCategories=$categoryId"));
    var b = jsonDecode(res.body);
    if (b.length > 0) {
      return {"res": "ok", "body": b};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "product-empty"};
}

Future<Map> getMainCategory({int limit = 20}) async {
  try {
    var res = await http.get(Uri.parse(
        "$kMgApi/categoryProduct?\$select[0]=_id&\$select[1]=category&\$select[2]=images&\$limit=${limit.toString()}"));
    var b = jsonDecode(res.body);
    if (b.length > 0) {
      return {"res": "ok", "body": b};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "category-empty"};
}

Future<Map> getBannerImages() async {
  try {
    var res =
        await http.get(Uri.parse("$kMgApi/banner?\$lookup=[*]*&isPublic=true"));
    var b = jsonDecode(res.body);
    if (b.length > 0) {
      return {"res": "ok", "body": b};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "image-empty"};
}

Future<Map> getDetailProductById(String productId) async {
  try {
    Uri url = Uri.parse(
        "$kMgApi/product/$productId?\$lookup[*][0]=productCategories");
    var res = await http.get(
      url,
    );
    var b = jsonDecode(res.body);
    return {"res": "ok", "body": b};
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
}

Future<String> _getByTypeCategoryProductId(String category) async {
// PUPUK, ALAT_TANI, SEWA_ALAT
  String _query = "Fashion";
  switch (category) {
    case "Fashion":
      _query = "Fashion";
      break;
    case "Elektronik":
      _query = "Elektronik";
      break;
    // case "SEWA_ALAT":
    //   _query = "SEWA%20ALAT";
    //   break;
  }
  var res = await http.get(Uri.parse(
      "$kMgApi/categoryProduct?\$lookup=*&category=$_query&\$limit=10"));
  var b = jsonDecode(res.body);
  String _id = b[0]["_id"] ?? "63ce1717c900fbecf6b76ef4";
  return _id;
}

Future<Map> getSingleUserCart(
    {required String token, required String cartId}) async {
  try {
    Uri url = Uri.parse(
      "$kMgApi/cart/$cartId?\$lookup=*",
    );
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    var b = jsonDecode(res.body);
    // {_id: 63e0c9888e0ce79053fd189a, cartProduct: [{_id: 63d3ac91e7f13b31a67f3f58, productDescription: Ini pupuk paling bahagia, productImages: [{fileName: 2576641_8b915e09-9f50-4a50-99d6-1c9997231130_2048_2048.jpg, url: https://images.tokopedia.net/img/cache/900/product-1/2020/2/7/2576641/2576641_8b915e09-9f50-4a50-99d6-1c9997231130_2048_2048.jpg}, {fileName: 2576641_2eb986d2-6f21-4cb5-81d6-5279d9197adb_2048_2048.jpg, url: https://images.tokopedia.net/img/cache/900/product-1/2020/2/7/257664
    if (b.isNotEmpty) return {"res": "ok", "data": b};
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "cart-empty"};
}

Future<Map> getUserCart(String userId, String token) async {
  try {
    Uri url = Uri.parse(
      "$kMgApi/cart?\$lookup[*][0]=cartProduct&cartUser=$userId",
    );
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    var b = jsonDecode(res.body);
    if (b.isNotEmpty) {
      return {"res": "ok", "data": b};
    } else {
      return {
        "res": "empty",
      };
    }
    ;
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
}

Future<Map> getUserCartByProductId(
    String productId, String userId, String token) async {
  // https://database-query.v3.microgen.id/api/v1/04982158-085f-4353-97da-a696c7124bb5/cart?$lookup[0]=cartProduct&cartUser=63ce1b01c900fbecf6b76ef9&cartProduct=63d3ab97e7f13b31a67f3f56

  try {
    Uri url = Uri.parse(
        "$kMgApi/cart?\$lookup[0]=cartProduct&cartUser=$userId&cartProduct=$productId");
    var res = await http.get(url, headers: {"Authorization": "Bearer $token"});
    var b = jsonDecode(res.body);
    bool isExist = (b.length > 0) ? true : false;
    if (isExist == true) {
      return {"res": "ok", "data": b};
    }
    // switch (isExist) {
    //   case true:
    //     return {"res": "ok", "data": b};
    //   case false:
    //     return {"res": "not-found"};
    // }
    // if (b.isNotEmpty) return {"res": "ok", "data": b};
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "not-found"};
}

Future<Map> addProductToCart(
    String userId, String token, String productId, int qty) async {
  try {
    bool isCartExist = await _isCartExist(token, productId, userId);
    if (isCartExist) return {"res": "cart-exist"};
    Uri url = Uri.parse("$kMgApi/cart");
    var res = await http.post(url,
        headers: {"Authorization": "Bearer $token"},
        body: jsonEncode({
          "cartProduct": [productId],
          "cartUser": [userId],
          "quantity": qty
        }));
    String _id = jsonDecode(res.body)["_id"];
    if (res.statusCode == 201 || res.statusCode < 300)
      return {"res": "ok", "_id": _id};
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<bool> _isCartExist(String token, String productId, String userId) async {
  Uri url = Uri.parse(
      "$kMgApi/cart?\$select[0]=_id&cartProduct=$productId&cartUser=$userId");
  var res = await http.get(
    url,
    headers: {"Authorization": "Bearer $token"},
  );
  var b = jsonDecode(res.body);
  if (b.length <= 0) return false;
  return true;
}

Future<bool> _checkVerifiedMember(
    String token, String productId, String userId) async {
  Uri url = Uri.parse(
      "$kMgApi/cart?\$select[0]=_id&cartProduct=$productId&cartUser=$userId");
  var res = await http.get(
    url,
    headers: {"Authorization": "Bearer $token"},
  );
  var b = jsonDecode(res.body);
  if (b.length <= 0) return false;
  return true;
}

Future<Map> patchAddCartItem(
    String token, String itemId, int currentQty, int addQty) async {
  try {
    Uri url = Uri.parse("$kMgApi/cart/$itemId");
    var body = jsonEncode({"quantity": currentQty + addQty});
    var res = await http.patch(url,
        headers: {"Authorization": "Bearer $token"}, body: body);
    String _id = jsonDecode(res.body)["_id"];
    if (res.statusCode < 300) return {"res": "ok", "_id": _id};
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> quickPatchItemQtyCounter(
    String token, String itemId, int currentQty, int value) async {
  try {
    Uri url = Uri.parse("$kMgApi/cart/$itemId");
    var body = jsonEncode({"quantity": currentQty + value});
    var res = await http.patch(url,
        headers: {"Authorization": "Bearer $token"}, body: body);
    if (res.statusCode < 300) return {"res": "ok"};
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> countUserCartItems(String token, String userId) async {
  // /cart/count?cartUser=63d0f83fe7f13b31a67f3ed6
  try {
    Uri url = Uri.parse("$kMgApi/cart/count?cartUser=$userId");
    var res = await http.get(url, headers: {"Authorization": "Bearer $token"});
    var b = jsonDecode(res.body);
    if (res.statusCode < 300) return {"res": "ok", "count": b["count"]};
  } catch (e) {
    return {
      "res": "service-error",
      "data": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<bool> deleteCartItem(
  String token,
  String itemId,
) async {
  Uri url = Uri.parse("$kMgApi/cart/$itemId");
  var res = await http.delete(url, headers: {"Authorization": "Bearer $token"});
  if (res.statusCode < 300) return true;
  return false;
}
