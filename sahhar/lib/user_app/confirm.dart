import 'package:flutter/material.dart';

class confirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirmation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congratulations',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your order is set. It will be delivered\nwithin 7 days. You will be notified\nonce your order arrives at the\npickup station.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF7E0000),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for shopping at\nSahhar Laser.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'WELCOME AGAIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Color(0xFF7E0000),
                //fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
