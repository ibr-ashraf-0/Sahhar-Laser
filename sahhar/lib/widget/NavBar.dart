import 'package:flutter/material.dart';
import 'package:sahhar/user_app/Home.dart';

import '../user_app/AccontInfo.dart';
import '../user_app/CartPage.dart';
import '../user_app/LikePage.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _curntInedx = 0;
  void _onItemTapped(int index) {
    setState(() {
      _curntInedx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
          print('from push $index');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          _onItemTapped(index);
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LikePage()),
          ).then((value) {
            _onItemTapped(index);
          });
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
          _onItemTapped(index);
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AccontInfo()),
          );
          _onItemTapped(index);
        }
      },
    );
  }
}
