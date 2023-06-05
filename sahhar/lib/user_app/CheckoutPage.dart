import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sahhar/user_app/confirm.dart';
// import 'package:sahhar/user_app/confirm.dart';

class Checkout extends StatefulWidget {
  @override
  CheckoutState createState() => CheckoutState();
}

int totalPrice = 0;
int allTotalPrice = 0;
int orderCount = 0;

class CheckoutState extends State<Checkout> {
  bool payNow = false;
  bool payOnDelivery = true;

  final user = FirebaseAuth.instance.currentUser;

  Future<void> placeOrder() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actionsPadding: const EdgeInsets.symmetric(vertical: 16),
          title: const Text("Let's reviwe your orders for last time",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF7E0000),
                  fontWeight: FontWeight.bold)),
          content: BuildAlratContent(),
          actions: <Widget>[
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1.5,
                    color: Color(0xFF7E0000),
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Text("Go Back",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.bold)),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1.5,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: const Text("Confirem",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != true) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (ctx) => Confirm()));
      }
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
                                            fit: BoxFit.cover,
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
                                int priceStr = doc['price'];
                                int price = priceStr;
                                totalPrice += price;
                                allTotalPrice += price;
                              }
                            }
                            if (orderCount == 0) {
                              orderCount = snapshot.data!.docs.length;
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

class BuildAlratContent extends StatefulWidget {
  const BuildAlratContent({super.key});

  @override
  State<BuildAlratContent> createState() => _BuildAlratContentState();
}

class _BuildAlratContentState extends State<BuildAlratContent> {
  final user = FirebaseAuth.instance.currentUser;
  String nameInProduct = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 0.65,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('cart')
            .get(),
        builder: (ctx, snapshot) {
          return (snapshot.connectionState == ConnectionState.done &&
                  (snapshot.data?.docs.length == 0 ||
                      snapshot.data?.docs.length == 'null'))
              ? Container(
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                      child: Text(
                    'Now you can press Confirem',
                    style: TextStyle(color: Colors.green, fontSize: 24),
                  )),
                )
              : ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (ctx, index) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (totalPrice == 0) {
                        for (var doc in snapshot.data!.docs) {
                          int priceStr = doc['price'];
                          int price = priceStr;
                          totalPrice += price;
                        }
                      }
                      if (orderCount == 0) {
                        orderCount = snapshot.data!.docs.length;
                      }
                      print('total = $totalPrice');
                      print('total = $orderCount');

                      return Container(
                        width: 100,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.symmetric(vertical: 2),
                        color: const Color(0xFF7E0000).withOpacity(0.1),
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
                                      '${snapshot.data?.docs[index].data()['name']}',
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
                                    '${snapshot.data?.docs[index].data()['price']} ₪',
                                    style: const TextStyle(
                                        color: Color(0xFF7E0000),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                                    'Quantity : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 160,
                                    child: Text(
                                      '${snapshot.data?.docs[index].data()['quantity']}',
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
                                    '${snapshot.data?.docs[index].data()['size']}',
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
                                    '${snapshot.data?.docs[index].data()['colorName']}',
                                    style: const TextStyle(
                                        color: Color(0xFF7E0000),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            snapshot.data?.docs[index].data()['switchValue'] ==
                                    true
                                ? Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
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
                            snapshot.data?.docs[index].data()['switchValue'] ==
                                    true
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 1.5,
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF7E0000),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(height: 0, width: 0),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    int priceStr =
                                        snapshot.data?.docs[index]['price'];

                                    setState(() {
                                      totalPrice = totalPrice - priceStr;
                                      orderCount -= 1;
                                      allTotalPrice = allTotalPrice - priceStr;
                                      snapshot.data?.docs[index].reference
                                          .delete();
                                    });
                                  },
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
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
                                  onPressed: () async {
                                    DocumentSnapshot<Map<String, dynamic>>
                                        userInfo = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(user!.uid)
                                            .get();
                                    DateTime date = DateTime.now();
                                    String dateFormat =
                                        DateFormat('dd-MM-yyyy hh:mm')
                                            .format(date);
                                    await FirebaseFirestore.instance
                                        .collection('orderStates')
                                        .doc(user!.uid)
                                        .set({
                                      'email': user!.email,
                                      'number': userInfo.data()?['phoneNumber'],
                                      'userName':
                                          userInfo.data()?['Firstname'] +
                                              ' ' +
                                              userInfo.data()?['Lastname'],
                                      'totalprice': allTotalPrice,
                                      'orderDate': dateFormat,
                                      'packageStutes': 'Ordered',
                                      'countOfOrders': orderCount,
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('order')
                                        .doc(user!.uid)
                                        .collection('items')
                                        .add({
                                      'nameInProduct': nameInProduct,
                                      'productName': snapshot.data?.docs[index]
                                          .data()['name'],
                                      'color': snapshot.data?.docs[index]
                                          .data()['colorurl'],
                                      'quantity': snapshot.data?.docs[index]
                                          .data()['quantity'],
                                      'colorName': snapshot.data?.docs[index]
                                          .data()['colorName'],
                                      'colorType': snapshot.data?.docs[index]
                                          .data()['colorType'],
                                      'price': snapshot.data?.docs[index]
                                          .data()['price'],
                                      'size': snapshot.data?.docs[index]
                                          .data()['size'],
                                    });
                                    int priceStr =
                                        snapshot.data?.docs[index]['price'];
                                    setState(() {
                                      totalPrice = totalPrice - priceStr;
                                      snapshot.data?.docs[index].reference
                                          .delete();
                                    });
                                  },
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1.5,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Text("Add",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),

                            // Divider(
                            //   thickness: 2.5,
                            //   color: Colors.green,
                            // )
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        color: Colors.white,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: const Color(0xFF7E0000),
                        )),
                      );
                    }
                  },
                );
        },
      ),
    );
  }
}
