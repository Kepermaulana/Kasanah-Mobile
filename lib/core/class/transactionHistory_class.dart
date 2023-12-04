class TransactionHistory {
  TransactionHistory({
    this.id,
    this.idTransaction,
    this.orderUser,
    this.deliveryService,
    this.methodPayment,
    this.createdAt,
    this.status,
    this.title,
    this.totalPayment,
    this.totalQuantity,
  });
  String? id;
  String? idTransaction;
  String? orderUser;
  String? deliveryService;
  String? methodPayment;
  String? createdAt;
  String? status;
  String? title;
  int? totalPayment;
  int? totalQuantity;
}

class QRHistory {
  QRHistory(
      {this.id,
      this.nominal,
      this.seller,
      this.payer,
      this.createdAt,
      this.type,
      this.debit,
      this.kredit});

  String? id;
  int? nominal;
  String? seller;
  String? payer;
  String? createdAt;
  String? type;
  int? debit;
  int? kredit;
}
