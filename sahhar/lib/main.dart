import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sahhar/widget/startScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sahhar/user_app/Home.dart';
import 'admin_app/AdminDashboard.dart';
import 'user_app/AccontInfo.dart';
import 'user_app/CartPage.dart';
import 'user_app/LikePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'SahharLaserApp',
      options: const FirebaseOptions(
        appId: "1:128325721692:android:d85f9fe0d03bd742d99099",
        apiKey: "AIzaSyB7Ftohg3cd1j7IefUbz580nlrV5d9egFM",
        androidClientId:
            '128325721692-vrt43ghvejre5hgne0qqleopro3e26jd.apps.googleusercontent.com',
        projectId: "sahharlaserapp",
        messagingSenderId: '128325721692',
      ),
    );
  }

  runApp(SahharApp());
}

class SahharApp extends StatefulWidget {
  @override
  State<SahharApp> createState() => _SahharAppState();
}

class _SahharAppState extends State<SahharApp> {
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const LikePage(),
    CartPage(),
    AccontInfo(),
  ];
  int _curntInedx = 0;

  void _onItemTapped(int index) {
    setState(() {
      _curntInedx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF7E0000),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        toolbarHeight: 60,
        elevation: 0.0,
      )),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData && snapshot.data!.email == 'admin@gmail.com') {
              return AdminDashboard();
            } else if (snapshot.hasData &&
                snapshot.data!.email != 'admin@gmail.com') {
              return Scaffold(
                appBar: _curntInedx != 3
                    ? AppBar(
                        title: Text(
                          _curntInedx == 0
                              ? 'Categories'
                              : _curntInedx == 1
                                  ? 'Likes'
                                  : _curntInedx == 2
                                      ? 'Cart'
                                      : '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                      )
                    : null,
                body: _widgetOptions.elementAt(_curntInedx),
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
                  currentIndex: _curntInedx,
                  selectedItemColor: const Color(0xFF7E0000),
                  unselectedItemColor: Colors.black,
                  onTap: (index) {
                    if (index == 0) {
                      _onItemTapped(index);
                    } else if (index == 1) {
                      _onItemTapped(index);
                    } else if (index == 2) {
                      _onItemTapped(index);
                    } else if (index == 3) {
                      _onItemTapped(index);
                    }
                  },
                ),
              );
            } else {
              return const Start_screen();
            }
          }),
    );
  }
}
