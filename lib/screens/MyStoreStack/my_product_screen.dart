import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/service/sell_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;

import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/add_product_screen.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/edit_product_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/class/product_class.dart';

class MyProductScreen extends StatefulWidget {
  const MyProductScreen({super.key});

  @override
  State<MyProductScreen> createState() => _MyProductState();
}

class _MyProductState extends State<MyProductScreen> {
  bool _isLoading = false;
  String userId = sessionManager.nUserId!;
  List<Product> _listUserProduct = [];
  List<Product> _listUserProductArchived = [];
  String _pressedType = "P";

  Future getUserProduct() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map res = await getUserProductPublished();
      if (res["res"] == "ok") {
        List body = res["body"];
        for (var e in body) {
          List<String> imageUrl = [];
          e["productImages"].forEach((image) {
            imageUrl.add(image["url"]);
          });
          _listUserProduct.add(Product(
              id: e["_id"],
              description: e["productDescription"],
              name: e["productName"],
              price: e["priceResult"],
              originalPrice: e["productPrice"],
              stock: e["productStock"],
              categoryNameData:
                  e["productCategories"][0]["category"].toString(),
              categoryId: e["productCategories"][0]["_id"].toString(),
              images: imageUrl));
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      return {
        "res": "service-error",
        "data": {"error": e}
      };
    }
  }

  Future getUserProductArchived() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map res = await getUserProductArchivedService();
      if (res["res"] == "ok") {
        List body = res["body"];
        for (var e in body) {
          List<String> imageUrl = [];
          e["productImages"].forEach((image) {
            imageUrl.add(image["url"]);
          });
          _listUserProductArchived.add(Product(
              id: e["_id"],
              description: e["productDescription"],
              name: e["productName"],
              price: e["priceResult"],
              originalPrice: e["productPrice"],
              stock: e["productStock"],
              categoryNameData:
                  e["productCategories"][0]["category"].toString(),
              categoryId: e["productCategories"][0]["_id"].toString(),
              images: imageUrl));
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      return {
        "res": "service-error",
        "data": {"error": e}
      };
    }
  }

  Future archiveProduct(String productId) async {
    setState(() {
      _isLoading = true;
    });
    Map archiveTheProduct = await isPublishService(productId, false);
    setState(() {
      _isLoading = false;
    });
    setState(() {
      Navigator.push(context, MyRoute(builder: (_) => const WNavigationBar()));
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WDialog_TextAlert(context, 'Arsip Produk Berhasil',
              'Silahkan Cek Pada Halaman Aktif');
        },
      );
    });
  }

  Future publishProduct(String productId) async {
    setState(() {
      _isLoading = true;
    });
    Map archiveTheProduct = await isPublishService(productId, true);
    setState(() {
      _isLoading = false;
    });
    setState(() {
      Navigator.push(context, MyRoute(builder: (_) => const WNavigationBar()));
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WDialog_TextAlert(context, 'Publish Produk Berhasil',
              'Silahkan Cek Pada Halaman Arsip');
        },
      );
    });
  }

  @override
  void initState() {
    getUserProduct();
    getUserProductArchived();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: c.whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MyRoute(builder: (_) => const WNavigationBar()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
        title: Text(
          'Produk Saya',
          style: TextStyle(color: c.blackColor),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: mediaW,
          height: mediaH,
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: mediaW,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            _pressedType = "P";
                          }),
                          child: Container(
                            child: Chip(
                              padding:
                                  EdgeInsets.symmetric(horizontal: mediaW / 18),
                              elevation: (_pressedType == "P") ? 10 : 2,
                              backgroundColor: (_pressedType == "P")
                                  ? c.greenColor
                                  : c.whiteColor,
                              shadowColor: (_pressedType == "P")
                                  ? c.whiteColor
                                  : c.blackColor,
                              label: Text(
                                'Aktif',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  color: (_pressedType == "P")
                                      ? c.whiteColor
                                      : c.blackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _pressedType = "T";
                          }),
                          child: Chip(
                            padding:
                                EdgeInsets.symmetric(horizontal: mediaW / 18),
                            elevation: (_pressedType == "T") ? 10 : 2,
                            backgroundColor: (_pressedType == "T")
                                ? c.greenColor
                                : c.whiteColor,
                            shadowColor: (_pressedType == "T")
                                ? c.whiteColor
                                : c.blackColor,
                            label: Text(
                              'Habis',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: (_pressedType == "T")
                                    ? c.whiteColor
                                    : c.blackColor,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _pressedType = "A";
                          }),
                          child: Chip(
                            padding:
                                EdgeInsets.symmetric(horizontal: mediaW / 18),
                            elevation: (_pressedType == "A") ? 10 : 2,
                            backgroundColor: (_pressedType == "A")
                                ? c.greenColor
                                : c.whiteColor,
                            shadowColor: (_pressedType == "A")
                                ? c.whiteColor
                                : c.blackColor,
                            label: Text(
                              'Arsip',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins",
                                color: (_pressedType == "A")
                                    ? c.whiteColor
                                    : c.blackColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                (_listUserProduct.isEmpty && _listUserProductArchived.isEmpty)
                    ? Text("Produk TIdak Ditemukan")
                    : _isLoading
                        ? SizedBox(
                            height: mediaH / 2,
                            child: Center(
                                child: LoadingAnimationWidget.waveDots(
                                  size: mediaW / 15,
                              color: c.greenColor,
                            )),
                          )
                        : _pressedType == "P"
                            ? (_listUserProduct.isEmpty)
                                ? const Text('Anda Belum Mengupload Produk')
                                : ListView.builder(
                                    addAutomaticKeepAlives: false,
                                    addRepaintBoundaries: false,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    reverse: true,
                                    itemCount: _listUserProduct.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Product product = _listUserProduct[index];
                                      return WCard_MyProduct(
                                          context,
                                          product.images![0],
                                          product.name ?? "",
                                          product.price.toString(),
                                          product.stock.toString(), () {
                                        Navigator.push(
                                            context,
                                            MyRoute(
                                                builder: (context) =>
                                                    EditProductScreen(
                                                      id: product.id!,
                                                      categoryId:
                                                          product.categoryId ??
                                                              "",
                                                      imageUrl: product
                                                          .images![0]
                                                          .toString(),
                                                      name: product.name ?? "",
                                                      description:
                                                          product.description ??
                                                              "",
                                                      categoryName: product
                                                              .categoryNameData ??
                                                          "",
                                                      price: product.price
                                                          .toString(),
                                                      stock: product.stock
                                                          .toString(),
                                                      originalPrice: product
                                                          .originalPrice
                                                          .toString(),
                                                    )));
                                      }, () {
                                        archiveProduct(product.id ?? "");
                                      });
                                    })
                            : _pressedType == "A"
                                ? (_listUserProductArchived.isEmpty)
                                    ? Text(
                                        "Produk Yang Anda Arsipkan Tidak Ada")
                                    : ListView.builder(
                                        addAutomaticKeepAlives: false,
                                        addRepaintBoundaries: false,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        reverse: true,
                                        itemCount:
                                            _listUserProductArchived.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Product product =
                                              _listUserProductArchived[index];
                                          return WCard_MyProductArchived(
                                              context,
                                              product.images![0],
                                              product.name ?? "",
                                              product.price.toString(),
                                              product.stock.toString(), () {
                                            Navigator.push(
                                                context,
                                                MyRoute(
                                                    builder: (context) =>
                                                        EditProductScreen(
                                                          id: product.id!,
                                                          categoryId: product
                                                                  .categoryId ??
                                                              "",
                                                          imageUrl: product
                                                              .images![0]
                                                              .toString(),
                                                          name: product.name ??
                                                              "",
                                                          description: product
                                                                  .description ??
                                                              "",
                                                          categoryName: product
                                                                  .categoryNameData ??
                                                              "",
                                                          price: product.price
                                                              .toString(),
                                                          stock: product.stock
                                                              .toString(),
                                                          originalPrice: product
                                                              .originalPrice
                                                              .toString(),
                                                        )));
                                          }, () {
                                            publishProduct(product.id ?? "");
                                          });
                                        })
                                : Container(),
                SizedBox(
                  height: mediaH / 2.20,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaW / 28),
        child: WButton_Filled(() {
          Navigator.push(
              context, MyRoute(builder: (_) => const AddProductScreen()));
        },
            const Text("Tambah Produk Baru",
                style: TextStyle(color: Colors.white)),
            context,
            height: 14,
            color: c.brownColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
