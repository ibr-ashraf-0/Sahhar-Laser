import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  bool isFavorite = false;
  bool isCart = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void toggleCart() {
    setState(() {
      isCart = !isCart;
    });
  }

  int _selectedIndex = 0;
  late String categoryId;

  @override
  void initState() {
    super.initState();
    categoryId = widget.categoryId;
  }

  // Moved StreamBuilder to Separate Method
  Widget buildProductGrid() {
    if (categoryId == null || categoryId.isEmpty) {
      return Center(
        child: Text("Invalid category ID."),
      );
    }

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("categories")
            .doc(categoryId != null ? categoryId : '')
            .collection("items")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 230,
              childAspectRatio: 1,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: snapshot.data!.docs.length,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          imageUrl: doc['imageUrl'],
                          name: doc['name'],
                          price: doc['price'],
                          colorUrl: doc['colorUrl'],
                          size: doc['size'],
                          description: doc['description'],
                          withText: doc['switchValue'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
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
                          height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 0.40,
                          color: Colors.black,
                          child: Image.network(
                            doc['imageUrl'],
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 2),
                            child: Text(
                              doc['description'],
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 4),
                                child: Text(
                                  '${doc['price']}₪',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 30,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 3),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: const Color(0xFF7E0000),
                                    ),
                                    onTap: () {
                                      toggleFavorite();
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      isCart
                                          ? Icons.shopping_cart
                                          : Icons.shopping_cart_outlined,
                                      color: const Color(0xFF7E0000),
                                    ),
                                    onTap: () {
                                      toggleCart();
                                    },
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
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
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          //SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 226, 226, 226),
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
          buildProductGrid(), // Call the method here
        ],
      ),
    );
  }
}
