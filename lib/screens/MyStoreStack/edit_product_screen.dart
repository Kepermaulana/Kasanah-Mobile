import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/service/sell_service.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/my_product_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.id,
      required this.categoryId,
      required this.description,
      required this.categoryName,
      required this.price,
      required this.originalPrice,
      required this.stock})
      : super(key: key);
  final String imageUrl;
  final String name;
  final String id;
  final String categoryId;
  final String description;
  final String categoryName;
  final String price;
  final String originalPrice;
  final String stock;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  TextEditingController productName = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productStock = TextEditingController();

  bool _isLoading = false;
  File? image;
  String? categoryType;

  Map datas = {};

  Future editProduct() async {
    datas = {
      ...datas,
      "name": productName.text,
      "description": productDescription.text,
      "price": productPrice.text,
      "stock": productStock.text
    };
    setState(() {
      _isLoading = true;
    });
    Product pr = Product(
      name: datas["name"],
      description: datas["description"],
      price: int.parse(datas["price"]),
      stock: int.parse(datas["stock"]),
    );
    if (image == null) {
      Map editProductRes =
          await editProductServiceWithoutImage(pr, categoryValue, widget.id);
    } else {
      String fileName = image!.path.split("/").last;
      Map editProductRes = await editProductService(
          pr, image!.path, fileName, categoryValue, widget.id);
    }
    setState(() {
      _isLoading = false;
    });
    setState(() {
      Navigator.pushAndRemoveUntil(
        context,
        MyRoute(builder: (context) => const MyProductScreen()),
        (route) => false,
      );
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WDialog_TextAlert(
              context, 'Edit Produk Berhasil', 'Silahkan Cek Kembali');
        },
      );
    });
  }

  Future getImageCamera() async {
    var takeImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (takeImage != null) {
      setState(() {
        image = File(takeImage.path);
      });
    }
  }

  Future getImageGallery() async {
    var takeImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (takeImage != null) {
      setState(() {
        image = File(takeImage.path);
      });
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // scrollable: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Pilih Media Untuk Upload Bukti Transfer'),
            content: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: [
                    const Spacer(),
                    WButton_Filled(() {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                        Text(
                          'Galeri',
                          style: TextStyle(color: c.whiteColor),
                        ),
                        context,
                        color: c.brownColor,
                        height: 14),
                    const SizedBox(
                      height: 10,
                    ),
                    WButton_Filled(() {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                        Text(
                          'Kamera',
                          style: TextStyle(color: c.whiteColor),
                        ),
                        context,
                        color: c.brownColor,
                        height: 14),
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<dynamic> _dataProvince = [];
  var categoryValue;

  void getProvince() async {
    Uri url = Uri.parse(
        '$kMgApi/categoryProduct/?\$select[0]=_id&\$select[1]=category');
    final respose = await http.get(url);
    var listData = jsonDecode(respose.body);
    setState(() {
      _dataProvince = listData;
    });
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  @override
  void initState() {
    datas = {
      "name": widget.name,
      "description": widget.description,
      "price": widget.originalPrice,
      "stock": widget.stock,
      "category": widget.categoryName
    };

    setState(() {
      productName = TextEditingController(text: datas["name"]);
      productDescription = TextEditingController(text: datas["description"]);
      productPrice = TextEditingController(text: datas["price"]);
      productStock = TextEditingController(text: datas["stock"]);

      categoryValue = widget.categoryId;
    });
    // TODO: implement initState
    super.initState();
    getProvince();
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
              Navigator.push(context,
                  MyRoute(builder: (context) => const MyProductScreen()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
        title: Text(
          'Edit Produk',
          style: TextStyle(color: c.blackColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: mediaW,
            height: mediaH,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          myAlert();
                        },
                        child: image == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  WForm_Default(
                      'Masukkan Nama Produk', 'Nama Produk', productName,
                      context: context),
                  const SizedBox(
                    height: 30,
                  ),
                  WForm_Default('Deskripsi Produk', 'Masukkan Deskripsi Produk',
                      productDescription,
                      context: context),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // WForm_DropdownField(
                      //   context,
                      //   "Kategori Produk",
                      //   datas["category"],
                      //   (value) {
                      //     if (value == "Fashion") {
                      //       setState(() {
                      //         value = "6404cde21f0e73c8ee9bf604";
                      //       });
                      //     }
                      //     if (value == "Elektronik") {
                      //       setState(() {
                      //         value = "6404cf181f0e73c8ee9bf607";
                      //       });
                      //     }
                      //     if (value == "Komputer & Aksesoris") {
                      //       setState(() {
                      //         value = "640fe7ac6f30fdced9c5388b";
                      //       });
                      //     }
                      //     if (value == "Qurban") {
                      //       setState(() {
                      //         value = "6423e415a4f52dc060090d52";
                      //       });
                      //     }
                      //     setState(() {
                      //       categoryValue = value;
                      //     });
                      //   },
                      //   _dataProvince.map((item) {
                      //     return item["category"];
                      //   }).toList(),
                      // ),
                      // const Divider(
                      //   thickness: 2,
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.sell),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("Harga *"),
                          const Spacer(),
                          Flexible(
                              child: SizedBox(
                            width: 140,
                            child: TextFormField(
                              controller: productPrice,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  prefixText: 'Rp. ',
                                  border: const UnderlineInputBorder(),
                                  hintStyle: TextStyle(
                                    color: c.greyColor,
                                  )),
                            ),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.layers),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("Stock *"),
                          const Spacer(),
                          Flexible(
                              child: SizedBox(
                            width: 140,
                            child: TextFormField(
                              controller: productStock,
                              keyboardType: TextInputType.number,
                              cursorColor: c.brownColor,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: c.brownColor)),
                                  suffixText: 'Pcs',
                                  hintStyle: TextStyle(
                                    color: c.greyColor,
                                  )),
                            ),
                          ))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: WButton_Filled(() async {
          await editProduct();
        },
            _isLoading
                ? LoadingAnimationWidget.waveDots(
                  size: mediaW / 15,
                    color: c.greenColor,
                  )
                : Text("Ubah", style: TextStyle(color: c.whiteColor)),
            context,
            isDisabled: _isLoading,
            height: 14,
            width: 1,
            color: c.brownColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
