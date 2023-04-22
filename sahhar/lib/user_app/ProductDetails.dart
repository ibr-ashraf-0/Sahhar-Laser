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

  ProductDetails({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.colorUrl,
    required this.size,
    required this.description,
  });

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  bool isFavorite = false;
  bool isCart = false;
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
  String _currentColor = 'Gold';
  List imagesPathList = [
    'assets/facebook.png',
    'assets/logo.png',
    'assets/google.png',
  ];
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
          "ProductDetails",
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
                height: 15,
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
              // const SizedBox(height: 15),
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
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Your Order Color is: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _currentColor,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Color(0xFF7E0000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.15,
                        initialPage: 0,
                        autoPlay: false,
                        onPageChanged: (index, _) {
                          print(index);
                          print(_currentColor);
                          if (index == 0) {
                            setState(() {
                              _currentColor = 'Gold';
                            });
                          } else if (index == 1) {
                            setState(() {
                              _currentColor = 'Black';
                            });
                          } else {
                            setState(() {
                              _currentColor = 'Red';
                            });
                          }
                        },
                        scrollDirection: Axis.horizontal,
                        pauseAutoPlayOnTouch: true,
                        enableInfiniteScroll: true,
                        enlargeCenterPage: true,
                      ),
                      items: imagesPathList.map((imageUrl) {
                        return SizedBox(
                          width: 180,
                          child: Image.asset(imageUrl, fit: BoxFit.fill),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(
                height: 15,
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
