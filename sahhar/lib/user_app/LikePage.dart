import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

User? user = _auth.currentUser;
void deleteProduct(String productId) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('likes')
      .doc(productId)
      .delete()
      .then((value) => print('Product deleted'))
      .catchError((error) => print('Error deleting product: $error'));
}

void deleteProduct2(String productId) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('cart')
      .doc(productId)
      .delete()
      .then((value) => print('Product deleted'))
      .catchError((error) => print('Error deleting product: $error'));
}

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF7E0000),
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 3))
            .whenComplete(() => setState(
                  () {},
                ));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .collection('likes')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7E0000),
                ),
              );
            } else if (snapshot.data!.docs.length == 0 &&
                snapshot.connectionState != ConnectionState.waiting) {
              return const Center(
                child: Text(
                  'No likes yet.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w300),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot productDetails = snapshot.data!.docs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            productDetails['imageUrl'][0],
                            height: MediaQuery.of(context).size.height * 0.11,
                            width: MediaQuery.of(context).size.width * 0.42,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                '${productDetails['price'][0]} ₪',
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
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return GestureDetector(
                                  child: Icon(
                                    snapshot.data!.data()?['isCart'] == true
                                        ? Icons.shopping_cart
                                        : Icons.shopping_cart_outlined,
                                    color: const Color(0xFF7E0000),
                                  ),
                                  onTap: () async {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              'you cant add product to cart from here plese go to product details to add it',
                                              textAlign: TextAlign.center,
                                            )));
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
                            deleteProduct(productDetails.id);
                            deleteProduct2(productDetails.id);
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
              );
            }
          },
        ),
      ),
    );
  }
}
