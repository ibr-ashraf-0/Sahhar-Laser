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
  final txtcateg = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  XFile? _fileImage;
  String? imageUrl;
  ImagePicker picker = ImagePicker();

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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    final pickedImageFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedImageFile != null) {
                      _fileImage = XFile(pickedImageFile.path);
                      final storage = FirebaseStorage.instance
                          .ref()
                          .child('categories')
                          .child(_fileImage!.path.replaceAll('/', '_'));
                      await storage
                          .putFile(File(_fileImage!.path))
                          .then((_) async {
                        imageUrl = await storage.getDownloadURL();
                        setState(() {});
                      });
                    } else {
                      print('No Image Selcted');
                    }
                  },
                  child: imageUrl != null
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(imageUrl.toString()),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          // color: Colors.amber,
                          height: MediaQuery.of(context).size.height * 0.30,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'No Image +',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Click Here to Add Catogry image',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Create Category...',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: txtcateg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'plese enter a catogry name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name of Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF7E0000),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    autofocus: true,
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          imageUrl != null) {
                        try {
                          // add the category data to Firestore
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(txtcateg.text)
                              .set({
                            'name': txtcateg.text,
                            'imageUrl': imageUrl,
                          });
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                title: const Text("Success",
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width * 10,
                                  child:
                                      const Text("Category added successfully"),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCategory()),
                            );
                          });
                        } catch (x) {
                          print(x.toString());
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'please put image for your catogry',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
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
