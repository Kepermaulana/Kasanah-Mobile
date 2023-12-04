import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/screens/ProfileStack/ProfileChangeStack/user_address_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/ProceedStack/payment_screen.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';

class ShippingScreen extends StatefulWidget {
  ShippingScreen({super.key, required this.selectedItems});
  List<CartItem>? selectedItems;
  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  String? shippingType;
  bool _isDisableLanjutBtn = true;

  void proceed() {
    // shippingType = PICK/DELI == PICKUP/DELIVERY
    switch (shippingType) {
      case "HEMAT":
        Navigator.push(
            context,
            MyRoute(
                builder: (context) => PaymentScreen(
                    selectedItems: widget.selectedItems,
                    shippingType: shippingType)));
        break;
      case "REGULER":
        break;
    }
  }

  void listenPengirimanState() {
    if (shippingType != null && sessionManager.nAddress != null) {
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
  Widget build(BuildContext context) {
    List<CartItem> _items = widget.selectedItems!;
    int _subTotal = 0;
    int _total = 0;
    _items.forEach((item) {
      _subTotal += item.product!.price! * item.quantity!;
    });
    // TODO: fix this when delivery feature arrive
    _total = _subTotal;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: c.whiteColor,
        title: Text(
          'Pengiriman',
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
      body: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.only(
                  top: defaultPadding,
                ),
                child: Row(
                  children: [
                    Text('Subtotals',
                        style: TextStyle(
                            color: c.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text(formatToRp(_subTotal),
                        style: TextStyle(
                            color: c.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              const Text(
                'Pilih Jasa Pengiriman',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              RadioListTile(
                title: const Text(
                  'Hemat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                value: 'HEMAT',
                activeColor: c.greenColor,
                groupValue: shippingType,
                onChanged: (value) {
                  setState(() {
                    shippingType = value.toString();
                  });
                  listenPengirimanState();
                },
              ),
              RadioListTile(
                title: const Text(
                  "Reguler",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                value: "REGULER",
                groupValue: shippingType,
                activeColor: c.greenColor,
                onChanged: null,
              ),
              const Divider(
                thickness: 2,
              ),
              const Text(
                'Alamat Pengiriman',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Divider(
                thickness: 2,
              ),
              (sessionManager.nAddress == null)
                  ? Text(
                      'Anda Belum Mendaftarkan Alamat Anda, Silahkan Daftar di Halaman Akun Anda!',
                      style: TextStyle(color: c.redColor),
                    )
                  : Text('${sessionManager.nAddress}')
            ],
          ),
        ),
      ),
      bottomNavigationBar: WCartBottomBar(
          context, formatToRp(_total), 'Pilih Pembayaran', proceed,
          btnIsDisabled: _isDisableLanjutBtn),
    );
  }
}
