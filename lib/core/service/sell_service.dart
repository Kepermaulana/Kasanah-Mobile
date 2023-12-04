import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/worker/StringWorker.dart';

Future _getMargin(String userId) async {
  try {
    var res = await http.get(Uri.parse("$kMgApi/mainConfig?\$select[0]=value"));
    int s = res.statusCode;
    if (s < 300) return true;
  } catch (e) {
    return false;
  }
  return false;
}

Future<Map> uploadProduct(Product newProduct, String filePath, String fileName,
    String? idCategory) async {
  try {
    var rMargin =
        await http.get(Uri.parse("$kMgApi/mainConfig?\$select[0]=value&category=$idCategory"));
    var bMargin = rMargin.body;
    var margin = jsonDecode(bMargin);
    int productFee = int.parse(margin[0]['value']);
    String productName = newProduct.name.toString();
    String productDescription = newProduct.description.toString();
    int productPrice = (newProduct.price ?? 0);
    int productStock = (newProduct.stock ?? 0);
    int feeCount = productPrice * productFee;
    double feePrice = feeCount / 100;
    var priceResult = productPrice + feePrice;
    String productSku = StringWorker().genSku();
    String? productCategories = idCategory;
    String token = sessionManager.nToken!;
    String userId = sessionManager.nUserId!;
    String sellerName = sessionManager.nStoreName!;
    Uri url = Uri.parse('$kMgApi/product');
    Map uploadImage = await uploadFileToMg(
        filePath: filePath, fileName: fileName, token: token);
    if (uploadImage["res"] != "ok") return {"res": "api-error"};
    var d = uploadImage["data"];
    var body = jsonEncode({
      "productName": productName,
      "productDescription": productDescription,
      "productPrice": productPrice,
      "fee": feePrice,
      "priceResult": priceResult,
      "productStock": productStock,
      "productIsPublish": true,
      "productSku": productSku,
      "productCategories": [productCategories],
      "productImages": [
        {"url": d["url"], "fileName": d["fileName"]}
      ],
      "userProduct": [userId],
    });
    var res = await http.post(
      url,
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode < 300) return {"res": "ok"};
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> editProductService(Product newProduct, String filePath,
    String fileName, String? idCategory, String productId) async {
  try {
    var rMargin =
        await http.get(Uri.parse("$kMgApi/mainConfig?\$select[0]=value"));
    var bMargin = rMargin.body;
    var margin = jsonDecode(bMargin);
    int productFee = int.parse(margin[0]['value']);
    String productName = newProduct.name.toString();
    String productDescription = newProduct.description.toString();
    int productPrice = (newProduct.price ?? 0);
    int productStock = (newProduct.stock ?? 0);
    int feeCount = productPrice * productFee;
    double feePrice = feeCount / 100;
    var priceResult = productPrice + feePrice;
    String? productCategories = idCategory;
    String token = sessionManager.nToken!;
    Uri url = Uri.parse('$kMgApi/product/$productId');
    Map uploadFile = await uploadFileToMg(
        filePath: filePath, fileName: fileName, token: token);
    if (uploadFile["res"] != "ok") return {"res": "api-error"};
    var d = uploadFile["data"];
    Map dataBody = {
      "productName": productName,
      "productDescription": productDescription,
      "productPrice": productPrice,
      "fee": feePrice,
      "priceResult": priceResult,
      "productStock": productStock,
      "productCategories": [productCategories],
      "productImages": [
        {"url": d["url"], "fileName": d["fileName"]}
      ],
    };
    var body = jsonEncode(dataBody);
    var res = await http.patch(
      url,
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode < 300) return {"res": "ok"};
  } catch (e) {
    print(e);
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> editProductServiceWithoutImage(
    Product newProduct, String? idCategory, String productId) async {
  try {
    var rMargin =
        await http.get(Uri.parse("$kMgApi/mainConfig?\$select[0]=value"));
    var bMargin = rMargin.body;
    var margin = jsonDecode(bMargin);
    int productFee = int.parse(margin[0]['value']);
    String productName = newProduct.name.toString();
    String productDescription = newProduct.description.toString();
    int productPrice = (newProduct.price ?? 0);
    int productStock = (newProduct.stock ?? 0);
    int feeCount = productPrice * productFee;
    double feePrice = feeCount / 100;
    var priceResult = productPrice + feePrice;
    String? productCategories = idCategory;
    String token = sessionManager.nToken!;
    Uri url = Uri.parse('$kMgApi/product/$productId');
    Map dataBody = {
      "productName": productName,
      "productDescription": productDescription,
      "productPrice": productPrice,
      "fee": feePrice,
      "priceResult": priceResult,
      "productStock": productStock,
      "productCategories": [productCategories],
    };
    var body = jsonEncode(dataBody);
    var res = await http.patch(
      url,
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode < 300) return {"res": "ok"};
  } catch (e) {
    print(e);
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> uploadFileToMg(
    {required String filePath,
    required String fileName,
    required String token}) async {
  Dio dio = Dio();
  FormData data = FormData.fromMap({
    "path": "productImage",
  });
  data.files.add(MapEntry(
      "file", await MultipartFile.fromFile(filePath, filename: fileName)));
  Response res = await dio.post("$kMgApi/storage/upload",
      data: data,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }));
  if (res.statusCode! < 300) {
    var d = res.data;
    return {
      "res": "ok",
      "data": {"fileName": d["fileName"], "url": d["url"]},
    };
  }
  return {"res": "err"};
}

Future<Map> patchFileToMg(
    {required String filePath,
    required String fileName,
    required String token}) async {
  Dio dio = Dio();
  FormData data = FormData.fromMap({
    "path": "productImage",
  });
  data.files.add(MapEntry(
      "file", await MultipartFile.fromFile(filePath, filename: fileName)));
  Response res = await dio.patch("$kMgApi/storage/upload",
      data: data,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }));
  if (res.statusCode! < 300) {
    var d = res.data;
    return {
      "res": "ok",
      "data": {"fileName": d["fileName"], "url": d["url"]},
    };
  }
  return {"res": "err"};
}

Future<Map> getUserProductPublished() async {
  try {
    String userId = sessionManager.nUserId!;
    var res = await http.get(Uri.parse(
        "$kMgApi/product?\$lookup=*&productIsPublish=true&userProduct=$userId"));
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

Future<Map> getUserProductArchivedService() async {
  try {
    String userId = sessionManager.nUserId!;
    var res = await http.get(Uri.parse(
        "$kMgApi/product?\$lookup=*&productIsPublish=false&userProduct=$userId"));
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

Future<Map> isPublishService(String productId, bool isPublish) async {
  try {
    String token = sessionManager.nToken!;
    Uri url = Uri.parse('$kMgApi/product/$productId');
    Map dataBody = {"productIsPublish": isPublish};
    var body = jsonEncode(dataBody);
    var res = await http.patch(
      url,
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode < 300) return {"res": "ok"};
  } catch (e) {
    print(e);
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}
