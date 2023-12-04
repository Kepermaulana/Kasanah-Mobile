import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/product_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/TransactionStack/product_detail_screen.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen(
      {Key? key, required this.imagesUrl, required this.name, required this.id})
      : super(key: key);
  final List<String> imagesUrl;
  final String name;
  final String id;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  bool _isLoading = false;
  List<Product> _listCategory = [];

  Future getCategoryProduct() async {
    setState(() {
      _isLoading = true;
    });
    Map res = await getByDetailCategoryProduct(widget.id);
    if (res["res"] == "ok") {
      List body = res["body"];
      for (var e in body) {
        List<String> imageUrl = [];
        e["productImages"].forEach((image) {
          imageUrl.add(image["url"]);
        });
        _listCategory.add(Product(
            id: e["_id"],
            name: e["productName"],
            price: e["priceResult"],
            images: imageUrl));
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToDetail(List<String> imagesUrl, String name, String id) {
    Navigator.push(
        context,
        MyRoute(
            builder: (context) => DetailProductScreen(
                  imagesUrl: imagesUrl,
                  name: name,
                  id: id,
                )));
  }

  @override
  void initState() {
    super.initState();
    (() async {
      await getCategoryProduct();
    })();
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
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
        title: Text(
          widget.name,
          style: TextStyle(color: c.blackColor),
        ),
      ),
      body: Container(
          child: _isLoading
              ? SizedBox(
                  height: mediaH / 2,
                  child: Center(
                      child: LoadingAnimationWidget.waveDots(
                        size: mediaW / 15,
                    color: c.greenColor,
                  )),
                )
              : (_listCategory.isNotEmpty)
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: (150.0 / 200.0)),
                          itemCount: _listCategory.length,
                          itemBuilder: (BuildContext context, int index) {
                            Product product = _listCategory[index];
                            return WCard_Product(() {
                              navigateToDetail(
                                  product.images!, product.name!, product.id!);
                            }, context, product.name ?? "-", product.price ?? 0,
                                product.images?[0] ?? "");
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: mediaW / 1.5,
                        child: const Text(
                            'Mohon Maaf Produk Dengan Kategori Ini Tidak Ada', textAlign: TextAlign.center,),
                      ),
                    )),
    );
  }
}
