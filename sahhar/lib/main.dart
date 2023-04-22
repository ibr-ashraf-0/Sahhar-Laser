import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sahhar/auth_screens/startScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sahhar/user_app/Home.dart';

import 'admin_app/AdminDashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'SahharLaserApp',
      // options: DefaultFirebaseOptions.currentPlatform,
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

class SahharApp extends StatelessWidget {
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
              return const HomePage();
            } else {
              return const Start_screen();
            }
          }),
    );
  }
}
