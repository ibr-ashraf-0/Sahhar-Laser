import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CheckoutPage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

User? user = _auth.currentUser;
void deleteLikeProduct(String productId) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('likes')
      .doc(productId)
      .delete()
      .then((value) => print('Product deleted'))
      .catchError((error) => print('Error deleting product: $error'));
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

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .collection('cart')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7E0000),
              ),
            );
          } else if ((snapshot.data!.docs.isEmpty ||
                  snapshot.data?.docs.length == null) &&
              snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Text(
                  'Cart empty.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w300),
                ),
              ),
            );
          } else {
            return Column(
              children: [
                RefreshIndicator(
                  color: const Color(0xFF7E0000),
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 3))
                        .whenComplete(() => setState(
                              () {},
                            ));
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.73,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot productDetails =
                            snapshot.data!.docs[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  productDetails['imageUrl'][0],
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      productDetails['name'],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        productDetails['description'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${productDetails['price']} ₪',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7E0000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .collection('cart')
                                      .doc(snapshot.data!.docs[index].id)
                                      .get(),
                                  builder: (ctx, snapshote) {
                                    if (snapshote.connectionState ==
                                        ConnectionState.done) {
                                      return IconButton(
                                        icon: Icon(
                                          snapshote.data!.data()?['isCart'] ==
                                                  true
                                              ? Icons.shopping_cart
                                              : Icons.shopping_cart_outlined,
                                          color: const Color(0xFF7E0000),
                                        ),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user!.uid)
                                              .collection('cart')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .delete();
                                        },
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Color(0xFF7E0000),
                                      );
                                    }
                                  }),
                              IconButton(
                                onPressed: () {
                                  deleteCartProduct(productDetails.id);
                                },
                                icon: const Icon(
                                  Icons.delete_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
                const SizedBox(height: 1),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 16,
                  height: 45,
                  child: RawMaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Checkout()),
                      );
                    },
                    fillColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
