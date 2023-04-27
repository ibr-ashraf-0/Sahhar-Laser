import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahhar/user_app/products.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCart = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   child: Container(
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: const Color.fromARGB(255, 226, 226, 226),
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //     child: const TextField(
          //       cursorColor: Colors.grey,
          //       decoration: InputDecoration(
          //         prefixIcon: Icon(
          //           Icons.search,
          //           color: Colors.grey,
          //         ),
          //         label: Text('Search...'),
          //         labelStyle: TextStyle(color: Colors.grey),
          //         hintStyle: TextStyle(
          //           fontWeight: FontWeight.bold,
          //         ),
          //         border: InputBorder.none,
          //       ),
          //     ),
          //   ),
          // ),
         
         
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("categories")
                  .snapshots(),
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
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
    );
    // _widgetOptions.elementAt(_selectedIndex)),
  }
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
