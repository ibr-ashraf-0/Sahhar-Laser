



import 'package:flutter/material.dart';

import 'LoginPage.dart';

class Start_screen extends StatelessWidget {
  const Start_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: const Color(0xFF7E0000),
                  border: Border.all(
                    color: const Color(0xFF7E0000),
                  ),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: const Padding(
                padding:  EdgeInsets.only(top: 18, left: 11),
                child: Text(
                  'Sahhar Shop',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Image.asset(
                  'assets/logo.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const  SizedBox(
              height: 30,
            ),
            Container(
              child: const  Text(
                'Home decor . Arts & Crafts store . Designs . Laser engraving and cutting on wood',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const  SizedBox(
              height: 80,
            ),
            Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const  Center(
                    child: Text(
                      'GET STARTED',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            const  SizedBox(
              height: 120,
            )
          ],
        ),
      ),
    );

  }
}
