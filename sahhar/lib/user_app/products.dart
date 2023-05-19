import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahhar/user_app/CartPage.dart';
import 'package:sahhar/user_app/ProductDetails.dart';

class HomeProducts extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  HomeProducts({
    required this.categoryName,
    required this.categoryId,
  });

  @override
  HomeProductsState createState() => HomeProductsState();
}

class HomeProductsState extends State<HomeProducts> {
  late String categoryId;
  @override
  void initState() {
    super.initState();
    categoryId = widget.categoryId;
  }

  // add product to cart from products
  /*
  List<bool> isCart = [];
isCart = List.filled(index + 1, false);
   GestureDetector(
                                          child: Icon(
                                            isCart[index]
                                                ? Icons.shopping_cart
                                                : Icons.shopping_cart_outlined,
                                            color: const Color(0xFF7E0000),
                                          ),
                                          onTap: () async {
                                            final user = FirebaseAuth
                                                .instance.currentUser;

                                            final Map<String, dynamic>
                                                productDetails = {
                                              'name': doc['name'],
                                              'price': doc['price'],
                                              'size': doc['size'],
                                              'imageUrl': doc['imageUrl'],
                                              'colorName': '',
                                              'colorurl': '',
                                              'colorType': '',
                                              'description': doc['description'],
                                              'switchValue': doc['switchValue'],
                                            };

                                            if (!isCart[index]) {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user?.uid)
                                                  .collection('cart')
                                                  .doc(doc.id)
                                                  .set(productDetails);

                                              isCart[index] = true;

                                              print('cart from add = $isCart');
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user?.uid)
                                                  .collection('cart')
                                                  .doc(doc.id)
                                                  .delete();
                                              isCart[index] = false;

                                              print(
                                                  'cart from remove = $isCart');
                                            }
                                          },
                                        ),
                                       
  */

  @override
  Widget build(BuildContext context) {
    if (categoryId.isEmpty) {
      return const Center(
        child: Text("Invalid category ID."),
      );
    }
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 226, 226),
                borderRadius: BorderRadius.circular(30),
              ),
              /*child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.black,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search..',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),*/
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("categories")
                  .doc(categoryId != null ? categoryId : '')
                  .collection("items")
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done &&
                    snapshot.data?.docs.length != 0) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF7E0000),
                  ));
                } else if (snapshot.data?.docs.length == 0) {
                  return const Center(
                    child: Text(
                      'There is not product\nin this Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w300),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        MediaQuery.of(context).size.height * 0.43,
                    mainAxisExtent: MediaQuery.of(context).size.width * 0.70,
                    childAspectRatio: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductDetails(
                                  categoryId: categoryId,
                                  productId: snapshot.data!.docs[index].id,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 2),
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 1),
                              Container(
                                padding: EdgeInsets.zero,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 2),
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    snapshot.data!.docs[index]['imageUrl'][0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 30,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 2),
                                  child: Text(
                                    snapshot.data!.docs[index]['description'],
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 4),
                                      child: Text(
                                        snapshot.data!.docs[index]['price']
                                                .isEmpty
                                            ? '0₪'
                                            : '${snapshot.data!.docs[index]['price'][0]}₪',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
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
                                              snapshot.data!
                                                          .data()?['isCart'] ==
                                                      true
                                                  ? Icons.shopping_cart
                                                  : Icons
                                                      .shopping_cart_outlined,
                                              color: const Color(0xFF7E0000),
                                            ),
                                            onTap: () async {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                        'you cant add product to cart from here plese go to product details to add it',
                                                        textAlign:
                                                            TextAlign.center,
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
                                  FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .collection('likes')
                                        .doc(snapshot.data!.docs[index].id)
                                        .get(),
                                    builder: (ctx, snapshote) {
                                      if (snapshote.connectionState ==
                                          ConnectionState.done) {
                                        return Container(
                                          height: 30,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 3),
                                          child: InkWell(
                                              child: snapshote.data!
                                                          .data()?['isLike'] ==
                                                      true
                                                  ? const Icon(
                                                      Icons.favorite,
                                                      color: Color(0xFF7E0000),
                                                    )
                                                  : const Icon(
                                                      Icons.favorite_border,
                                                      color: Color(0xFF7E0000),
                                                    ),
                                              onTap: () async {
                                                final user = FirebaseAuth
                                                    .instance.currentUser;
                                                Map<String, dynamic> data = {
                                                  'isLike': true,
                                                  'baseCategory': snapshot
                                                      .data!.docs[index]
                                                      .data()['baseCategory'],
                                                  'description': snapshot
                                                      .data!.docs[index]
                                                      .data()['description'],
                                                  'imageUrl': snapshot
                                                      .data!.docs[index]
                                                      .data()['imageUrl'],
                                                  'name': snapshot
                                                      .data!.docs[index]
                                                      .data()['name'],
                                                  'price': snapshot
                                                      .data!.docs[index]
                                                      .data()['price'],
                                                  'size': snapshot
                                                      .data!.docs[index]
                                                      .data()['size'],
                                                  'switchValue': snapshot
                                                      .data!.docs[index]
                                                      .data()['switchValue'],
                                                };
                                                if (snapshote.data!
                                                        .data()?['isLike'] ==
                                                    true) {
                                                  // Save the product information to the "likes" collection in Firebase
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(user!.uid)
                                                      .collection('likes')
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .delete()
                                                      .then((value) =>
                                                          setState(() {}));
                                                } else {
                                                  // delete the product information fro the "likes" collection in Firebase
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(user!.uid)
                                                      .collection('likes')
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .set(data)
                                                      .then((value) =>
                                                          setState(() {}));
                                                }
                                              }),
                                        );
                                      } else {
                                        return Container(
                                          height: 30,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 3),
                                          child: const Icon(
                                            Icons.favorite_border,
                                            color: Color(0xFF7E0000),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
