import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import "package:nanoid/nanoid.dart" as nanoid;
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/product_service.dart';
import 'package:kasanah_mobile/core/worker/StringWorker.dart';

Future<Map> createOrder(
    String userId, List<CartItem> items, String methodPayment) async {
  try {
    List<String> itemIds = [];
    for (CartItem i in items) {
      itemIds.add(i.id!);
    }
    String token = sessionManager.nToken!;
    String address = sessionManager.nAddress!;
    var body = jsonEncode({
      "itemIds": itemIds,
      "methodPayment": methodPayment,
      "deliveryService": "REGULAR",
      "addressText": sessionManager.nAddress
    });
    var res = await http.post(
        Uri.parse(
            "https://database-query.v3.microgen.id/api/v1/b7b663cf-9e64-4fed-9a84-2538f30c9cb8/transaction/function/create-order"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: body);
    var b = jsonDecode(res.body);
    switch (b) {
      case 200:
        return {
          "res": "ok",
        };
      case 429:
        return {
          "res": "rate-limit",
        };
    }
    if (res.statusCode < 300) {
      var b = jsonDecode(res.body);
      items.forEach((item) async {
        await deleteCartItem(token, item.id!);
      });
      return {"res": "ok", "data": b};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<bool> _addDetailToTransaction(String productName, int price, int qty,
    String transactionId, String _token) async {
  var body = jsonEncode({
    "productName": productName,
    "price": price,
    "quantity": qty,
    "transaction": [transactionId],
  });
  Uri url = Uri.parse("$kMgApi/detailTransaction");
  var res = await http.post(url,
      headers: {"Authorization": "Bearer $_token"}, body: body);
  if (res.statusCode < 300) return true;
  return false;
}

// Future<int> getManualTransactionTotalPayment(String transactionId) async {
//   int total = 0;
//   Uri url = Uri.parse("$kMgApi/transaction?\$lookup[*]=*&$transactionId");
//   var res = await http
//       .get(url, headers: {"Authorization": "Bearer ${sessionManager.nToken}"});
//   if (res.statusCode < 300) {
//     var d = jsonDecode(res.body);
//     print(d);
//     List details = d["detailTransaction"];
//     details.forEach((detail) {
//       int price = detail["price"];
//       int quantity = detail["quantity"];
//       total += price * quantity;
//     });
//     return total;
//   }
//   return total;
// }

Future<Map> sendTransferProofImage(
    String transactionId, String filePath, String fileName) async {
  try {
    String token = sessionManager.nToken!;
    Uri url = Uri.parse("$kMgApi/transaction/$transactionId");
    String paymentStatus = "VERIFIKASI";
    Map uploadImage = await uploadFileToMg(
        filePath: filePath, fileName: fileName, token: token);
    if (uploadImage["res"] != "ok") return {"res": "api-error"};
    var d = uploadImage["data"];
    var body = jsonEncode({
      "paymentStatus": paymentStatus,
      "proofTransfer": [
        {"url": d["url"], "fileName": d["fileName"]}
      ],
    });
    var res = await http.patch(
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

Future<Map> getUserHistoryTransaction() async {
  try {
    String token = sessionManager.nToken!;
    String userId = sessionManager.nUserId!;
    Uri url = Uri.parse(
        "$kMgApi/transaction?\$lookup[*][0]=detailTransaction&orderUser=$userId");
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode < 300) {
      var d = jsonDecode(res.body);
      return {"res": "ok", "data": d};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> getHistoryTransactionNotPayed() async {
  try {
    String token = sessionManager.nToken!;
    String userId = sessionManager.nUserId!;
    Uri url = Uri.parse(
        "$kMgApi/transaction?\$lookup[*][0]=detailTransaction&orderUser=$userId&status=PENDING");
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode < 300) {
      var d = jsonDecode(res.body);
      return {"res": "ok", "data": d};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> getHistoryTransactionOnPacked() async {
  try {
    String token = sessionManager.nToken!;
    String userId = sessionManager.nUserId!;
    Uri url = Uri.parse(
        "$kMgApi/transaction?\$lookup[*][0]=detailTransaction&orderUser=$userId&status=PROCESS");
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode < 300) {
      var d = jsonDecode(res.body);
      return {"res": "ok", "data": d};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> getHistoryTransactionOnDelivery() async {
  try {
    String token = sessionManager.nToken!;
    String userId = sessionManager.nUserId!;
    Uri url = Uri.parse(
        "$kMgApi/transaction?\$lookup[*][0]=detailTransaction&orderUser=$userId&status=DELIVERY");
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode < 300) {
      var d = jsonDecode(res.body);
      return {"res": "ok", "data": d};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> getHistoryTransactionDone() async {
  try {
    String token = sessionManager.nToken!;
    String userId = sessionManager.nUserId!;
    Uri url = Uri.parse(
        "$kMgApi/transaction?\$lookup[*][0]=detailTransaction&orderUser=$userId&status=DONE");
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode < 300) {
      var d = jsonDecode(res.body);
      return {"res": "ok", "data": d};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> getHistoryTransactionCancel() async {
  try {
    String token = sessionManager.nToken!;
    String userId = sessionManager.nUserId!;
    Uri url = Uri.parse(
        "$kMgApi/transaction?\$lookup[*][0]=detailTransaction&orderUser=$userId&status=CANCEL");
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode < 300) {
      var d = jsonDecode(res.body);
      return {"res": "ok", "data": d};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> getQrHistory() async {
  try {
    String token = sessionManager.nToken!;
    String userId = sessionManager.nUserId!;
    Uri url = Uri.parse("$kMgApi/SaldoPay?\$lookup[*]=*&user=$userId");
    var res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (res.statusCode < 300) {
      var d = jsonDecode(res.body);
      return {"res": "ok", "data": d};
    }
  } catch (e) {
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
    "path": "transferProof",
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

Future<Map> postSaldo(
  int newSaldo,
  int debit,
  String qrPaymentId,
) async {
  try {
    String _token = sessionManager.nToken!;
    String _id = sessionManager.nUserId!;

    var body = jsonEncode({
      "saldo": newSaldo,
      "user": [_id],
      "debit": debit,
      "transactionPay": [qrPaymentId],
      "type": "QR_PAYMENT"
    });
    Uri url = Uri.parse("$kMgApi/SaldoPay");
    var res = await http.post(url,
        headers: {"Authorization": "Bearer $_token"}, body: body);
    if (res.statusCode < 300) {
      var b = jsonDecode(res.body);
      return {"res": "ok", "data": b};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}

Future<Map> postSaldoStore(
    int newSaldo, int kredit, String qrPaymentId, String storeId) async {
  try {
    String _token = sessionManager.nToken!;

    var body = jsonEncode({
      "saldo": newSaldo,
      "user": [storeId],
      "kredit": kredit,
      "transactionPay": [qrPaymentId],
      "type": "QR_PAYMENT"
    });
    Uri url = Uri.parse("$kMgApi/SaldoPay");
    var res = await http.post(url,
        headers: {"Authorization": "Bearer $_token"}, body: body);
    if (res.statusCode < 300) {
      var b = jsonDecode(res.body);
      return {"res": "ok", "data": b};
    }
  } catch (e) {
    return {
      "res": "service-error",
      "error": {"error": e}
    };
  }
  return {"res": "api-error"};
}
