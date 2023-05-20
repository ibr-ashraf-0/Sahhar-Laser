import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CartPage.dart';

class ProductDetails extends StatefulWidget {
  final String categoryId;
  final String productId;

  const ProductDetails({
    required this.categoryId,
    required this.productId,
  });

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  bool isFavorite = false;
  bool isCart = false;

  String nameInProduct = '';
  String currentSizeIndex = '';
  String _currentColorName = '';
  String _currentColor = '';
  int count = 1;
  bool isColorTypeReguler = true;
  bool isColorTypeWoods = false;
  int indexOfpriceSize = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: const Text(
          "product Details",
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
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('categories')
                  .doc(widget.categoryId)
                  .collection('items')
                  .doc(widget.productId)
                  .get(),
              builder: (context, snapShot) {
                if (snapShot.connectionState != ConnectionState.done) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF7E0000),
                  ));
                } else if (!snapShot.data!.exists) {
                  return const Center(
                    child: Text(
                      'sometimes wrong\nplease try again later and check your internet connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w300),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        margin: const EdgeInsets.only(top: 5),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                snapShot.data!.data()!['imageUrl'].length,
                            itemBuilder: (ctx, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.only(left: 0, right: 10),
                                child: Center(
                                  child: Image.network(
                                    snapShot.data!.data()!['imageUrl'][index],
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    height: MediaQuery.of(context).size.height *
                                        0.30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'product Name: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  snapShot.data!.data()!['name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF7E0000),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Quantity :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    FloatingActionButton(
                                      heroTag: "btn1",
                                      elevation: 0,
                                      backgroundColor: Colors.grey,
                                      onPressed: () {
                                        setState(() {
                                          count -= 1;
                                        });
                                      },
                                      mini: true,
                                      child: Text(
                                        '-',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 35),
                                      ),
                                    ),
                                    Text(
                                      '$count',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                    FloatingActionButton(
                                        heroTag: "btn2",
                                        elevation: 0,
                                        backgroundColor: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            count += 1;
                                          });
                                        },
                                        mini: true,
                                        child: Icon(Icons.add)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: const Text(
                          'Description: ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xFF7E0000).withOpacity(0.1),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          snapShot.data!.data()!['description'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.blueGrey),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Price: ',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${int.tryParse(snapShot.data!.data()!['price'][indexOfpriceSize])! * count} ₪',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Color(0xFF7E0000),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid)
                                  .collection('likes')
                                  .doc(snapShot.data!.id)
                                  .get(),
                              builder: (ctx, snapshote) {
                                if (snapshote.connectionState ==
                                    ConnectionState.done) {
                                  return TextButton.icon(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red.shade200),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15)))),
                                    label: Text(
                                      snapshote.data!.data()?['isLike'] == true
                                          ? 'Un favorite'
                                          : 'Make Favorite',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    icon: snapshote.data!.data()?['isLike'] ==
                                            true
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Color(0xFF7E0000),
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            color: Color(0xFF7E0000),
                                          ),
                                    onPressed: () async {
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      Map<String, dynamic> data = {
                                        'isLike': true,
                                        'baseCategory': snapShot.data!
                                            .data()!['baseCategory'],
                                        'description': snapShot.data!
                                            .data()!['description'],
                                        'imageUrl':
                                            snapShot.data!.data()!['imageUrl'],
                                        'name': snapShot.data!.data()!['name'],
                                        'price':
                                            snapShot.data!.data()!['price'],
                                        'size': snapShot.data!.data()!['size'],
                                        'switchValue': snapShot.data!
                                            .data()!['switchValue'],
                                      };
                                      if (snapshote.data!.data()?['isLike'] ==
                                          true) {
                                        // Save the product information to the "likes" collection in Firebase
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user!.uid)
                                            .collection('likes')
                                            .doc(snapShot.data!.id)
                                            .delete()
                                            .then((value) => setState(() {}));
                                      } else {
                                        // delete the product information fro the "likes" collection in Firebase
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user!.uid)
                                            .collection('likes')
                                            .doc(snapShot.data!.id)
                                            .set(data)
                                            .then((value) => setState(() {}));
                                      }
                                    },
                                  );
                                } else {
                                  return TextButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red.shade200),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)))),
                                      label: const Text(
                                        'Make Favorite',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        color: Color(0xFF7E0000),
                                      ),
                                      onPressed: () async {});
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Your Order Color is: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 20,
                                      width: 80,
                                      child: Text(
                                        _currentColorName,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Color(0xFF7E0000),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 20,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: Row(
                                        children: [
                                          const Text(
                                            'reguler Colors',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Checkbox(
                                            activeColor:
                                                const Color(0xFF7E0000),
                                            value: isColorTypeReguler,
                                            onChanged: (val) {
                                              setState(() {
                                                if (val!) {
                                                  isColorTypeReguler = val;
                                                  isColorTypeWoods = false;
                                                } else {
                                                  isColorTypeReguler = true;
                                                }
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      height: 30,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: Row(
                                        children: [
                                          const Text(
                                            'woods Colors',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Checkbox(
                                            activeColor:
                                                const Color(0xFF7E0000),
                                            value: isColorTypeWoods,
                                            onChanged: (val) {
                                              setState(() {
                                                if (val!) {
                                                  isColorTypeWoods = val;
                                                  isColorTypeReguler = false;
                                                } else {
                                                  isColorTypeWoods = true;
                                                }
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15)),
                              height: MediaQuery.of(context).size.height * 0.28,
                              width: MediaQuery.of(context).size.width,
                              child: (snapShot.data!
                                              .data()!['woodColors']
                                              .isEmpty &&
                                          isColorTypeWoods) ||
                                      (snapShot.data!
                                              .data()!['regulerColor']
                                              .isEmpty &&
                                          isColorTypeReguler)
                                  ? const Center(
                                      child: Text(
                                        'There is not available color',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: isColorTypeReguler &&
                                              !isColorTypeWoods
                                          ? snapShot.data!
                                              .data()!['regulerColor']
                                              .length
                                          : snapShot.data!
                                              .data()!['woodColors']
                                              .length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 70,
                                          margin: const EdgeInsets.only(
                                              top: 5,
                                              right: 2,
                                              left: 2,
                                              bottom: 0),
                                          decoration: BoxDecoration(
                                            image: !isColorTypeReguler
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        snapShot.data!.data()![
                                                                'woodColors']
                                                            [index]),
                                                    fit: BoxFit.fill)
                                                : null,
                                            color: isColorTypeReguler
                                                ? Color(int.tryParse(snapShot
                                                    .data!
                                                    .data()!['regulerColor']
                                                        [index]
                                                    .toString()) as int)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (isColorTypeReguler) {
                                                  _currentColorName =
                                                      snapShot.data!.data()![
                                                              'regulerNames']
                                                          [index];

                                                  _currentColor = snapShot.data!
                                                          .data()![
                                                      'regulerColor'][index];
                                                } else {
                                                  _currentColorName = snapShot
                                                          .data!
                                                          .data()!['woodNames']
                                                      [index];
                                                  _currentColor = snapShot.data!
                                                          .data()!['woodColors']
                                                      [index];
                                                }
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: ListTile(
                                                leading: Text(
                                                  isColorTypeReguler
                                                      ? snapShot.data!.data()![
                                                          'regulerNames'][index]
                                                      : isColorTypeWoods
                                                          ? snapShot.data!
                                                              .data()![
                                                                  'woodNames']
                                                                  [index]
                                                              .toString()
                                                          : 'No Colors',
                                                  style: TextStyle(
                                                    color: (isColorTypeWoods ==
                                                                true &&
                                                            'Reguler Mirror' ==
                                                                snapShot.data!
                                                                        .data()![
                                                                    'woodNames'][index])
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                trailing: (isColorTypeReguler &&
                                                            _currentColorName ==
                                                                snapShot.data!
                                                                            .data()![
                                                                        'regulerNames']
                                                                    [index]) ||
                                                        (isColorTypeWoods &&
                                                            _currentColorName ==
                                                                snapShot.data!
                                                                        .data()![
                                                                    'woodNames'][index])
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      )
                                                    : const SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, top: 5),
                                  child: const Text(
                                    "Your Order Size is: ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    currentSizeIndex.isNotEmpty
                                        ? '$currentSizeIndex centimeter'
                                        : '${snapShot.data!.data()!['size'][indexOfpriceSize]} centimeter',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Color(0xFF7E0000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              child: snapShot.data!.data()!['size'].isEmpty
                                  ? const Center(
                                      child: Text(
                                        'There is not available Size',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          snapShot.data!.data()!['size'].length,
                                      itemBuilder: (contex, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                currentSizeIndex = snapShot
                                                    .data!
                                                    .data()!['size'][index];
                                                indexOfpriceSize = index;
                                              });
                                            },
                                            child: CircleAvatar(
                                              radius: 18,
                                              backgroundColor:
                                                  snapShot.data!.data()!['size']
                                                              [index] ==
                                                          currentSizeIndex
                                                      ? const Color(0xFF7E0000)
                                                      : Colors.black12,
                                              child: Text(
                                                '${snapShot.data!.data()!['size'][index]} C',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: snapShot.data!.data()![
                                                              'size'][index] ==
                                                          currentSizeIndex
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .collection('cart')
                                .doc(widget.productId)
                                .get(),
                            builder: (ctx, snapshote) {
                              if (snapshote.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width - 16,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: TextButton.icon(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red.shade200),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15)))),
                                    label: Text(
                                      snapshote.data!.data()?['isCart'] == true
                                          ? 'Cancel Order'
                                          : 'Order Now',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    icon: Icon(
                                      snapshote.data!.data()?['isCart'] == true
                                          ? Icons.shopping_cart
                                          : Icons.shopping_cart_outlined,
                                      color: const Color(0xFF7E0000),
                                    ),
                                    onPressed: () async {
                                      final user =
                                          FirebaseAuth.instance.currentUser;

                                      final Map<String, dynamic>
                                          productDetails = {
                                        'isCart': true,
                                        'quantity': count,
                                        'name': snapShot.data!.data()!['name'],
                                        'price': int.tryParse(
                                                snapShot.data!.data()!['price']
                                                    [indexOfpriceSize])! *
                                            count,
                                        'size': snapShot.data!.data()!['size']
                                            [indexOfpriceSize],
                                        'imageUrl':
                                            snapShot.data!.data()!['imageUrl'],
                                        'colorName': _currentColorName,
                                        'colorurl': _currentColor,
                                        'colorType': isColorTypeReguler
                                            ? 'Reguler'
                                            : 'Wood',
                                        'description': snapShot.data!
                                            .data()!['description'],
                                        'switchValue': snapShot.data!
                                            .data()!['switchValue'],
                                      };
                                      setState(() {
                                        isCart = !isCart;
                                      });
                                      if (user != null) {
                                        if (isCart != true) {
                                          // delete the product information from the "likes" collection in Firebase
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user.uid)
                                              .collection('cart')
                                              .doc(widget.productId)
                                              .delete();
                                        } else {
                                          // Save the product information to the "likes" collection in Firebase
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user.uid)
                                              .collection('cart')
                                              .doc(widget.productId)
                                              .set(productDetails);
                                        }
                                      }
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
