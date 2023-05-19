import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Ordernfo extends StatefulWidget {
  final String orderId;

  const Ordernfo({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<Ordernfo> createState() => _OrdernfoState();
}

class _OrdernfoState extends State<Ordernfo> {
  bool chechWrking = false;
  bool chechCompleted = false;

  bool chechOrdring = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('order')
            .doc(widget.orderId)
            .collection('items')
            .get(),
        builder: (contex, snapshot) {
          if (snapshot.data?.docs.length == 0) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.90,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  'No Orders in this package',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w300),
                ),
              ),
            );
          } else if (snapshot.connectionState != ConnectionState.done) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7E0000),
                ),
              ),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.90,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (ctx, index) {
                  print(snapshot.data?.docs.length);

                  return Container(
                    color: Colors.grey.shade300,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'product name : ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        '${snapshot.data!.docs[index]['productName']}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: MediaQuery.of(ctx).size.height * 0.15,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: MediaQuery.of(ctx).size.width * 0.62,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 4),
                                  child: Column(
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Order Info',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'product size : ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              '${snapshot.data!.docs[index]['size']} centimeters',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'product price : ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              '${snapshot.data!.docs[index]['price']} ₪',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Name in product : ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              '${snapshot.data!.docs[index]['nameInProduct']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Color name : ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              '${snapshot.data!.docs[index]['colorName']}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 120,
                              width: MediaQuery.of(ctx).size.width * 0.31,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      snapshot.data!.docs[index]['color'] == ''
                                          ? Colors.black
                                          : snapshot.data!.docs[index]
                                                      ['colorType'] ==
                                                  'Reguler'
                                              ? Color(int.tryParse(snapshot
                                                  .data!.docs[index]['color']
                                                  .toString()) as int)
                                              : null,
                                  image:
                                      snapshot.data!.docs[index]['color'] == ''
                                          ? null
                                          : snapshot.data!.docs[index]
                                                      ['colorType'] ==
                                                  'Wood'
                                              ? DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(snapshot
                                                      .data!
                                                      .docs[index]['color']),
                                                )
                                              : null),
                              child: snapshot.data!.docs[index]['color'] == ''
                                  ? const Center(
                                      child: Text(
                                      'No\nColor',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ))
                                  : Center(
                                      child: Text(
                                      snapshot.data!.docs[index]['colorType'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    )),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
