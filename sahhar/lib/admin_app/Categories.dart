import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sahhar/admin_app/AdminDashboard.dart';
import 'package:sahhar/EditCategory.dart';

void main() => runApp(const Categories());

class Categories extends StatelessWidget {
  const Categories();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget();

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Column(
      children: [
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 226, 226),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.black,
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search..',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("categories").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1, crossAxisCount: 2),
                itemCount: snapshot.data!.docs.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            height: 80,
                            width: 80,
                            child: Image.network(
                              doc['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 6),
                            decoration: BoxDecoration(
                                //color: Color(0xFF7E0000),
                                // borderRadius: BorderRadius.circular(20),
                                ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditCategory(
                                                  categoryId: doc.id,
                                                )),
                                      );
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.black,
                                    onPressed: () {
                                      deleteCategory(doc.id);
                                    },
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    doc['name'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF7E0000),
        toolbarHeight: 100,
      ),
      body: _selectedIndex == 0
          ? _widgetOptions.elementAt(_selectedIndex)
          : Center(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }
}

void deleteCategory(String categoryId) async {
  try {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .delete();
  } catch (e) {
    print('Error deleting category: $e');
  }
}
