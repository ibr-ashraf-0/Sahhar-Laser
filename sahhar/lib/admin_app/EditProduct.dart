import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sahhar/admin_app/Products.dart';
import 'dart:io';

import '../widget/chooseColor.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EditProduct extends StatefulWidget {
  final String productId;

  const EditProduct({Key? key, required this.productId}) : super(key: key);
  @override
  EditProductState createState() => EditProductState();
}

class EditProductState extends State<EditProduct> {
  final txtname = TextEditingController();
  final txtdescri = TextEditingController();
  String? baseCateogry;
  String productId = '';
  String productName = '';
  String oldName = '';
  String productDescription = '';
  String categoryName = '';
  List<String> oldSizes = [];
  List<String> oldPrices = [];
  List<String> productSizes = [];
  List<String> productPrices = [];
  final formKey = GlobalKey<FormState>();
  int lenghtOfFiled = 0;
  List<String> imagesurl = [];
  List<String> imagesPath = [];
  XFile? _fileImage;
  ImagePicker picker = ImagePicker();
  bool switchValue = false;

  void pickImage() async {
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      _fileImage = XFile(pickedImageFile.path);
      final storage = FirebaseStorage.instance
          .ref()
          .child('products')
          .child('testing')
          .child(pickedImageFile.path.replaceAll('/', '_'));

      await storage.putFile(File(_fileImage!.path)).then((_) async {
        String url = await storage.getDownloadURL();
        imagesurl.add(url);
        imagesPath.add(pickedImageFile.path.replaceAll('/', '_'));
        setState(() {});
      });
    } else {
      print('No Image Selcted');
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        baseCateogry = docSnapshot.data()!['baseCategory'];
        txtname.text = docSnapshot.data()!['name'];
        oldName = docSnapshot.data()!['name'];
        txtdescri.text = docSnapshot.data()!['description'];
        oldSizes = List.from(docSnapshot.data()!['size']);
        lenghtOfFiled = oldSizes.length;
        oldPrices = List.from(docSnapshot.data()!['price']);
        choosesRegulerColor = List.from(docSnapshot.data()!['regulerColor']);
        choosesRegulerNameColor =
            List.from(docSnapshot.data()!['regulerNames']);
        choosesWoodsColor = List.from(docSnapshot.data()!['woodColors']);
        choosesWoodsNameColor = List.from(docSnapshot.data()!['woodNames']);
        switchValue = docSnapshot.data()!['switchValue'];
        imagesurl = List.from(docSnapshot.data()!['imageUrl']);
      }
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection('categories')
          .doc(baseCateogry)
          .get()
          .then((value) {
        setState(() {
          categoryName = value.data()!['name'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Product Catogry is',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 2.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF7E0000),
                      ),
                      padding: EdgeInsets.zero,
                      child: Center(
                          child: Text(
                        categoryName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22),
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: txtname,
                  onSaved: (val) {
                    productName = val!;
                  },
                  key: const ValueKey('name'),
                  cursorColor: const Color(0xFF7E0000),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color(0xFF7E0000),
                    ),
                    labelText: 'Name of Product',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF7E0000),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Name ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: txtdescri,
                  onSaved: (val) {
                    productDescription = val!;
                  },
                  key: const ValueKey('description'),
                  cursorColor: const Color(0xFF7E0000),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color(0xFF7E0000),
                    ),
                    labelText: 'Description',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF7E0000),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: lenghtOfFiled != oldSizes.length
                      ? lenghtOfFiled * 75
                      : oldSizes.length * 75,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: const Color.fromARGB(179, 248, 220, 220),
                  child: ListView.builder(
                    itemCount: lenghtOfFiled,
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.459,
                                height: 65,
                                child: TextFormField(
                                  initialValue: lenghtOfFiled > oldSizes.length
                                      ? ''
                                      : oldSizes[index],
                                  onSaved: (val) {
                                    setState(() {
                                      productSizes.add(val.toString());
                                    });
                                  },
                                  key: const ValueKey('size'),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Size',
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        )),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  cursorColor: Colors.black,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter size';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.459,
                                height: 65,
                                child: TextFormField(
                                  initialValue: lenghtOfFiled > oldSizes.length
                                      ? ''
                                      : oldPrices[index],
                                  onSaved: (val) {
                                    setState(() {
                                      productPrices.add(val.toString());
                                    });
                                  },
                                  key: const ValueKey('price'),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Price',
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        )),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  cursorColor: Colors.black,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a price';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            child: const Icon(
                              Icons.remove_circle_outline_sharp,
                              size: 18,
                              color: Color(0xFF7E0000),
                            ),
                            onTap: () {
                              setState(() {
                                lenghtOfFiled -= 1;
                              });
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      lenghtOfFiled += 1;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.add,
                          color: Color(0xFF7E0000),
                          size: 18,
                        ),
                        Text(
                          'Add a new size and price',
                          style: TextStyle(
                              color: Color(0xFF7E0000),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const chooseColor(),
                const SizedBox(height: 12),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 2.1,
                        child: RawMaterialButton(
                          onPressed: pickImage,
                          elevation: 0,
                          fillColor: const Color(0xFF7E0000),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          splashColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text(
                                'Choose Product Images',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            switchValue! && switchValue != null
                                ? 'product With\nText'
                                : 'product Without\nText',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Switch.adaptive(
                            value: switchValue,
                            onChanged: (bool value) {
                              setState(() {
                                switchValue = value;
                              });
                            },
                            activeTrackColor:
                                const Color(0xFF7E0000).withOpacity(0.3),
                            activeColor: const Color(0xFF7E0000),
                            inactiveTrackColor: Colors.grey,
                            inactiveThumbColor: Colors.black,
                          ),
                        ],
                      ),
                    ]),
                imagesurl.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        color: Colors.grey.shade300,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 75,
                          child: ListView.builder(
                              itemCount: imagesurl.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  width: 60,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    image: imagesurl.isNotEmpty
                                        ? DecorationImage(
                                            image:
                                                NetworkImage(imagesurl[index]),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        imagesurl.removeWhere((element) =>
                                            element == imagesurl[index]);
                                        FirebaseStorage.instance
                                            .ref()
                                            .child('products')
                                            .child('testing')
                                            .child(imagesPath[index])
                                            .delete();
                                      });
                                    },
                                    child: const Icon(
                                      Icons.remove_circle,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: InkWell(
                    onTap: () async {
                      final isValid = formKey.currentState!.validate();
                      if (isValid && imagesurl.isNotEmpty) {
                        formKey.currentState!.save();

                        try {
                          // Save product information to the "products" collection
                          await FirebaseFirestore.instance
                              .collection("products")
                              .doc(widget.productId)
                              .update({
                            "baseCategory": baseCateogry,
                            "name": productName,
                            "description": productDescription,
                            "size": productSizes,
                            "price": productPrices,
                            'regulerColor': choosesRegulerColor,
                            'regulerNames': choosesRegulerNameColor,
                            'woodColors': choosesWoodsColor,
                            'woodNames': choosesWoodsNameColor,
                            'imageUrl': imagesurl,
                            "switchValue": switchValue,
                          });
                          var firebase = await FirebaseFirestore.instance
                              .collection("categories")
                              .doc(baseCateogry)
                              .collection('items')
                              .get();
                          var productData = firebase.docs.where((element) {
                            if (element.data()['name'] == oldName) {
                              setState(() {
                                productId = element.id;
                              });
                              return true;
                            } else {
                              print('false');
                              return false;
                            }
                          });
                          // dont delet this line, this for active the setState in top
                          print('${productData.isEmpty}');
                          // Save product information to the selected categories
                          await FirebaseFirestore.instance
                              .collection("categories")
                              .doc(baseCateogry)
                              .collection('items')
                              .doc(productId)
                              .update({
                            'baseCategory': baseCateogry,
                            "name": productName,
                            "description": productDescription,
                            "size": productSizes,
                            "price": productPrices,
                            'regulerColor': choosesRegulerColor,
                            'regulerNames': choosesRegulerNameColor,
                            'woodColors': choosesWoodsColor,
                            'woodNames': choosesWoodsNameColor,
                            'imageUrl': imagesurl,
                            "switchValue": switchValue,
                          }).then((value) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title: const Text("Success",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 10,
                                    child: const Text(
                                        "Product added successfully"),
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      child: const Text("OK  ",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).then((value) {
                              if (value == true || value != null) {
                                setState(() {});
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Products()),
                                );
                              }
                            });
                          });
                        } catch (e) {
                          print(e.toString());
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'An Error occurred check you are enter all field and you choses a catogry',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 16,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7E0000),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'UPDATE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
