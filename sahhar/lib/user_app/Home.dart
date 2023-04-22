import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sahhar/user_app/products.dart';
import 'package:sahhar/auth_screens/LoginPage.dart';

import 'confirmation.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

class HomePage extends StatefulWidget {
  const HomePage({Key? key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCart = false;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: prefer_final_fields
  static List<Widget> _widgetOptions = <Widget>[
    //Categories Page
    Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 226, 226),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const TextField(
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                label: Text('Search...'),
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("categories").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xFF7E0000),
                ));
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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeProducts(
                              categoryName: doc['name'],
                              categoryId: doc.id,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                width: MediaQuery.of(context).size.width * 0.42,
                                color: Colors.black,
                                child: Image.network(
                                  doc['imageUrl'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Center(
                                  child: Text(
                                    doc['name'],
                                    style: const TextStyle(
                                      color: Color(0xFF7E0000),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    //Likes Page
    Container(
      padding: const EdgeInsets.all(8),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('likes')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7E0000),
              ),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No likes yet.'),
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
                      Image.network(
                        productDetails['imageUrl'],
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.42,
                        fit: BoxFit.fill,
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
                      IconButton(
                        onPressed: () {
                          // Add to cart function
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                      ),
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
    //Cart Page
    Container(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .collection('cart')
            .get(),
        builder: (context, snapshot) {
          print('data = ${snapshot.data?.docs.length}');

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7E0000),
              ),
            );
          } else if ((snapshot.data!.docs.isEmpty ||
                  snapshot.data?.docs.length == null) &&
              snapshot.connectionState == ConnectionState.done) {
            return const Center(
              child: Text('Cart empty.'),
            );
          } else {
            return Column(
              children: [
                Expanded(
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
                            Image.network(
                              productDetails['imageUrl'],
                              width: MediaQuery.of(context).size.width * 0.32,
                              height: MediaQuery.of(context).size.height * 0.02,
                              fit: BoxFit.fill,
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
                            IconButton(
                              onPressed: () {
                                // Add to cart function
                              },
                              icon: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
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
                  ),
                ),
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
    ),

    //Profile Page
    Column(
      children: [
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xFF7E0000),
                ));
              }
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.30,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                              color: Color(0xFF7E0000),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 35),
                                  child: const Text(
                                    'Account Details',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )),
                      Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.15,
                            left: 12,
                            right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 10,
                              backgroundColor: Colors.grey,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 55,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color(0xFF7E0000),
                                  size: 28,
                                ),
                                Text(
                                  '${userData['Firstname']} ${userData['Lastname']}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7E0000),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${userData['email']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              height: 55,
                              width: MediaQuery.of(context).size.width - 16,
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: const Color(0xFF7E0000)
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(9)),
                                fillColor: Colors.white,
                                elevation: 0,
                                highlightColor:
                                    const Color(0xFF7E0000).withOpacity(0.7),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        title: const Text(
                                            "We are here for helping",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold)),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              10,
                                          child: const Text(
                                              "If you have any proplem you can connect with us in WhatsApp in\n+972526789152"),
                                        ),
                                        actions: <Widget>[
                                          InkWell(
                                            child: const Text("OK  ",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  'Help',
                                  style: TextStyle(
                                    color: Color(0xFF7E0000),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width - 16,
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: const Color(0xFF7E0000)
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(9)),
                                fillColor: Colors.white,
                                elevation: 0,
                                highlightColor:
                                    const Color(0xFF7E0000).withOpacity(0.7),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        title: const Text(
                                            "Sahhar Laser Cut Shop",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold)),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              10,
                                          child: const Text(
                                              "Home decor . Arts & Crafts store . Designs . Laser engraving and cutting on wood"),
                                        ),
                                        actions: <Widget>[
                                          InkWell(
                                            child: const Text("OK  ",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  'About',
                                  style: TextStyle(
                                    color: Color(0xFF7E0000),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              height: 55,
                              width: MediaQuery.of(context).size.width - 16,
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: const Color(0xFF7E0000)
                                            .withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(9)),
                                fillColor: Colors.white,
                                elevation: 0,
                                highlightColor:
                                    const Color(0xFF7E0000).withOpacity(0.7),
                                onPressed: () async {
                                  // Log out the current user
                                  await FirebaseAuth.instance.signOut();

                                  // Navigate back to the login screen
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  'LogOut',
                                  style: TextStyle(
                                    color: Color(0xFF7E0000),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3
          ? AppBar(
              title: Text(
                _selectedIndex == 0
                    ? 'Categories'
                    : _selectedIndex == 1
                        ? 'Likes'
                        : _selectedIndex == 2
                            ? 'MyCart'
                            : 'Account Details',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              toolbarHeight: 100,
            )
          : null,
      body:
          // _selectedIndex == 0
          // ?
          Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: _widgetOptions.elementAt(_selectedIndex)),
      // : Container(
      //     height: MediaQuery.of(context).size.height,
      //     color: Colors.amber,
      //     width: MediaQuery.of(context).size.width,
      //     child: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'likes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF7E0000),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

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

/*void openWhatsApp() async {
  String phoneNumber = '+972526789152'; // replace with your phone number
  String message = 'Hello!'; // replace with your message
  String url = 'https://wa.me/$phoneNumber/?text=${Uri.parse(message)}';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}*/
