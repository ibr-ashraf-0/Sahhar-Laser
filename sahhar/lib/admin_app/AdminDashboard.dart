import 'package:flutter/material.dart';
import 'AddCategory.dart';
import 'AddProduct.dart';
import 'Categories.dart';
import 'Products.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 31,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: Center(
        child: Text('Welcome to the Admin Page'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 150,
              child: DrawerHeader(
                child: Row(
                  children: [
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
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
              },
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF7E0000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCategory()),
                );
              },
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Add Category',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF7E0000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Products()),
                );
              },
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF7E0000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProduct()),
                );
              },
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF7E0000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Orders Schedule',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF7E0000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
