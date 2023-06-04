import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditProduct.dart';

class Products extends StatefulWidget {
  const Products();
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> _productsStream;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _productsStream = _firestore.collection('products').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>? _snapshot;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filteredProducts =
                          _snapshot!.data!.docs.where((product) {
                        final userData = product.data();
                        final name = userData['name'] ?? '';
                        final query = value.toLowerCase();

                        return name.toLowerCase().contains(query);
                      }).toList();
                    });
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _productsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7E0000),
                      ),
                    );
                  }
                  _snapshot =
                      snapshot; // Assign the snapshot to _snapshot variable
                  final products = _filteredProducts.isNotEmpty
                      ? _filteredProducts
                      : (snapshot.data!.docs
                          as List<QueryDocumentSnapshot<Map<String, dynamic>>>);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          MediaQuery.of(context).size.width / 1.8,
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.26,
                      childAspectRatio: 1,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: products.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = products[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(2),
                              height: MediaQuery.of(context).size.height * 0.16,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  doc['imageUrl'][0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Text(
                                      doc['name'].toString().toUpperCase(),
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: InkWell(
                                          child: const Icon(Icons.edit),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProduct(
                                                        productId: doc.id,
                                                      )),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: InkWell(
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            deleteProduct(doc.id);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void deleteProduct(String productId) async {
  try {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
  } catch (e) {
    print('Error deleting product: $e');
  }
}
