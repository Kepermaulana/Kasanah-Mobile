import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/product_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/screens/TransactionStack/ProceedStack/payment_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/ProceedStack/shipping_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:kasanah_mobile/widgets/WGlobal.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isCheckAll = false;
  bool _isLoading = true;
  bool _isDisableLanjutBtn = true;

  List<CartItem> _cartItems = [];
  bool _isCartEmpty = true;
  int _cartSubTotal = 0;

  Future disposalSystem() async {
    setState(() {
      _cartItems = [];
      _cartSubTotal = 0;
      _isLoading = true;
      _isCheckAll = false;
      _isDisableLanjutBtn = true;
    });
    await getThisUserCart();
  }

  Future getThisUserCart() async {
    Map res =
        await getUserCart(sessionManager.nUserId!, sessionManager.nToken!);
    // res["data"][index] --> to get all them items
    // res["data"][index]["quantity"] --> to get quantity
    // res["data"][index]["cartProduct"][0] --> to get product information
    String r = res["res"];
    switch (r) {
      case "ok":
        List itemsFromData = res["data"];
        for (var e in itemsFromData) {
          var eP = e["cartProduct"][0];
          _cartItems.add(CartItem(
              id: e["_id"],
              quantity: e["quantity"],
              isChecked: false,
              product: Product(
                  id: eP["_id"],
                  name: eP["productName"],
                  price: eP["priceResult"],
                  isPublish: eP["productIsPublish"],
                  images: [eP["productImages"][0]["url"]])));
        }
        setState(() {
          _isLoading = false;
          _isCartEmpty = (_cartItems.isNotEmpty) ? false : true;
        });
        break;
      case "empty":
        setState(() {
          _isLoading = false;
          _isCartEmpty = (_cartItems.isNotEmpty) ? false : true;
        });
        break;
    }
  }

  Future quickPatchItemQuantity(String itemId, int currentQty,
      {bool isAdd = true}) async {
    if (isAdd == false && currentQty - 1 == 0) {
      return await showDialog(
        context: context,
        builder: (context) {
          return WDialong_ConfirmAlert(
              context, "Apakah anda yakin ingin menghapus item ini?",
              confirm: "Hapus",
              onConfirm: (() async => await removeCartItem(itemId)));
        },
      );
    }
    Map res = await quickPatchItemQtyCounter(
        sessionManager.nToken!, itemId, currentQty, (isAdd) ? 1 : -1);
    String r = res["res"];
    switch (r) {
      case "ok":
        await disposalSystem();
        break;
      default:
    }
  }

  Future removeOnChecked() async {
    _cartItems.forEach((e) async {
      if (e.isChecked == true) {
        bool isRemoved = await deleteCartItem(sessionManager.nToken!, e.id!);
      }
      await disposalSystem();
    });
  }

  Future removeCartItem(String itemId) async {
    bool isRemoved = await deleteCartItem(sessionManager.nToken!, itemId);
    if (isRemoved) {
      await disposalSystem();
    }
  }

  void onCheckAll() {
    _cartItems.forEach((item) {
      // item.quantity! * item.product!.price!;
      if (item.product!.isPublish! == true) {
        setState(() {
          (_isCheckAll && item.isChecked != _isCheckAll)
              ? _cartSubTotal += item.quantity! * item.product!.price!
              : null;

          item.isChecked = _isCheckAll;
          // listenEachItemChecked();
        });
      }
    });
  }

  void listenEachItemChecked() {
    var containTrue = _cartItems.where((e) => e.isChecked == true);
    if (containTrue.isEmpty) {
      setState(() {
        _cartSubTotal = 0;
        _isDisableLanjutBtn = true;
      });
      return;
    }
    setState(() {
      _isDisableLanjutBtn = false;
    });
  }

  void proceed() {
    Iterable<CartItem> selectedItemsIterable =
        _cartItems.where((item) => item.isChecked == true);
    List<CartItem> selectedItems =
        selectedItemsIterable.toList(growable: false);
    setState(() {
      Navigator.push(
          context,
          MyRoute(
            builder: (_) => ShippingScreen(selectedItems: selectedItems),
          ));
    });
  }

  @override
  void initState() {
    super.initState();
    getThisUserCart();
  }

  @override
  Widget build(BuildContext context) {
    listenEachItemChecked();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: c.whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
        title: Text(
          'Keranjang',
          style: TextStyle(color: c.blackColor),
        ),
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
                child: (_isCartEmpty)
                    ? const Center(
                        child: Text("Keranjang kamu kosong ayo belanja!"),
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                checkColor: Colors.white,
                                activeColor: c.brownColor,
                                value: _isCheckAll,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isCheckAll = value!;
                                  });
                                  onCheckAll();
                                },
                              ),
                              Text('Pilih Semua',
                                  style: TextStyle(
                                    color: c.blackColor,
                                    fontWeight: FontWeight.w400,
                                  )),
                              const Spacer(),
                              _isCheckAll
                                  ? TextButton(
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WDialong_ConfirmAlert(context,
                                              "Apakah anda yakin ingin menghapus?",
                                              confirm: "Hapus",
                                              onConfirm: (() async =>
                                                  await removeOnChecked()));
                                        },
                                      ),
                                      child: Text('Hapus',
                                          style: TextStyle(
                                            color: c.greenColor,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          ListView.builder(
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            reverse: true,
                            itemCount: _cartItems.length,
                            itemBuilder: (BuildContext c, int i) {
                              CartItem item = _cartItems[i];
                              return WCard_Cart(
                                  c,
                                  item.product?.isPublish ?? false,
                                  item.product?.name ?? "",
                                  item.quantity ?? 0,
                                  item.product?.price ?? 0,
                                  item.product?.images![0] ?? "",
                                  isChecked: item.isChecked,
                                  onChanged: () {
                                    setState(() {
                                      (item.isChecked!)
                                          ? item.isChecked = false
                                          : item.isChecked = true;
                                    });
                                    switch (item.isChecked) {
                                      case true:
                                        setState(() {
                                          _cartSubTotal += item.quantity! *
                                              item.product!.price!;
                                        });
                                        break;
                                      case false:
                                        setState(() {
                                          _cartSubTotal -= item.quantity! *
                                              item.product!.price!;
                                        });
                                        break;
                                    }
                                    // listenEachItemChecked();
                                  },
                                  onAdd: () async =>
                                      await quickPatchItemQuantity(
                                          item.id!, item.quantity!),
                                  onMinus: () async =>
                                      await quickPatchItemQuantity(
                                          item.id!, item.quantity!,
                                          isAdd: false),
                                  onRemove: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WDialong_ConfirmAlert(context,
                                              "Apakah anda yakin ingin menghapus item ini?",
                                              confirm: "Hapus",
                                              onConfirm: (() async =>
                                                  await removeCartItem(
                                                      item.id!)));
                                        },
                                      ));
                            },
                          ),
                        ],
                      ),
              ),
            ),
      bottomNavigationBar: WCartBottomBar(
          context, formatToRp(_cartSubTotal), 'Lanjut', proceed,
          btnIsDisabled: _isDisableLanjutBtn),
    );
  }
}
