import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_screens/LoginPage.dart';
import '../wide/NavBar.dart';

class AccontInfo extends StatelessWidget {
  const AccontInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
