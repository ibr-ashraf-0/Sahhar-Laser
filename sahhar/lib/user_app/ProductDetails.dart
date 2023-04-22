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
  String hitDwnButton = '55';
  String dWNButtonTexts1 = '37';
  String dWNButtonTexts2 = '36';

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
                          '${widget.price} ₪',
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
                        if (user != null) {
                          final productId = widget.name;
                          final productDetails = {
                            'name': widget.name,
                            'price': widget.price,
                            'imageUrl': widget.imageUrl,
                            'colorUrl': widget.colorUrl,
                            'size': widget.size,
                            'description': widget.description,
                          };

                          // Save the product information to the "likes" collection in Firebase
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('likes')
                              .doc(productId)
                              .set(productDetails);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Available Colors:",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          // color: Colors.amber,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width:
                                    MediaQuery.of(context).size.height * 0.14,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: Image.network(
                                  widget.colorUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // const Divider(
                              //   color: Colors.red,
                              //   thickness: 7,
                              // ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width:
                                    MediaQuery.of(context).size.height * 0.14,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: Image.network(
                                  widget.colorUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width:
                                    MediaQuery.of(context).size.height * 0.14,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: Image.network(
                                  widget.colorUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
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
                    label: const Text(
                      'Order Now',
                      style: TextStyle(color: Colors.white, fontSize: 22),
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
                      if (user != null) {
                        final productId = widget.name;
                        final productDetails = {
                          'name': widget.name,
                          'price': widget.price,
                          'imageUrl': widget.imageUrl,
                          'colorUrl': widget.colorUrl,
                          'size': widget.size,
                          'description': widget.description,
                        };

                        // Save the product information to the "likes" collection in Firebase
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('cart')
                            .doc(productId)
                            .set(productDetails);
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


/*
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Size:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                  top: BorderSide(
                                      color: Colors.black, width: 0.5),
                                  left: BorderSide(
                                      color: Colors.black, width: 0.5),
                                  right: BorderSide(
                                      color: Colors.black, width: 0.5),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              width: 45,
                              height: 45,
                              child: DropdownButton(
                                  hint: Text(
                                    hitDwnButton,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                  itemHeight: 48,
                                  isExpanded: true,
                                  autofocus: true,
                                  elevation: 0,
                                  dropdownColor: Colors.white,
                                  focusColor: Colors.white,
                                  underline: Container(),
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.black),
                                  items: [
                                    DropdownMenuItem(
                                      child: Column(
                                        children: [
                                          Text(
                                            dWNButtonTexts1,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      value: 0,
                                    ),
                                    DropdownMenuItem(
                                      child: Column(
                                        children: [
                                          Text(
                                            dWNButtonTexts2,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      value: 1,
                                    ),
                                  ],
                                  onChanged: (itemIdentifier) {
                                    setState(() {
                                      if (itemIdentifier == 0) {
                                        hitDwnButton = dWNButtonTexts1;
                                      } else {
                                        hitDwnButton = dWNButtonTexts2;
                                      }
                                    });
                                  }),
                            ),
                            //   Container(
                            //     margin: const EdgeInsets.all(5),
                            //     child: SizedBox(
                            //       width: 70,
                            //       height: 25,
                            //       child: ElevatedButton(
                            //         style: ButtonStyle(
                            //           backgroundColor:
                            //               MaterialStateProperty.all(Colors.white),
                            //           shape: MaterialStateProperty.all(
                            //             RoundedRectangleBorder(
                            //               side: const BorderSide(color: Colors.black),
                            //               borderRadius: BorderRadius.circular(10),
                            //             ),
                            //           ),
                            //         ),
                            //         onPressed: () {
                            //           // Select the product size
                            //         },
                            //         child: Text(
                            //           widget.size,
                            //           style: const TextStyle(
                            //             fontSize: 20,
                            //             color: Colors.black,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        )
                      ],
                    )
                 

*/