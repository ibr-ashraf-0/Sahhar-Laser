import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sahhar/user_app/Home.dart';
import 'package:sahhar/user_app/confirm.dart';

class Checkout extends StatefulWidget {
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  bool payNow = false;
  bool payOnDelivery = false;

  Future<void> PlaceOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    final cartDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('cart')
        .get();

    final orderData = {
      'status': 'Pending',
      'paymentMethod': payOnDelivery ? 'Pay On Delivery' : 'Pay Now',
      'products': cartDocs.docs
          .map((doc) => {'name': doc['name'], 'price': doc['price']})
          .toList(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('Place Order')
        .doc(DateTime.now().toString())
        .set(orderData);

    await FirebaseFirestore.instance.collection('orders').add(orderData);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('cart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    //Navigator.pushNamed(context, '/confirm');
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'Checkout',
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
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             const SizedBox(height: 30),
             const Text(
                'Your Order',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sahhar Laser',
                style: TextStyle(
                  color: Color(0xFF7E0000),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  return Column(
                    children: snapshot.data!.docs.map((document) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blueGrey[300]!,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              document['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${document['price']} ₪',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 216, 216, 216),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '  Total ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
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
                                  fontSize: 20,
                                ),
                              );
                            }
                            var totalPrice = 0;
                            for (var doc in snapshot.data!.docs) {
                              var priceStr = doc['price'] as String;
                              var price = int.tryParse(
                                      priceStr.replaceAll('₪', '').trim()) ??
                                  0;
                              totalPrice += price;
                            }
                            return Text(
                              '$totalPrice ₪  ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: payNow,
                        onChanged: (value) {
                          setState(() {
                            payNow = value ?? false;
                            payOnDelivery = false;
                          });
                        },
                      ),
                      const Text(
                        'Pay now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: payOnDelivery,
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
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => confirm()),
                  );
                  PlaceOrder();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Color(0xFF7E0000),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Place Order',
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
