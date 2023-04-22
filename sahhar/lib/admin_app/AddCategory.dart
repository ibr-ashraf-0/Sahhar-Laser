import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final formKey = GlobalKey<FormState>();
  final txtcateg = TextEditingController();
  late File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Category',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Create Category',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                TextFormField(
                  controller: txtcateg,
                  decoration: InputDecoration(
                    labelText: 'Name of Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  /*validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null; 
                  },*/
                ),
                const SizedBox(height: 60),
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
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 226, 224, 224),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.attach_file),
                        SizedBox(width: 5),
                        Text(
                          'Choose Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                InkWell(
                  onTap: () async {
                    try {
                      // upload the image to Firebase Storage
                      String imageUrl = '';
                      if (imageFile != null) {
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('categories/${DateTime.now().toString()}');
                        await ref.putFile(imageFile);
                        imageUrl = await ref.getDownloadURL();
                      }

                      // add the category to Firestore
                      await FirebaseFirestore.instance
                          .collection('categories')
                          .add({
                        'name': txtcateg.text,
                        'imageUrl': imageUrl,
                      });
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
                              child: Text("Category added successfully"),
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
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7E0000),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'Create',
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
}
