import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditCategory extends StatefulWidget {
  final String categoryId;

  const EditCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  String txtcateg = '';
  TextEditingController initValue = TextEditingController();
  String? imageUrl;
  XFile? _fileImage;
  ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    // Retrieve the category details from Firebase
    FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        initValue.text = docSnapshot['name'];
        imageUrl = docSnapshot['imageUrl'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Category',
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("categories")
                      .doc(widget.categoryId)
                      .get(),
                  builder: (contex, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CircularProgressIndicator(
                        color: Color(0xFF7E0000),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(snapshot.data!['imageUrl']),
                          ),
                        ),
                      );
                    }
                  }),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Edit Category Information...',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                onChanged: (val) {
                  txtcateg = val;
                },
                controller: initValue,
                decoration: InputDecoration(
                  labelText: 'Name of Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                alignment: Alignment.centerLeft,
                child: RawMaterialButton(
                  fillColor: const Color(0xFF7E0000),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  autofocus: true,
                  onPressed: () async {
                    // upload the image to Firebase & Storage
                    final pickedImageFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedImageFile != null) {
                      _fileImage = XFile(pickedImageFile.path);
                      final storage = FirebaseStorage.instance
                          .ref()
                          .child('categories/${DateTime.now().toString()}');
                      await storage
                          .putFile(File(_fileImage!.path))
                          .then((_) async {
                        String imageUrl = await storage.getDownloadURL();
                        await FirebaseFirestore.instance
                            .collection("categories")
                            .doc(widget.categoryId)
                            .update({
                          'imageUrl': imageUrl,
                        });
                        setState(() {});
                      });
                    } else {
                      print('No Image Selcted');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.attach_file,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Choose Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: RawMaterialButton(
                  fillColor: const Color(0xFF7E0000),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  autofocus: true,
                  onPressed: () async {
                    try {
                      var fierbase = FirebaseFirestore.instance
                          .collection('products')
                          .get();
                      // Edit catogry name in product collection
                      fierbase.then((docSnapshot) {
                        docSnapshot.docs.firstWhere((element) {
                          print(element.id);
                          FirebaseFirestore.instance
                              .collection('products')
                              .doc(element.id)
                              .update({'categories': txtcateg});
                          return true;
                        });
                      });
                      // Edit category name in categories collection
                      await FirebaseFirestore.instance
                          .collection("categories")
                          .doc(widget.categoryId)
                          .update({
                        'name': txtcateg,
                      });
                    } catch (x) {
                      print(x.toString());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'An Error occurred please try again',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: const Text(
                    'Update',
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
    );
  }
}
