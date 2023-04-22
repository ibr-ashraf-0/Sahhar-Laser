import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final FirebaseStorage storage = FirebaseStorage.instance;

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class EditProduct extends StatefulWidget {
  final String productId;

  const EditProduct(
      {Key? key, required this.productId, required String categoryId})
      : super(key: key);
  @override
  EditProductState createState() => EditProductState();
}

class EditProductState extends State<EditProduct> {
  final formKey = GlobalKey<FormState>();
  final imageController = TextEditingController();
  final txtname = TextEditingController();
  final txtprice = TextEditingController();
  final txtdescri = TextEditingController();
  final txtsize = TextEditingController();
  bool showSizes = false;
  int count = 1;
  bool switchValue = false;
  List<String> sizes = [];
  List<String> categories = [];
  List<bool> SelectedCategory = [];
  int selectedCategoryIndex = 0;
  late File imageFile;
  late File colorFile;

  // fetch categories data from Firebase
  Future<List<String>> fetchCategories() async {
    QuerySnapshot snapshot = await firestore.collection("categories").get();
    List<String> categories = [];
    snapshot.docs.forEach((doc) {
      categories.add(doc["name"]);
    });
    return categories;
  }

  @override
  void initState() {
    super.initState();
    fetchCategories().then((value) {
      setState(() {
        categories = value;
        SelectedCategory = List<bool>.filled(categories.length, false);
      });
      FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get()
          .then((docSnapshot) {
        if (docSnapshot.exists) {
          setState(() {
            txtname.text = docSnapshot['name'];
            txtdescri.text = docSnapshot['description'];
            sizes = List.from(docSnapshot['size']);
            txtsize.text = sizes.join(', ');
            txtprice.text = docSnapshot['price'].toString();
            colorFile = docSnapshot['colorUrl'];
            imageFile = docSnapshot['imageUrl'];
            switchValue = docSnapshot['switchValue'];
          });
        }
      });
    });
    addtextfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Update Product',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: txtname,
                  decoration: InputDecoration(
                    labelText: 'Name of Product',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
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
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: lst.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Container(width: 100, child: lst[index]),
                                );
                              })),
                      Container(
                        width: 50,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF7E0000),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {
                              addtextfile();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: txtprice,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF7E0000),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            showSizes = !showSizes;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        // use the getImage method on the instance to pick an image from the gallery
                        var image = await imagePicker.getImage(
                          source: ImageSource.gallery,
                        );
                        // set the image file to the state
                        if (image != null) {
                          setState(() {
                            colorFile = File(image.path);
                          });
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: 230,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 226, 224, 224),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.attach_file),
                            SizedBox(width: 5),
                            Text(
                              'Choose Colors',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF7E0000),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          /*setState(() {
                    showSizes = !showSizes;
                  });*/
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        // use the getImage method on the instance to pick an image from the gallery
                        var image = await imagePicker.getImage(
                          source: ImageSource.gallery,
                        );
                        // set the image file to the state
                        if (image != null) {
                          setState(() {
                            imageFile = File(image.path);
                          });
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        width: 230,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 226, 224, 224),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.attach_file),
                            SizedBox(width: 5),
                            Text(
                              'Choose Images',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF7E0000),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          /*setState(() {
                    showSizes = !showSizes;
                  });*/
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      switchValue ? 'With Text' : 'Without Text',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Switch(
                      value: switchValue,
                      onChanged: (bool value) {
                        setState(() {
                          switchValue = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      int index = categories.indexOf(category);
                      return Row(children: [
                        Checkbox(
                          value: SelectedCategory[index],
                          onChanged: (bool? newValue) {
                            setState(() {
                              SelectedCategory[index] = newValue ?? false;
                            });
                          },
                        ),
                        Text(category) // add the category name here
                      ]);
                    }).toList(),
                  ),
                ),

                SizedBox(height: 10),

                InkWell(
                  onTap: () async {
                    try {
                      // upload the image to Firebase Storage
                      String imageUrl = '';
                      if (imageFile != null) {
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('products/${DateTime.now().toString()}');
                        await ref.putFile(imageFile);
                        imageUrl = await ref.getDownloadURL();
                      }

                      // upload the image to Firebase Storage
                      String colorUrl = '';
                      if (colorFile != null) {
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('products/${DateTime.now().toString()}');
                        await ref.putFile(colorFile);
                        colorUrl = await ref.getDownloadURL();
                      }

                      // Save product information to the "products" collection
                      await FirebaseFirestore.instance
                          .collection("products")
                          .doc(widget.productId)
                          .set({
                        "name": txtname!.text,
                        "description": txtdescri!.text,
                        "size": txtsize!.text,
                        "price": txtprice!.text,
                        'imageUrl': imageUrl,
                        'colorUrl': colorUrl,
                        "switchValue": switchValue,
                        "categories": SelectedCategory.asMap()
                            .entries
                            .where((entry) => entry.value == true)
                            .map((entry) => categories[entry.key])
                            .toList(),
                      });

// Save product information to the selected categories
                      List<String> selectedCategories = SelectedCategory.asMap()
                          .entries
                          .where((entry) => entry.value == true)
                          .map((entry) => categories[entry.key])
                          .toList();

                      for (String selectedCategory in selectedCategories) {
                        QuerySnapshot snapshot = await FirebaseFirestore
                            .instance
                            .collection("categories")
                            .where("name", isEqualTo: selectedCategory)
                            .get();

                        if (snapshot.docs.length > 0) {
                          String categoryId = snapshot.docs[0].id;

                          await FirebaseFirestore.instance
                              .collection("categories")
                              .doc(categoryId)
                              .collection("items")
                              .doc(widget.productId)
                              .update({
                            "name": txtname!.text,
                            "description": txtdescri!.text,
                            "size": txtsize!.text,
                            "price": txtprice!.text,
                            'imageUrl': imageUrl,
                            'colorUrl': colorUrl,
                            "switchValue": switchValue,
                          });
                        }
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            title: Text("Success",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            content: Container(
                              width: MediaQuery.of(context).size.width * 10,
                              child: Text("Product updated successfully"),
                            ),
                            actions: <Widget>[
                              InkWell(
                                child: Text("OK  ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } catch (x) {
                      print(x.toString());
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Color(0xFF7E0000),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> lst = [];
  void addtextfile() {
    lst.add(
      TextFormField(
        controller: txtsize,
        decoration: InputDecoration(
          labelText: 'Size',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a size';
          }
          return null;
        },
        // visible: showSizes,
      ),
    );
  }
}
