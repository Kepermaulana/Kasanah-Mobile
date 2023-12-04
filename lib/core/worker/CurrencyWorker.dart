import 'package:intl/intl.dart';

String formatToRp(int number) {
  final currency = NumberFormat("#,##0", "id_ID");
  String _rp = "Rp${currency.format(number)}";
  return _rp;
}
