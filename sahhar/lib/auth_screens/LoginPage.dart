import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahhar/main.dart';
import 'package:sahhar/user_app/Home.dart';
import '../admin_app/AdminDashboard.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Resetpsw.dart';
import 'SignUp.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Map<String, dynamic> loginData = {
    'email': '',
    'password': '',
  };
  // TextEditingController? txtuser;
  // TextEditingController? txtpass;
  bool didclick = false;
  bool isAdmin = false;

  bool validateInputs() {
    if (loginData['email'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your email',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF7E0000),
        ),
      );
      return false;
    }
    if (loginData['password'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Please enter your password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF7E0000),
      ));
      return false;
    }
    return true;
  }

  Future<void> signwith(String email, String pass) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      if (email == 'admin@gmail.com' && pass == 'admin123') {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SahharApp()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email or password is incorrect',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF7E0000),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  bool checkdata() {
    if (loginData['email'].isEmpty || loginData['password'].isEmpty) {
      return false;
    }
    return true;
  }

//login with google
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<String?> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return 'Not user Found';
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "Firstname": user?.displayName,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'Lastname': '',
        "email": user!.email,
      });
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
//login with facebook
  /*
  loginWithFacebook() async {
    try {
      final facebookLoginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile', 'user_birthday'],
        loginBehavior: LoginBehavior.dialogOnly,
      );
      print('facebookLoginResult = ${facebookLoginResult.accessToken?.token}');
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      final userData = await FacebookAuth.instance.getUserData();
      debugPrint('user email == ${userData['email']}');
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } catch (error) {
      print('error = $error');
    }
    return null;
  }
*/

  //login with twitter
  /*
  final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: '<your_consumer_key>',
    consumerSecret: '<your_consumer_secret>',
  );
  Future<void> loginWithTwitter() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    if (result.status == TwitterLoginStatus.loggedIn) {
      final AuthCredential credential = TwitterAuthProvider.credential(
        accessToken: result.session!.token,
        secret: result.session!.secret,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to the home screen
    } else {
      // Handle login failure
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
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
                    "Welcome!",
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
                    onChanged: (value) {
                      loginData['email'] = value;
                    },
                    cursorColor: const Color(0xFF7E0000),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
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
                      labelText: "Your Email",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      loginData['password'] = value;
                    },
                    cursorColor: const Color(0xFF7E0000),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Color(0xFF7E0000),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 25,
                        color: Color(0xFF7E0000),
                      ),
                      labelText: "Password",
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
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 35),
                  didclick == false
                      ? const SizedBox(
                          height: 10,
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Invalid Username or password',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  Container(
                    child: InkWell(
                      onTap: () {
                        if (!validateInputs()) return;
                        signwith(loginData['email'], loginData['password']);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Resetpsw()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          child: Image.asset(
                            'assets/google.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        onTap: () => googleLogin().then(
                          (value) async {
                            if (value != null) {
                              return;
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: const Text(
                      "Don’t have account? Sign up now.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
