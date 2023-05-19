import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'confirm.dart';

class Checkout extends StatefulWidget {
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  bool payNow = false;
  bool payOnDelivery = true;
  String nameInProduct = '';

  int totalPrice = 0;
  int orderCont = 0;
  final user = FirebaseAuth.instance.currentUser;
  Future<void> placeOrder() async {
    QuerySnapshot<Map<String, dynamic>> orderInfo = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user?.uid)
        .collection('cart')
        .get();
    DocumentSnapshot<Map<String, dynamic>> userInfo = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (orderCont == 0) {
      setState(() {
        orderCont = orderInfo.docs.length;
      });
    }
    orderInfo.docs.forEach((element) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: const Text("Let's reviwe your orders for last time",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF7E0000),
                    fontWeight: FontWeight.bold)),
            content: Container(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          border: const Border.fromBorderSide(
                              BorderSide(width: 1.5)),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          const Text(
                            'product name : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: 160,
                            child: Text(
                              '${element.data()['name']}',
                              style: const TextStyle(
                                  color: Color(0xFF7E0000),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          border: const Border.fromBorderSide(
                              BorderSide(width: 1.5)),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          const Text(
                            'product price : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${element.data()['price']} ₪',
                            style: const TextStyle(
                                color: Color(0xFF7E0000),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          border: const Border.fromBorderSide(
                              BorderSide(width: 1.5)),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          const Text(
                            'Size : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${element.data()['size']}',
                            style: const TextStyle(
                                color: Color(0xFF7E0000),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          border: const Border.fromBorderSide(
                              BorderSide(width: 1.5)),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          const Text(
                            'Product Color : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${element.data()['colorName']}',
                            style: const TextStyle(
                                color: Color(0xFF7E0000),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    element.data()['switchValue'] == true
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                              'You Can write a name here to put it in your product',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    element.data()['switchValue'] == true
                        ? Container(
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: TextFormField(
                              onChanged: (value) {
                                nameInProduct = value;
                              },
                              cursorColor: const Color(0xFF7E0000),
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  color: Color(0xFF7E0000),
                                ),
                                labelText: "Name in product",
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1.5,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF7E0000),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(height: 0, width: 0),
                  ],
                )),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actionsPadding: const EdgeInsets.symmetric(vertical: 16),
            actions: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1.5,
                      color: Color(0xFF7E0000),
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: Text("Cancle",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.bold)),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1.5,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: const Text("OK",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.green,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ).then((value) async {
        if (value == true) {
          DateTime date = DateTime.now();
          String dateFormat = DateFormat('dd-MM-yyyy hh:mm').format(date);
          await FirebaseFirestore.instance
              .collection('orderStates')
              .doc(user!.uid)
              .set({
            'email': user!.email,
            'number': userInfo.data()?['phoneNumber'],
            'userName': userInfo.data()?['Firstname'] +
                ' ' +
                userInfo.data()?['Lastname'],
            'totalprice': totalPrice,
            'orderDate': dateFormat,
            'packageStutes': 'Ordered',
            'countOfOrders': orderCont,
          });
          await FirebaseFirestore.instance
              .collection('order')
              .doc(user!.uid)
              .collection('items')
              .add({
            'nameInProduct': nameInProduct,
            'productName': element.data()['name'],
            'color': element.data()['colorurl'],
            'colorName': element.data()['colorName'],
            'colorType': element.data()['colorType'],
            'price': element.data()['price'],
            'size': element.data()['size'],
          });

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .collection('cart')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot doc in snapshot.docs) {
              if ((doc['name'] == element.data()['name']) && value) {
                doc.reference.delete();
              } else {
                print('not the product alrit');
              }
            }
          });
        } else {
          print('value from else $value');
        }
      });
    });
  }

  void deleteCartProduct(String productId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('cart')
        .doc(productId)
        .delete()
        .then((value) => print('Product deleted'))
        .catchError((error) => print('Error deleting product: $error'));
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.88,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('cart')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return RefreshIndicator(
                    color: const Color(0xFF7E0000),
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 3))
                          .whenComplete(() => setState(
                                () {},
                              ));
                    },
                    child: Container(
                      color: Colors.grey.shade300,
                      height: MediaQuery.of(context).size.height * 0.70,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        children: snapshot.data!.docs.map((document) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.14,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFF7E0000).withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            document['imageUrl'][0],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.38,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.125,
                                            fit: BoxFit.fill,
                                          ))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        child: Text(
                                          document['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        child: Text(
                                          '${document['description']}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${document['price']} ₪',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      color: Colors.white,
                                      alignment: Alignment.topRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      icon: const Icon(Icons.cancel_outlined),
                                      onPressed: () {
                                        deleteCartProduct(document.id);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                color: Color(0xFF7E0000),
                thickness: 2,
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 63,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total :',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const Divider(
                          color: Color(0xFF7E0000),
                          thickness: 2,
                          height: 5,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .collection('cart')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Text(
                                '0 ₪',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              );
                            }
                            if (totalPrice == 0) {
                              for (var doc in snapshot.data!.docs) {
                                var priceStr = doc['price'] as String;
                                var price = int.tryParse(
                                        priceStr.replaceAll('₪', '').trim()) ??
                                    0;
                                totalPrice += price;
                              }
                            }

                            return Text(
                              '$totalPrice ₪  ',
                              style: const TextStyle(
                                color: Color(0xFF7E0000),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: payOnDelivery,
                        activeColor: const Color(0xFF7E0000),
                        onChanged: (value) {
                          setState(() {
                            payOnDelivery = value ?? false;
                            payNow = false;
                          });
                        },
                      ),
                      const Text(
                        'Pay on delivery',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width - 16,
                height: 45,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: RawMaterialButton(
                  onPressed: () {
                    placeOrder();
                  },
                  fillColor: const Color(0xFF7E0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
