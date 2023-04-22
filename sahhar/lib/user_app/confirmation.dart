import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahhar/user_app/confirm.dart';

class Checkout extends StatefulWidget {
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  bool payNow = false;
  bool payOnDelivery = false;

  Future<void> placeOrder() async {
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
                                            document['imageUrl'],
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
                                      onPressed: () {},
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
              // const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        activeColor: const Color(0xFF7E0000),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => confirm()),
                    );
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
