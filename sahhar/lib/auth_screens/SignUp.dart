import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Map userData = {
    'Firstname': '',
    'Lastname': '',
    'email': '',
    'pass': '',
  };
  TextEditingController txtpassC = TextEditingController();

  bool didclick = false;

  bool validateInputs() {
    if (userData['Firstname'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please enter your First Name',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7E0000),
      ));
      return false;
    }
    if (userData['Lastname'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please enter your Last Name',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7E0000),
      ));
      return false;
    }
    if (userData['email'].isEmpty || !userData['email'].contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please enter a Valid email address',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7E0000),
      ));
      return false;
    }
    if (userData['pass'].isEmpty || userData['pass'].length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please enter a Password with at least 6 characters',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7E0000),
      ));
      return false;
    }
    if (txtpassC!.text != userData['pass']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Passwords do Not match',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7E0000),
      ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Back'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                color: const Color(0xFF7E0000),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 10),
                    child: Text(
                      "Create\nAccont",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: const Color(0xFF7E0000),
                child: Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35)))),
              ),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.70,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      cursorColor: const Color(0xFF7E0000),
                      onChanged: (value) => userData['Firstname'] = value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF7E0000),
                          size: 25,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF7E0000),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelStyle: const TextStyle(
                          color: Color(0xFF7E0000),
                        ),
                        labelText: "First Name",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      cursorColor: const Color(0xFF7E0000),
                      onChanged: (value) => userData['Lastname'] = value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF7E0000),
                          size: 25,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF7E0000),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelStyle: const TextStyle(
                          color: Color(0xFF7E0000),
                        ),
                        labelText: "Last Name",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) => userData['email'] = value,
                      cursorColor: const Color(0xFF7E0000),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          size: 25,
                          color: Color(0xFF7E0000),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF7E0000),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelStyle: const TextStyle(
                          color: Color(0xFF7E0000),
                        ),
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) => userData['pass'] = value,
                      cursorColor: const Color(0xFF7E0000),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 25,
                          color: Color(0xFF7E0000),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF7E0000),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelStyle: const TextStyle(
                          color: Color(0xFF7E0000),
                        ),
                        labelText: "Password",
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: txtpassC,
                      cursorColor: const Color(0xFF7E0000),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 25,
                          color: Color(0xFF7E0000),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF7E0000),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelStyle: const TextStyle(
                          color: Color(0xFF7E0000),
                        ),
                        labelText: "Confirm Password",
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 35),
                    Container(
                      child: InkWell(
                        onTap: () async {
                          if (!validateInputs()) return;
                          FirebaseAuth auth = FirebaseAuth.instance;
                          try {
                            await auth.createUserWithEmailAndPassword(
                                email: userData['email'],
                                password: userData['pass']);
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(auth.currentUser!.uid.toString())
                                .set({
                              "Firstname": userData['Firstname'],
                              "Lastname": userData['Lastname'],
                              "email": userData['email'],
                              "pass": userData['pass'],
                            });
                            // await FirebaseFirestore.instance
                            //     .collection('users')
                            //     .doc(auth.currentUser!.uid.toString())
                            //     .collection('cart')
                            //     .add();
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title: const Text("Success",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 10,
                                    child:
                                        const Text("Sign up successfully Done"),
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      child: const Text("OK  ",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())));
                          }
                        },
                        child: Container(
                          width: 170,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN UP',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
