import 'dart:convert';
import 'dart:io';
import 'package:kasanah_mobile/core/api/api.dart';
import 'package:kasanah_mobile/core/class/product_class.dart';
import 'package:kasanah_mobile/core/style/Colors.dart' as c;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kasanah_mobile/core/style/Constants.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/my_product_screen.dart';
import 'package:kasanah_mobile/screens/MyStoreStack/store_screen.dart';
import 'package:kasanah_mobile/widgets/WAlertDialog.dart';
import 'package:kasanah_mobile/widgets/WButton.dart';
import 'package:kasanah_mobile/widgets/WForm.dart';
import 'package:kasanah_mobile/widgets/WGlobal.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasanah_mobile/core/service/sell_service.dart';
import 'package:kasanah_mobile/widgets/WNavigationBar.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _MyProductState();
}

class _MyProductState extends State<AddProductScreen> {
  TextEditingController productName = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productStock = TextEditingController();

  String? categoryType;
  bool _isLoading = false;
  File? image;

  Future sellProduct() async {
    setState(() {
      _isLoading = true;
    });
    String fileName = image!.path.split("/").last;
    Product pr = Product(
        name: productName.text,
        description: productDescription.text,
        price: int.parse(productPrice.text),
        stock: int.parse(productStock.text));
    Map sellProductRes =
        await uploadProduct(pr, image!.path, fileName, categoryValue);
    setState(() {
      _isLoading = false;
    });
    setState(() {
      Navigator.pushAndRemoveUntil(
        context,
        MyRoute(builder: (context) => MyProductScreen()),
        (route) => false,
      );
      showDialog(
        barrierColor: Colors.black26,
        context: context,
        builder: (context) {
          return WDialog_TextAlert(
              context, 'Tambah Produk Berhasil', 'Silahkan Cek');
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

  @override
  void initState() {
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
              Navigator.pushAndRemoveUntil(
                context,
                MyRoute(builder: (context) => WNavigationBar()),
                (route) => false,
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.blackColor,
            )),
        title: Text(
          'Tambah Produk',
          style: TextStyle(color: c.blackColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: mediaW,
            height: mediaH,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      // Container(
                      //   width: 90,
                      //   height: 90,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(8),
                      //       color: Colors.white,
                      //       border:
                      //           Border.all(color: Colors.blueAccent, width: 1,),),
                      // )
                      GestureDetector(
                        onTap: () {
                          myAlert();
                        },
                        child: image == null
                            ? DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(8),
                                padding: EdgeInsets.all(12),
                                color: c.brownColor,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "Tambah Foto",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: c.brownColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  WForm_Default(
                      'Masukkan Nama Produk', 'Nama Produk', productName,
                      context: context),
                  SizedBox(
                    height: 30,
                  ),
                  WForm_Default('Deskripsi Produk', 'Masukkan Deskripsi Produk',
                      productDescription,
                      context: context),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton(
                        hint: Text("Pilih Kategori"),
                        value: categoryValue,
                        items: _dataProvince.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['category']),
                            value: item['_id'],
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            categoryValue = value;
                          });
                        },
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: [
                      //     Icon(Icons.featured_play_list),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text("Variasi"),
                      //     Spacer(),
                      //     IconButton(
                      //       icon: Icon(
                      //         Icons.chevron_right,
                      //         color: Colors.black,
                      //       ),
                      //       onPressed: () {},
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Icon(Icons.sell),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Harga *"),
                          Spacer(),
                          Flexible(
                              child: SizedBox(
                            width: 140,
                            child: TextFormField(
                              controller: productPrice,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  prefixText: 'Rp. ',
                                  border: UnderlineInputBorder(),
                                  hintStyle: TextStyle(
                                    color: c.greyColor,
                                  )),
                            ),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.layers),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Stock *"),
                          Spacer(),
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
          await sellProduct();
          //  Navigator.push(context,
          //     MyRoute(builder: (_) => const SignupScreen()));
        },
            _isLoading
                ? LoadingAnimationWidget.waveDots(
                  size: mediaW / 15,
                    color: c.greenColor,
                  )
                : Text("Simpan", style: TextStyle(color: c.whiteColor)),
            context,
            isDisabled: _isLoading,
            height: 14,
            width: 1,
            color: c.brownColor),
        //   WButton_Filled(
        //   () {
        //     _proceed();
        //   },
        //   _isLoading
        //       ? LoadingAnimationWidget.waveDots(
        //           color: c.greenColor,
        //         )
        //       : Text("Masuk", style: TextStyle(color: c.whiteColor)),
        //   context,
        //   isDisabled: _isLoading,
        //   color: c.brownColor,
        //   height: 14,
        // ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
