import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/api/network.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/product_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/core/worker/CurrencyWorker.dart';
import 'package:kasanah_mobile/core/worker/MessageWorker.dart';
import 'package:kasanah_mobile/screens/HomeStack/category_detail_screen.dart';
import 'package:kasanah_mobile/screens/HomeStack/event_parcel_screen.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/store_screen.dart';
import 'package:kasanah_mobile/screens/ProfileStack/notification_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/cart_screen.dart';
import 'package:kasanah_mobile/screens/TransactionStack/product_detail_screen.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WCard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _cariController = TextEditingController();
  bool _isLoading = true;
  bool _isNotifyCart = false;
  bool _isNotifyNotif = false;
  int _cartCount = 0;
  List<Product> _listExclusiveProduct = [];
  List<Product> _listAllProduct = [];
  List<Product> _dataFilter = [];
  List<CategoryProduct> _listCategory = [];
  String? idUser, token, phoneNumber, longName, isVerified;
  TextEditingController _cari = TextEditingController();
  bool isSearch = true;
  List<Wallet> userWallet = [];
  List<String> _listPage = [];
  int limit = 6;
  int skip = 0;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    limit = 6;
    skip = 0;
    _listAllProduct.clear();
    setState(() {});
    await getAllProduct();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    limit = 6;
    skip = _listAllProduct.length;

    setState(() {});
    getAllProduct();
    _refreshController.loadComplete();
  }

  String verified = sessionManager.nIsVerified ?? "";

  verifiedS(isVerified) {
    if (isVerified == "true") {
      return "Verified";
    } else if (isVerified == "false") {
      return "Not Verified";
    } else {
      return isVerified;
    }
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

  void navigateToCategory(List<String> imagesUrl, String name, String id) {
    Navigator.push(
        context,
        MyRoute(
            builder: (context) => CategoryDetailScreen(
                  imagesUrl: imagesUrl,
                  name: name,
                  id: id,
                )));
  }

  Future getMainCategories() async {
    Map res = await getMainCategory();
    if (res["res"] == "ok") {
      List body = res["body"];
      for (var e in body) {
        List<String> imageUrl = [];
        var x = e["images"].forEach((image) {
          imageUrl.add(image["url"]);
        });
        _listCategory.add(CategoryProduct(
            id: e["_id"], category: e["category"], images: imageUrl));
      }
    }
  }

  Future getCategoryProduct() async {
    Map res = await getByCategoryProduct("Fashion");
    if (res["res"] == "ok") {
      List body = res["body"];
      for (var e in body) {
        List<String> imageUrl = [];
        e["productImages"].forEach((image) {
          imageUrl.add(image["url"]);
        });
        _listExclusiveProduct.add(Product(
            id: e["_id"],
            name: e["productName"],
            price: e["priceResult"],
            images: imageUrl));
      }
    }
  }

  String? level;

  void getUserLevel() async {
    String wUserId = sessionManager.nUserId!;
    Uri url = Uri.parse('$kMgApi/Users?\$select[0]=level&_id=$wUserId');
    final respose = await http.get(url);
    var data = jsonDecode(respose.body);
    if (mounted) {
      setState(() {
        level = data[0]["level"].toString();
      });
    }
  }

  String? walletUser;

  void getUserWallet() async {
    String wUserId = sessionManager.nUserId!;
    Uri url = Uri.parse('$kMgApi/SaldoPay?user=$wUserId');
    final respose = await http.get(url);
    var data = jsonDecode(respose.body);
    for (var e in data) {
      userWallet.add(Wallet(saldo: e["saldo"]));
    }
    Wallet wallet = userWallet.last;
    if (mounted) {
      setState(() {
        walletUser = formatToRp(wallet.saldo!).toString();
      });
    }
  }

  Future getAllProduct() async {
    Map res = await getPublishedProduct(limit, skip);
    if (res["res"] == "ok") {
      List body = res["body"];
      for (var e in body) {
        List<String> imageUrl = [];
        e["productImages"].forEach((image) {
          imageUrl.add(image["url"]);
        });
        _listAllProduct.add(Product(
            id: e["_id"],
            name: e["productName"],
            price: e["priceResult"],
            images: imageUrl));
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future handleUserCartCount() async {
    if (sessionManager.nToken != null && sessionManager.nUserId != null) {
      Map res = await countUserCartItems(
          sessionManager.nToken!, sessionManager.nUserId!);
      switch (res["res"]) {
        case "ok":
          if (mounted) {
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
          }

          break;
      }
    } else {
      setState(() {
        _isNotifyCart = false;
      });
    }
  }

  final Uri _url = Uri.parse(
      'https://wa.me/+6281231996225?text=Halo Panenin! Saya mau bertanya');
  void _launchWA({required String url}) async {
    if (await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw 'gagal';
    }
  }

  List<BannerType> _listBanner = [];
  List<String> bannerImage = [];
  List<String> bannerConditions = [];
  List<String> bannerTypeConditions = [];
  List<String> bannerProductName = [];
  List<String> bannerProductImage = [];
  List<String> bannerProductId = [];

  Future getBannerImage() async {
    Map res = await getBannerImages();
    if (res["res"] == "ok") {
      List body = res["body"];
      for (var e in body) {
        e["image"].forEach((image) {
          bannerImage.add(image["url"]);
        });
        Map valueMap = jsonDecode(e["action"] ?? "");
        _listBanner.add(BannerType(
          type: e["type"],
          action: valueMap,
          actionType: valueMap["type"],
          actionId: valueMap["id"],
        ));
        pType = e["type"];
        bannerConditions.add(e["type"]);
        bannerTypeConditions.add(valueMap["type"]);
        bannerProductName.add(valueMap["name"]);
        bannerProductId.add(valueMap["id"]);
        bannerProductImage = valueMap["image"].cast<String>().toList();

        // print(bannerProductId);
        // print(bannerProductImage);
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? pType, pActionType, pActionId;

  void handleAdTapped(int index) {
    // Handle the onTap event for the ad at the specified index
    String condition = bannerConditions[index];
    String conditionType = bannerTypeConditions[index];
    //         bannerProductName.add(valueMap["name"]);
    //     bannerProductImage.add(valueMap["image"]);
    //     bannerProductId.add(valueMap["id"]);
    String conditionProductName = bannerProductName[index];
    // String conditionProductImage = bannerProductImage[index];
    String conditionProductId = bannerProductId[index];
    if (condition == 'PARCEL') {
      print("Parcel");
      Navigator.push(
          context, MyRoute(builder: (_) => const EventParcelScreen()));
      // Only perform an action if the condition is met
      // Add your logic here, such as navigating to a specific page
    } else {
      if (conditionType == "TOKO") {
        print("toko");
      } else {
        // print(conditionProductImage);
        navigateToDetail(
            bannerProductImage, conditionProductName, conditionProductId);
      }
    }
  }

  @override
  void initState() {
    sessionManager.getPref().then((value) {
      setState(() {
        idUser = sessionManager.nUserId;
        token = sessionManager.nToken;
        phoneNumber = sessionManager.nPhoneNumber;
        longName = sessionManager.nLongName;
        isVerified = sessionManager.nIsVerified;
      });
    });
    super.initState();
    (() async {
      getUserLevel();
      await getMainCategories();
      await getBannerImage();
      getUserWallet();
      await getAllProduct();
      await handleUserCartCount();
    })();
  }

  @override
  void initStates() {
    super.initState();
    getAllProduct().then((value) {
      setState(() {
        _listAllProduct.addAll(value);
        _dataFilter = _listAllProduct;
      });
    });
  }

  _ListProductState(String value) {
    _cari.addListener(() {
      if (_cari.text.isEmpty) {
        setState(() {
          isSearch = true;
        });
      } else {
        setState(() {
          isSearch = false;
        });
      }
    });
  }

  Widget filterData(String value) {
    _dataFilter = [];
    for (int i = 0; i < _listAllProduct.length; i++) {
      var data = _listAllProduct[i];
      if (data.name!.toLowerCase().contains(_cari.text.toLowerCase())) {
        _dataFilter.add(data);
      }
      _cari.addListener(() {
        if (_cari.text.isEmpty) {
          setState(() {
            isSearch = true;
          });
        } else {
          setState(() {
            isSearch = false;
          });
        }
      });
    }
    return showFilterList();
  }

  Widget showFilterList() {
    return (_dataFilter.isNotEmpty)
        ? GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: (150.0 / 200.0)),
            itemCount: _dataFilter.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = _dataFilter[index];
              return WCard_Product(() {
                navigateToDetail(product.images!, product.name!, product.id!);
              }, context, product.name ?? "-", product.price ?? 0,
                  product.images?[0] ?? "");
            },
          )
        : Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  children: const [
                    Spacer(),
                    Text("Produk Yang Anda Cari Tidak Ada"),
                    Spacer()
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    // (() async => await handleUserCartCount())();
    double mediaW = MediaQuery.of(context).size.width;
    double mediaH = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SvgPicture.asset('assets/images/top_auth.svg', width: mediaW),
            Scaffold(
              backgroundColor: Colors.transparent,
              // floatingActionButton: FloatingActionButton(
              //   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              //   foregroundColor: c.greenColor,
              //   onPressed: () {
              //     _launchWA(url: "$_url");
              //   },
              //   child: const Icon(
              //     Icons.headset_rounded,
              //     size: 30,
              //   ),
              // ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
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
                        Expanded(
                          // flex: 8,
                          child: Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(15),
                            child: TextFormField(
                              controller: _cari,
                              onChanged: (value) => filterData(value),
                              cursorColor: c.blackColor,
                              autofocus: false,
                              style: TextStyle(
                                fontSize: mediaW / 32,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: c.blackColor,
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(
                                    maxHeight: 35, minWidth: 30),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Cari Produk Di Sini....",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                        // WSearchBar(8, _cari, () {}, () {
                        //   (value) => updateList(value);
                        // }, 'Cari Produk Disini...', context),
                        SizedBox(
                          width: mediaW / 52,
                        ),
                        WActionButton(
                          Icon(
                            Icons.notifications_none_outlined,
                            color: c.greenColor,
                          ),
                          c.whiteColor,
                          mediaW / 7,
                          50,
                          context,
                          isNotify: _isNotifyNotif,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MyRoute(
                                    builder: (_) =>
                                        const NotificationScreen()));
                          },
                        ),
                        SizedBox(
                          width: mediaW / 52,
                        ),
                        WActionButton(
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: c.greenColor,
                            ),
                            c.whiteColor,
                            mediaW / 7,
                            50,
                            context,
                            qty: _cartCount,
                            isNotify: _isNotifyCart, onPressed: () {
                          Navigator.push(context,
                              MyRoute(builder: (_) => const CartScreen()));
                        })
                      ],
                    ),
                  ),
                ),
              ),
              body: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(
                    waterDropColor: c.brownColor,
                    refresh: LoadingAnimationWidget.waveDots(
                        color: c.whiteColor, size: mediaW / 15),
                    complete: Row(
                      children: [
                        const Spacer(),
                        Text(
                          "Refresh Berhasil",
                          style: TextStyle(color: c.whiteColor),
                        ),
                        Icon(
                          Icons.check,
                          color: c.whiteColor,
                          size: 18,
                        ),
                        const Spacer()
                      ],
                    )),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Row(
                        children: [
                          Spacer(),
                          Icon(
                            Icons.arrow_upward_rounded,
                            weight: 0.5,
                            color: c.brownColor,
                          ),
                          Text("Tarik ke Atas Untuk Memuat",
                              style: TextStyle(color: c.brownColor)),
                          Spacer()
                        ],
                      );
                    } else if (mode == LoadStatus.loading) {
                      body = LoadingAnimationWidget.waveDots(
                          color: c.brownColor, size: mediaW / 15);
                    } else if (mode == LoadStatus.failed) {
                      body = const Text("Gagal Memuat! Tekan Ulangi!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = const Text("Lepas Untuk Memuat Lebih Banyak");
                    } else {
                      body = const Text("Produk Telah Mencapai Batas");
                    }
                    return Container(
                      height: 70.0,
                      child: Center(child: body),
                    );
                  },
                ),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 6),
                          height: mediaH / 9.5,
                          width: mediaW,
                          decoration: BoxDecoration(
                            color: c.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(13),
                            child:
                                SvgPicture.asset('assets/images/kasanah.svg'),
                          )),
                        ),
                      ),
                      (sessionManager.nIsVerified == "true")
                          ? Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height:
                                        120, // Customize the height of the carousel
                                    autoPlay: true, // Enable auto-play
                                    enlargeCenterPage:
                                        true, // Enable zoom effect for the center item
                                  ),
                                  items: bannerImage.map((image) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        int index = bannerImage.indexOf(image);
                                        return GestureDetector(
                                          onTap: () => handleAdTapped(index),
                                          child: Container(
                                            height: mediaH / 20,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 5.0),
                                            child: Image.network(
                                              image,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 12,
                            ),
                      _isLoading
                          ? SizedBox(
                              height: mediaH / 2,
                              child: Center(
                                  child: LoadingAnimationWidget.waveDots(
                                size: mediaW / 15,
                                color: c.greenColor,
                              )),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: c.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 1,
                                      offset: Offset(0, -8), // Shadow position
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 15),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Selamat Datang',
                                              style: TextStyle(
                                                  color: c.greenColor,
                                                  fontSize: 13),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.account_circle_rounded,
                                                  color: c.greenColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                  width: mediaW / 2.7,
                                                  child: Text(
                                                    '$longName',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: c.greenColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                decoration: ShapeDecoration(
                                                    color: c.brownColor,
                                                    shape:
                                                        const StadiumBorder()),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  child: Text(
                                                    (isVerified == "true" &&
                                                            level == "2")
                                                        ? "Mitra"
                                                        : (isVerified == "true")
                                                            ? "Verified"
                                                            : "Not Verified",
                                                    style: TextStyle(
                                                        color: c.whiteColor,
                                                        fontSize: 12),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Container(
                                            width: 2,
                                            height: 50,
                                            color: c.greyColor),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Saldo Kasanah Pay',
                                                  style: TextStyle(
                                                      color: c.greenColor),
                                                ),
                                                Row(
                                                  children: [
                                                    (walletUser == null)
                                                        ? Text(
                                                            'Rp0',
                                                            style: TextStyle(
                                                                color: c
                                                                    .blackColor,
                                                                fontSize:
                                                                    mediaW / 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )
                                                        : Text(
                                                            '$walletUser',
                                                            style: TextStyle(
                                                                color: c
                                                                    .blackColor,
                                                                fontSize:
                                                                    mediaW / 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Text(
                                                    'Isi Saldo Hubungi Admin',
                                                    style: TextStyle(
                                                        color: c.greenColor,
                                                        fontSize: mediaW / 40),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    child: Text(
                                      'Semua Kategori',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: c.greenColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  (_listCategory.isNotEmpty)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.white,
                                                      c.greenColor,
                                                    ],
                                                  ),
                                                ),
                                                child: SizedBox(
                                                    height: mediaH / 3.6,
                                                    child: ListView.builder(
                                                      addAutomaticKeepAlives:
                                                          false,
                                                      addRepaintBoundaries:
                                                          false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      shrinkWrap: false,
                                                      physics:
                                                          // const NeverScrollableScrollPhysics(),
                                                          const AlwaysScrollableScrollPhysics(),
                                                      itemCount:
                                                          _listCategory.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        CategoryProduct
                                                            category =
                                                            _listCategory[
                                                                index];
                                                        return WCard_ProductCategory(
                                                            context,
                                                            _listCategory[index]
                                                                    .category ??
                                                                "",
                                                            _listCategory[index]
                                                                .images![0],
                                                            onTap: () {
                                                          navigateToCategory(
                                                              category.images!,
                                                              category
                                                                  .category!,
                                                              category.id!);
                                                        });
                                                      },
                                                    )),
                                              ),
                                            ])
                                      : SizedBox(
                                          height: mediaH / 42,
                                        ),
                                  Container(
                                    width: mediaW,
                                    decoration: BoxDecoration(
                                        color: c.brownColor
                                        // gradient: LinearGradient(
                                        //   begin: Alignment.centerLeft,
                                        //   end: Alignment.centerRight,
                                        //   colors: [
                                        //     c.greenColor,
                                        //     Colors.white,
                                        //   ],
                                        // ),
                                        // borderRadius: const BorderRadius.only(
                                        //     topLeft: Radius.circular(16),
                                        //     topRight: Radius.circular(16))
                                        ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: defaultPadding,
                                              vertical: 8),
                                          child: Text(
                                            'Semua Produk',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: c.whiteColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: isSearch
                                        ? GridView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    childAspectRatio:
                                                        (150.0 / 200.0)),
                                            itemCount: _listAllProduct.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              Product product =
                                                  _listAllProduct[index];
                                              return WCard_Product(() {
                                                navigateToDetail(
                                                    product.images!,
                                                    product.name!,
                                                    product.id!);
                                              },
                                                  context,
                                                  product.name ?? "-",
                                                  product.price ?? 0,
                                                  product.images?[0] ?? "");
                                            },
                                          )
                                        : showFilterList(),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
