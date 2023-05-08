import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'AddCategory.dart';
import 'AddProduct.dart';
import 'Categories.dart';
import 'Products.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: FirebaseFirestore.instance.collection("order").get(),
                builder: (context, snapshot) {
                  if (snapshot.data?.docs.length == 0 &&
                      snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: Text('No Orders'),
                    );
                  } else if (snapshot.connectionState != ConnectionState.done &&
                      snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    var ordersData = snapshot.data!.docs;
                    int completedOrer = 0;
                    int orderedOrder = 0;
                    int workingOnOrder = 0;
                    // for (int i = 0; i < 1; i++) {
                    //   print(snapshot.data!.docs[i].id);
                    // }
                    for (var element in ordersData) {
                      if (element['orderStutes'] == 'Completed') {
                        completedOrer += 1;
                      }
                      if (element['orderStutes'] == 'Ordered') {
                        orderedOrder += 1;
                      }
                      if (element['orderStutes'] == 'Working on') {
                        workingOnOrder += 1;
                      }
                    }
                    return Container(
                      // color: Colors.amber,
                      height: MediaQuery.of(context).size.height * 0.90,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(children: [
                        Card(
                          color: Colors.white70,
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 0, top: 15),
                                      child: const Text(
                                        'Count of Orders:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 0, top: 15),
                                      child: Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 0),
                                      child: const Text(
                                        'Cont Of Combleted Orders:',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 0),
                                      child: Text(
                                        completedOrer.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircularPercentIndicator(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              8.0,
                                      lineWidth: 5.0,
                                      animation: true,
                                      percent: ((snapshot.data!.docs.length -
                                                  orderedOrder) /
                                              (snapshot.data!.docs.length +
                                                  orderedOrder / 2) /
                                              100.0 *
                                              100.0)
                                          .toDouble(),
                                      center: Text(
                                        '${((snapshot.data!.docs.length - orderedOrder) / (snapshot.data!.docs.length + orderedOrder / 2) * 100).round()}%',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      footer: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          'Orders',
                                          style: TextStyle(
                                              color: Colors.amber.shade500,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.amber,
                                    ),
                                    CircularPercentIndicator(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              8.0,
                                      lineWidth: 5.0,
                                      animation: true,
                                      percent: ((snapshot.data!.docs.length -
                                                  workingOnOrder) /
                                              (snapshot.data!.docs.length +
                                                  workingOnOrder / 2) /
                                              100.0 *
                                              100.0)
                                          .toDouble(),
                                      center: Text(
                                        '${((snapshot.data!.docs.length - workingOnOrder) / (snapshot.data!.docs.length + workingOnOrder / 2) * 100).round()}%',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      footer: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          'Working on',
                                          style: TextStyle(
                                              color: Colors.red.shade500,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.red,
                                    ),
                                    CircularPercentIndicator(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              8.0,
                                      lineWidth: 5.0,
                                      animation: true,
                                      percent: ((snapshot.data!.docs.length -
                                                  completedOrer) /
                                              (snapshot.data!.docs.length +
                                                  completedOrer / 2) /
                                              100.0 *
                                              100.0)
                                          .toDouble(),
                                      center: Text(
                                        '${((snapshot.data!.docs.length - completedOrer) / (snapshot.data!.docs.length + completedOrer / 2) * 100).round()}%',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      footer: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: const Text(
                                          'Completed',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.black,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, bottom: 15),
                                        child: const Text(
                                          'Last order makes in: 25/4/2023',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  ],
                                ),
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("order")
                                .get(),
                            builder: (context, snapshot) => GridView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                mainAxisExtent: 230,
                                childAspectRatio: 1,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                              itemCount: 2,
                              itemBuilder: (cotext, index) {
                                return Column(
                                  children: [],
                                );
                              },
                            ),
                          ),
                        )
                      ]),
                    );
                  } else {
                    return const Center(
                      child: Text('No Orders'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.supervised_user_circle),
                  SizedBox(width: 10),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7E0000),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1.5,
              color: Color(0xFF7E0000),
            ),
            buildInkDrawer(context, const Categories(), 'Categories'),
            buildInkDrawer(context, AddCategory(), 'Add Category'),
            buildInkDrawer(context, const Products(), 'Products'),
            buildInkDrawer(context, AddProduct(), 'Add Product'),
            buildInkDrawer(context, const Categories(), 'Orders Schedule'),
          ],
        ),
      ),
    );
  }

  Container buildInkDrawer(BuildContext ctx, Widget page, String title) {
    return Container(
      width: double.infinity,
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF7E0000),
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          alignment: Alignment.centerLeft,
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }
}
