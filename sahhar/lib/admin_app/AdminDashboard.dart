import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../auth_screens/LoginPage.dart';
import 'AddCategory.dart';
import 'AddProduct.dart';
import 'Categories.dart';
import 'Products.dart';
import 'orderSchedule.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int orderCont = 0;

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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: RefreshIndicator(
          color: const Color(0xFF7E0000),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 3))
                .whenComplete(() => setState(
                      () {},
                    ));
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("orderStates")
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                        )),
                      );
                    } else {
                      var ordersData = snapshot.data!.docs;
                      int completedOrer = 0;
                      int orderedOrder = 0;
                      int workingOnOrder = 0;
                      for (var element in ordersData) {
                        if (element['packageStutes'] == 'Completed') {
                          completedOrer += 1;
                        }
                        if (element['packageStutes'] == 'Ordered') {
                          orderedOrder += 1;
                        }
                        if (element['packageStutes'] == 'Working on') {
                          workingOnOrder += 1;
                        }
                      }
                      for (int i = 0; i <= ordersData.length; i++) {
                        if (i == ordersData.length && orderCont == 0) {
                          orderCont = snapshot.data!.docs.length;
                        }
                      }
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.26,
                        child: Card(
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
                                        'Count of order packages :',
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
                                        ordersData.length.toString(),
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
                                        'Cont Of Combleted order packages :',
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
                                      percent: (orderedOrder / orderCont),
                                      center: Text(
                                        orderCont != 0 && orderedOrder != 0
                                            ? '${((orderedOrder / orderCont) * 100).round()}%'
                                            : '0 %',
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
                                      percent: (workingOnOrder / orderCont),
                                      center: Text(
                                        orderCont != 0 && workingOnOrder != 0
                                            ? '${((workingOnOrder / orderCont) * 100).round()}%'
                                            : '0 %',
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
                                      percent: (completedOrer / orderCont),
                                      center: Text(
                                        orderCont != 0 && completedOrer != 0
                                            ? '${((completedOrer / orderCont) * 100).round()}%'
                                            : '0 %',
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
                              ]),
                        ),
                      );
                    }
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('products')
                            .get(),
                        builder: (contex, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.indigo,
                                ),
                              ),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                contex,
                                MaterialPageRoute(
                                    builder: (context) => const Products()),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.47,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    'Products',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  Text(
                                    'You have ${snapshot.data!.docs.length} products',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  const Text(
                                    'top here to see all products',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('categories')
                            .get(),
                        builder: (contex, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.47,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.brown,
                                ),
                              ),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                contex,
                                MaterialPageRoute(
                                    builder: (context) => const Categories()),
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.47,
                              decoration: BoxDecoration(
                                color: Colors.brown,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    'Categories',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  Text(
                                    'You have ${snapshot.data!.docs.length} categories',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  const Text(
                                    'top here to see all Catogries',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const Text(
                              'Users problem',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('usersProblem')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.32,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.32,
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (ctx, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Users name : ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['userName'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 2, top: 0),
                                              child: InkWell(
                                                onTap: () {
                                                  snapshot.data!.docs[index]
                                                      .reference
                                                      .delete()
                                                      .then((value) =>
                                                          setState(() {}));
                                                },
                                                child: Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'number : ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                      ['userNumber'] ??
                                                  '',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                ['problem'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                overflow: TextOverflow.fade,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
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
            buildInkDrawer(context, const OrderSchedule(), 'Orders Schedule'),
            Container(
              width: double.infinity,
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF7E0000),
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                highlightColor: const Color(0xFF7E0000).withOpacity(0.7),
                onTap: () async {
                  // Log out the current user
                  await FirebaseAuth.instance.signOut();
                  // Navigate back to the login screen
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const ListTile(
                    title: Text(
                      'LogOut',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    trailing: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
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
