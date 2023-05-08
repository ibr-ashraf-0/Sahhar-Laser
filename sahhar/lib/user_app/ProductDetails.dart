import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String price;
  final String colorUrl;
  final String size;
  final bool withText;

  ProductDetails({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.colorUrl,
    required this.size,
    required this.description,
    required this.withText,
  });

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  bool isFavorite = false;
  bool isCart = false;

  String nameInProduct = '';
  String currentSizeIndex = '25 C';
  List<String> itemSize = [
    '5 C',
    '10 C',
    '15 C',
    '20 C',
    '25 C',
    '30 C',
    '35 C',
    '40 C',
  ];
  String _currentColor = 'orange';
  List<Color> colors = [
    Colors.black,
    Colors.orange,
    Colors.red,
    Colors.blueGrey,
  ];
  List<String> colorsName = ['black', 'orange', 'red', 'blueGrey'];
  List<Color> woodsColor = [
    const Color.fromARGB(255, 131, 100, 6),
    const Color.fromARGB(177, 46, 45, 45),
    const Color.fromARGB(255, 170, 167, 167),
    const Color.fromRGBO(190, 151, 91, 1),
  ];
  List<String> woodsColorsName = [
    'Gold',
    'Brazilian rosewood',
    'Maple',
    'Birch'
  ];
  bool isColorTypeReguler = true;
  bool isColorTypeWoods = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: const Text(
          "product Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Image.network(
                  widget.imageUrl,
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width - 16,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Text(
                      'product Name: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7E0000),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text(
                  'Description: ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFF7E0000).withOpacity(0.1),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Price:',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${widget.price}₪',
                          style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF7E0000),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red.shade200),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)))),
                      label: Text(
                        isFavorite ? 'Un favorite' : 'Make Favorite',
                        style: const TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFF7E0000),
                      ),
                      onPressed: () async {
                        setState(() {
                          isFavorite = !isFavorite;
                        });

                        final user = FirebaseAuth.instance.currentUser;
                        final productId = widget.name;
                        final productDetails = {
                          'name': widget.name,
                          'price': widget.price,
                          'imageUrl': widget.imageUrl,
                          'colorUrl': widget.colorUrl,
                          'size': widget.size,
                          'description': widget.description,
                        };
                        if (user != null) {
                          if (isFavorite != true) {
                            // delete the product information fro the "likes" collection in Firebase
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('likes')
                                .doc(productId)
                                .delete();
                          } else {
                            // Save the product information to the "likes" collection in Firebase
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('likes')
                                .doc(productId)
                                .set(productDetails);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Your Order Color is: ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 20,
                              width: 85,
                              child: Text(
                                _currentColor,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Color(0xFF7E0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 20,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  const Text(
                                    'reguler Colors',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Checkbox(
                                    activeColor: const Color(0xFF7E0000),
                                    value: isColorTypeReguler,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val!) {
                                          isColorTypeReguler = val;
                                          isColorTypeWoods = false;
                                        } else {
                                          isColorTypeReguler = true;
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Container(
                              height: 20,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  const Text(
                                    'woods Colors',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Checkbox(
                                    activeColor: const Color(0xFF7E0000),
                                    value: isColorTypeWoods,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val!) {
                                          isColorTypeWoods = val;
                                          isColorTypeReguler = false;
                                        } else {
                                          isColorTypeWoods = true;
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            height: 50,
                            margin: const EdgeInsets.only(
                                top: 5, right: 2, left: 2, bottom: 0),
                            decoration: BoxDecoration(
                              color: isColorTypeReguler
                                  ? colors[index]
                                  : isColorTypeWoods
                                      ? woodsColor[index]
                                      : Colors.black,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isColorTypeReguler) {
                                    _currentColor = colorsName[index];
                                  } else {
                                    _currentColor = woodsColorsName[index];
                                  }
                                });
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: ListTile(
                                  title: Text(
                                    isColorTypeReguler
                                        ? colorsName[index]
                                        : isColorTypeWoods
                                            ? woodsColorsName[index]
                                            : 'No Colors',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing:
                                      _currentColor == colorsName[index] ||
                                              _currentColor ==
                                                  woodsColorsName[index]
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : const SizedBox(
                                              height: 2,
                                              width: 2,
                                            ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: isColorTypeReguler && !isColorTypeWoods
                            ? colorsName.length
                            : isColorTypeWoods && !isColorTypeReguler
                                ? woodsColorsName.length
                                : 7,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Your Order Size is: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          currentSizeIndex,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Color(0xFF7E0000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: itemSize.map((value) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentSizeIndex = value;
                              });
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: value == currentSizeIndex
                                  ? const Color(0xFF7E0000)
                                  : Colors.black12,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: value == currentSizeIndex
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: widget.withText ? 10 : 0,
              ),
              widget.withText
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: const Text(
                        'Write the name you whold like to be in proguct',
                        style: TextStyle(
                            color: Color(0xFF7E0000),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox(height: 0, width: 0),
              SizedBox(
                height: widget.withText ? 5 : 0,
              ),
              widget.withText
                  ? Container(
                      height: 35,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        cursorColor: const Color(0xFF7E0000),
                        decoration: InputDecoration(
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
                          labelStyle: const TextStyle(
                              color: Color(0xFF7E0000), fontSize: 15),
                          labelText: "Name in product",
                        ),
                        onChanged: (value) {
                          nameInProduct = value;
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width - 16,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade200),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                    label: Text(
                      isCart ? 'Cancel Order' : 'Order Now',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    icon: Icon(
                      isCart
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                      color: const Color(0xFF7E0000),
                    ),
                    onPressed: () async {
                      setState(() {
                        isCart = !isCart;
                      });
                      final user = FirebaseAuth.instance.currentUser;
                      final productId = widget.name;
                      final productDetails = {
                        'name': widget.name,
                        'price': widget.price,
                        'imageUrl': widget.imageUrl,
                        'colorUrl': _currentColor,
                        'size': currentSizeIndex,
                        'description': widget.description,
                        'nameInProduct': nameInProduct,
                      };
                      if (user != null) {
                        if (isCart != true) {
                          // delete the product information from the "likes" collection in Firebase
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cart')
                              .doc(productId)
                              .delete();
                        } else {
                          // Save the product information to the "likes" collection in Firebase
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('cart')
                              .doc(productId)
                              .set(productDetails);
                        }
                      }
                    },
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
