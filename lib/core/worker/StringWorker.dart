import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:nanoid/nanoid.dart" as nanoid;

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class StringWorker {
  String genInvoice({String alp = "1234567890", int size = 7}) {
    initializeDateFormatting();
    String uniqueId = nanoid.customAlphabet(alp, size);
    String now = DateTime.now().toString().split(" ")[0];
    List d = now.split(" ")[0].split("-");
    String noInvoice = "INV/${d[0]}${d[1]}${d[2]}/$uniqueId";
    return noInvoice;
  }

  String genIdParcel({String alp = "1234567890", int size = 5}) {
    initializeDateFormatting();
    String uniqueId = nanoid.customAlphabet(alp, size);
    String idParcel = "PRC/$uniqueId";
    return idParcel;
  }

  String genSku({String alp = "ABCDEFGHIJKLMNOPQRSTUVWXYZ", int size = 5}) {
    initializeDateFormatting();
    String uniqueId = nanoid.customAlphabet(alp, size);
    String noInvoice = uniqueId.toString();
    return noInvoice;
  }

  String genCreatedAt(bool isTakeDate) {
    initializeDateFormatting();
    String takeDate = DateFormat("d MMMM yyyy", "id_ID").format(DateTime.now());
    String takeHour = DateFormat("H:m", "id_ID").format(DateTime.now());
    if (!isTakeDate) return takeHour;
    return takeDate;
  }

  String genHistoryStatus(String paymentStatus, String orderPickStatus) {
    switch (paymentStatus) {
      case "NEED_PAYMENT":
        return "Menunggu Pembayaran";
      case "IN_REVIEW":
        return "Dalam Verifikasi";
      case "CANCELLED":
        return "Pembayaran Dibatalkan";
      case "VERIFIED":
        switch (orderPickStatus) {
          case "IDLE":
            return "Pembayaran Diterima";
          case "PROCESS":
            return "Pesanan Diproses";
          case "TAKING":
            return "Pesanan Bisa Diambil";
          case "DONE":
            return "Pesanan Selesai";
        }
    }
    return "Perbaikan";
  }

  String genHistoryPaymentStatus(String paymentStatus) {
    switch (paymentStatus) {
      case "NEED_PAYMENT":
        return "Menunggu Pembayaran";
      case "IN_REVIEW":
        return "Dalam Verifikasi";
      case "CANCELLED":
        return "Pembayaran Dibatalkan";
      case "VERIFIED":
        return "LUNAS";
    }
    return "Perbaikan";
  }
}
