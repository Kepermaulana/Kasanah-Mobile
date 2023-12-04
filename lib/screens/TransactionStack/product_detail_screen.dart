import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/product_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/StockWorker.dart';
import 'package:kasanah_mobile/screens/TransactionStack/cart_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/ProceedStack/shipping_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen(
      {Key? key, required this.imagesUrl, required this.name, required this.id})
      : super(key: key);
  final List<String> imagesUrl;
  final String name;
  final String id;
  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  bool _isLoading = true;
  bool _isNotifyCart = false;
  int _cartCount = 0;
  int timer = 0;

  bool isInCart = true;
  TextEditingController _counterController = TextEditingController();

  Product _product = Product();
  CartItem _thisCartItem = CartItem();

  Future handleUserCartCount() async {
    Map res = await countUserCartItems(
        sessionManager.nToken!, sessionManager.nUserId!);
    switch (res["res"]) {
      case "ok":
        setState(() {
          _cartCount = res["count"];
          if (_cartCount == 0) {
            _isNotifyCart = false;
            return;
          } else {
            _isNotifyCart = true;
            return;
          }
        });
        break;
    }
  }

  Future showSuccess() async {
    _product = Product();
    _thisCartItem = CartItem();
    await getDetail(widget.id);
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (context) {
        return WDialog_TextAlert(context, "Berhasil Menambahkan",
            'Produk Berhasil Ditambahkan Dalam Keranjang');
      },
    );
  }

  Future showSuccessJustBuy(CartItem item) async {
    _product = Product();
    _thisCartItem = CartItem();
    setState(() {
      Navigator.push(context,
          MyRoute(builder: (context) => ShippingScreen(selectedItems: [item])));
    });
  }

  Future proceed_BuyThisTime() async {
    setState(() {
      _isLoading = true;
    });
    int _counter = int.parse(_counterController.text);
    int _availableQty = _product.stock!;
    if (_counter <= 0) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WDialog_TextAlert(
              context, "Aksi Dibatalkan", 'gagal menambahkan');
        },
      );
      return;
    }
    if (_counter > _availableQty) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WDialog_TextAlert(
              context, "Aksi Dibatalkan", 'stok tidak mencukupi');
        },
      );
      return;
    }
    // __ Beli Langsung
    Map res = await addProductToCart(
        sessionManager.nUserId!, sessionManager.nToken!, widget.id, _counter);
    String r = res["res"];
    print(r);
    switch (r) {
      case "cart-exist":
        Map patchExistCartRes = await patchAddCartItem(sessionManager.nToken!,
            _thisCartItem.id!, _thisCartItem.quantity!, _counter);
        String existCartId = patchExistCartRes["_id"];
        Map justBuyExistRes = await getSingleUserCart(
            token: sessionManager.nToken!, cartId: existCartId);
        print(justBuyExistRes);
        if (justBuyExistRes["res"] == "ok") {
          var d = justBuyExistRes["data"];
          var dP = justBuyExistRes["data"]["cartProduct"][0];
          CartItem item = CartItem(
              id: d["_id"],
              quantity: d["quantity"],
              product: Product(
                  id: dP["_id"],
                  name: dP["productName"],
                  images: [dP["productImages"][0]["url"]],
                  price: dP["priceResult"]));
          showSuccessJustBuy(item);
        }
        return;
      case "ok":
        String id = res["_id"];
        Map justBuyOkRes =
            await getSingleUserCart(token: sessionManager.nToken!, cartId: id);
        if (justBuyOkRes["res"] == "ok") {
          var d = justBuyOkRes["data"];
          var dP = justBuyOkRes["data"]["cartProduct"][0];
          CartItem item = CartItem(
              id: d["_id"],
              quantity: d["quantity"],
              product: Product(
                  id: dP["_id"],
                  name: dP["productName"],
                  images: [dP["productImages"][0]["url"]],
                  price: dP["priceResult"]));
          showSuccessJustBuy(item);
          print(justBuyOkRes);
        }
        return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Main Function
  Future proceed_AddToCard() async {
    setState(() {
      _isLoading = true;
    });
    int _counter = int.parse(_counterController.text);
    int _availableQty = _product.stock!;
    if (_counter <= 0) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WDialog_TextAlert(
              context, "Aksi Dibatalkan", 'Gagal Menambahkan');
        },
      );
      return;
    }
    if (_counter > _availableQty) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WDialog_TextAlert(
              context, "Aksi Dibatalkan", 'Stok Tidak Mencukupi');
        },
      );
      return;
    }
    // __ Tambah ke Cart
    Map res = await addProductToCart(
        sessionManager.nUserId!, sessionManager.nToken!, widget.id, _counter);
    String r = res["res"];
    switch (r) {
      case "cart-exist":
        await patchAddCartItem(sessionManager.nToken!, _thisCartItem.id!,
            _thisCartItem.quantity!, _counter);
        await showSuccess();
        return;
      case "ok":
        await showSuccess();
        return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Main Function
  Future getDetail(String id) async {
    Map res = await getDetailProductById(id);
    String r = res["res"];
    if (r == "ok") {
      var data = res["body"];
      setState(() {
        _product.description = data["productDescription"];
        _product.stock = data["productStock"];
        _product.price = data["priceResult"];
        // _product.sellerName = [data["createdBy"][0]];
        _product.categoryName = [data["productCategories"][0]["category"]];
        _product.sellerName = data["createdBy"]["storeName"].toString();
        _isLoading = false;
      });
    }
  }

  Future _findThisProductOnCart() async {
    Map res = await getUserCartByProductId(
        widget.id, sessionManager.nUserId!, sessionManager.nToken!);

    String r = res["res"];
    if (r == "ok") {
      var d = res["data"][0];
      setState(() {
        _thisCartItem.quantity = d["quantity"];
        _thisCartItem.id = d["_id"];
      });
    }
    if (r == "error") {
      setState(() {
        Navigator.push(
            context, MyRoute(builder: (_) => const WNavigationBar()));
      });
    }
  }

  List<Widget> _showDetailImage({List<String>? imagesUrl}) {
    List<Widget> image = [];
    for (dynamic i in imagesUrl!) {
      image.add(Image.network(i, fit: BoxFit.fill));
    }
    return image;
  }

  @override
  void initState() {
    super.initState();
    _counterController.text = "1";

    (() async {
      await handleUserCartCount();
      await getDetail(widget.id);
      await _findThisProductOnCart();
    })();
  }

  @override
  Widget build(BuildContext context) {
    // (() async => await handleUserCartCount())();
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c.whiteColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
        toolbarHeight: mediaH / 10,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mediaW / defaultPadding * 0.6,
                vertical: mediaH / defaultPadding / 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: mediaW / 52,
                ),
                WActionButton(const Icon(Icons.shopping_cart_outlined),
                    c.greenColor, mediaW / 7, 50, context,
                    qty: _cartCount, isNotify: _isNotifyCart, onPressed: () {
                  Navigator.push(
                      context, MyRoute(builder: (_) => const CartScreen()));
                })
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
                size: mediaW / 15,
              color: c.greenColor,
            ))
          : SafeArea(
              child: SingleChildScrollView(
                  child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: mediaW / 1.1,
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaW / 30,
                    ),
                    Text(
                      _product.categoryName![0],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(),
                        child: CarouselSlider(
                            options: CarouselOptions(
                              height: mediaH / 3.7,
                              autoPlay: true,
                            ),
                            items:
                                _showDetailImage(imagesUrl: widget.imagesUrl)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      formatToRp(_product.price!),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Text(
                      (_product.stock! <= 0)
                          ? 'Tidak Tersedia'
                          : 'Sisa Stock: ${_product.stock ?? 0}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // TAP-MINUS
                        GestureDetector(
                          onTap: () {
                            // counter == 1 ? null : minusItem();
                            int currentValue =
                                int.parse(_counterController.text);
                            currentValue--;
                            if (currentValue == 0) currentValue = 1;
                            setState(() {
                              _counterController.text =
                                  (currentValue > 0 ? currentValue : 0)
                                      .toString(); // decrementing value
                            });
                          },
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"\d+([\.]\d+)?")),
                            ],
                            autofocus: false,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            controller: _counterController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // TAP-PLUS
                        GestureDetector(
                          onTap: () {
                            int currentValue =
                                int.parse(_counterController.text);
                            currentValue++;
                            setState(() {
                              _counterController.text = (currentValue)
                                  .toString(); // incrementing value
                            });
                          },
                          child: const Icon(Icons.add),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Column(
                        children: [
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       'Seller: ${_product.sellerName}',
                          //       style: const TextStyle(
                          //         fontWeight: FontWeight.w600,
                          //         fontSize: 18,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 0, top: 25),
                                child: const Text(
                                  'Deskripsi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: mediaW / 1.2,
                                child: Text(
                                  _product.description ?? "-",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: mediaW,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: WButton_Filled(() async {
                          await proceed_AddToCard();
                        },
                            Text(
                              'Masukkan ke Keranjang',
                              style: TextStyle(color: c.whiteColor),
                            ),
                            context,
                            height: 14,
                            color: c.brownColor),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              )),
            ),
      // bottomNavigationBar: BottomAppBar(
      //   height: mediaH / 2.8,
      //   elevation: 0,
      //   child: Container(
      //     decoration: BoxDecoration(
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.withOpacity(1),
      //             spreadRadius: 5,
      //             blurRadius: 7,
      //             offset: Offset(0, 3), // changes position of shadow
      //           ),
      //         ],
      //         color: c.brownColor,
      //         borderRadius: const BorderRadius.only(
      //             topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      //     child: Column(
      //       children: [
      //         Container(
      //           padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      //           child: Column(
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.symmetric(vertical: 10),
      //                 child: Row(
      //                   children: [
      //                     Text(
      //                       (_product.stock! <= 0)
      //                           ? 'Tidak Tersedia'
      //                           : 'Sisa Stock: ${_product.stock ?? 0}',
      //                       style: TextStyle(
      //                         fontWeight: FontWeight.w600,
      //                         fontSize: 16,
      //                         color: c.whiteColor,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: mediaH / 6,
      //                 width: mediaW,
      //                 child: Column(
      //                   children: [
      //                     Row(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(
      //                           'Deskripsi',
      //                           style: TextStyle(
      //                             color: c.whiteColor,
      //                             fontWeight: FontWeight.w600,
      //                             fontSize: 14,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     SizedBox(
      //                       height: 5,
      //                     ),
      //                     Row(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         SizedBox(
      //                           width: mediaW / 1.2,
      //                           child: Text(
      //                             _product.description ?? "-",
      //                             // _product.description ?? "-",
      //                             textAlign: TextAlign.start,
      //                             maxLines: 6,
      //                             overflow: TextOverflow.ellipsis,
      //                             style: TextStyle(
      //                               color: c.whiteColor,
      //                               fontWeight: FontWeight.w300,
      //                               fontSize: 12,
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 30,
      //               ),
      //             ],
      //           ),
      //         ),
      //         Spacer(),
      //         SizedBox(
      //           width: mediaW,
      //           child: Row(
      //             children: [
      //               const Spacer(),
      //               WButton_Outlined(() async {
      //                 await proceed_justBuyIt();
      //               }, const Text('Beli Langsung'), context,
      //                   width: 2.5, height: 15),
      //               const Spacer(),
      //               WButton_Filled(() async {
      //                 await proceed_AddToCard();
      //               },
      //                   Text(
      //                     ' + Keranjang',
      //                     style: TextStyle(color: c.greenColor),
      //                   ),
      //                   context,
      //                   width: 2.5,
      //                   height: 15),
      //               const Spacer(),
      //             ],
      //           ),
      //         ),
      //         const SizedBox(
      //           height: 30,
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
