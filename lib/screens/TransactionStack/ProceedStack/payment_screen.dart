import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/transaction_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/screens/HomeStack/home_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/ProceedStack/manual_payment_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen(
      {super.key, required this.selectedItems, required this.shippingType});
  List<CartItem>? selectedItems;
  String? shippingType; // shippingType = PICK/DELI
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = true;
  String? paymentType;
  bool _isDisableLanjutBtn = true;
  int? _biayaTransaksi;
  int? _ongkir;
  double? discountPercentage;

  Future proceedCod(int total) async {
    Map initiate =
        await createOrder(sessionManager.nUserId!, widget.selectedItems ?? [], "COD");
    // Map initiate = await postNewTransaction(
    //     sessionManager.nUserId!, widget.selectedItems!);
    String r = initiate["res"];
    switch (r) {
      case "ok":
        var d = initiate["data"];
        setState(() {
          showDialog(
            barrierColor: Colors.black26,
            context: context,
            builder: (context) {
              return WDialog_TextAlert(context, 'Transaksi Berhasil',
                  'Tunggu Konfirmasi Dari Admin');
            },
          );
        });
        Future.delayed(Duration(seconds: 1))
            .then((value) => Navigator.pushAndRemoveUntil(
                  context,
                  MyRoute(builder: (context) => WNavigationBar()),
                  (route) => false,
                ));
        return;
    }
  }

  Future proceedManual(int total) async {
    Map initiate =
        await createOrder(sessionManager.nUserId!, widget.selectedItems ?? [], "MANUAL");
    // Map initiate = await postNewTransaction(
    //     sessionManager.nUserId!, widget.selectedItems!);
    String r = initiate["res"];
    switch (r) {
      case "ok":
        var d = initiate["data"];
        Future.delayed(Duration(seconds: 2)).then((value) => Navigator.push(
              context,
              MyRoute(
                  builder: (context) => ManualPaymentScreen(
                        transactionId: d["resultTransaction"]["_id"],
                        createdAt: d["createdAt"],
                        total: total,
                      )),
            ));
        return;
    }
  }

  Future proceed(int total) async {
    setState(() {
      _isLoading = true;
    });
    // paymentType = MANUAL/VIRTUAL_ACCOUNT
    switch (paymentType) {
      case "COD":
        proceedCod(total);
        break;
      case "TRANSFER_MANUAL":
        proceedManual(total);
        break;
    }
  }

  void listenPengirimanState() {
    if (paymentType != null) {
      setState(() {
        _isDisableLanjutBtn = false;
      });
      return;
    } else {
      setState(() {
        _isDisableLanjutBtn = true;
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    // discountPercentage = 20; // can be null
    // _biayaTransaksi = 1000; // can be null
    switch (widget.shippingType) {
      case "HEMAT":
        _isLoading = false;
        break;
      case "REGULER":
        _ongkir = 20000; // can be null
        _isLoading = false;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    int _subTotal = 0; // (Price x Quantity) x jumlah cart item ()
    int _subTotalA = 0; // _subTotal + Biaya Transaksi (Harga)
    int _subTotalB = 0; // _subTotalA - Diskon + Ongkir
    int _total = 0; // overall total / _total = _subtotalB

    List<CartItem> _items = widget.selectedItems!;
    _items.forEach((item) {
      _subTotal += item.product!.price! * item.quantity!;
    });
    _subTotalA = (_biayaTransaksi ?? 0) + _subTotal;
    int discount = (discountPercentage != null)
        ? (discountPercentage! / 100 * _subTotalA).toInt()
        : 0;
    _subTotalB = (_subTotalA - discount + (_ongkir ?? 0));

    _total = _subTotalB;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: c.whiteColor,
        title: Text(
          'Pembayaran',
          style: TextStyle(
            color: c.blackColor,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                size: MediaQuery.of(context).size.width / 15,
              color: c.greenColor,
            ))
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: defaultPadding),
                      child: ListView.builder(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        itemCount: widget.selectedItems!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          CartItem item = widget.selectedItems![index];
                          int subtotal = item.product!.price! * item.quantity!;
                          return WCheckedProductList(
                              context,
                              item.product!.images![0],
                              item.product!.name!,
                              item.quantity!,
                              subtotal,
                              item.product!.price!);
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const Text('Ringkasan Pembayaran',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        const Text("Total Pembayaran", style: TextStyle()),
                        const Spacer(),
                        Text(
                          formatToRp(_subTotal),
                        )
                      ],
                    ),
                    (_biayaTransaksi != null)
                        ? Row(
                            children: [
                              const Text("Biaya Transaksi", style: TextStyle()),
                              const Spacer(),
                              Text(
                                formatToRp(_biayaTransaksi ?? 0),
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                    Row(
                      children: [
                        const Text('Total', style: TextStyle()),
                        const Spacer(),
                        Text(
                          formatToRp(_subTotalA),
                          style: TextStyle(),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: "Kode Promo",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: c.greenColor)),
                        hintStyle: TextStyle(
                            color: c.greyColor, fontWeight: FontWeight.w300),
                      ),
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                          color: c.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: defaultPadding),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Subtotal',
                                  style: TextStyle(
                                      color: c.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              const Spacer(),
                              Text(formatToRp(_subTotalB),
                                  style: TextStyle(
                                      color: c.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700))
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Harga',
                              ),
                              const Spacer(),
                              Text(
                                formatToRp(_subTotalA),
                              )
                            ],
                          ),
                          (discountPercentage != null)
                              ? Row(
                                  children: [
                                    Text(
                                      'Diskon ${discountPercentage!.toInt()}%',
                                    ),
                                    const Spacer(),
                                    Text(
                                      "-${formatToRp(discount)}",
                                      style: TextStyle(),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),
                          (_ongkir != null)
                              ? Row(
                                  children: [
                                    const Text(
                                      'Total Ongkos Kirim',
                                    ),
                                    Spacer(),
                                    Text(
                                      formatToRp(_ongkir!),
                                      style: TextStyle(),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const Text(
                      'Tipe Pembayaran',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    RadioListTile(
                      title: const Text(
                        "COD",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      value: "COD",
                      groupValue: paymentType,
                      activeColor: c.greenColor,
                      onChanged: (value) {
                        setState(() {
                          paymentType = value.toString();
                        });
                        listenPengirimanState();
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Transfer Manual ',
                        style: TextStyle(
                          color: c.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      value: 'TRANSFER_MANUAL',
                      activeColor: c.greenColor,
                      groupValue: paymentType,
                      onChanged: (value) {
                        setState(() {
                          paymentType = value.toString();
                        });
                        listenPengirimanState();
                      },
                    ),
                    const Divider(
                      thickness: 2,
                    )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: WCartBottomBar(
          context,
          formatToRp(_total),
          'Bayar',
          !_isLoading
              ? () async {
                  await proceed(_total);
                }
              : () {},
          btnIsDisabled: _isDisableLanjutBtn || _isLoading),
    );
  }
}
