import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'orderInfo.dart';

class OrderSchedule extends StatefulWidget {
  const OrderSchedule({super.key});

  @override
  State<OrderSchedule> createState() => _OrderScheduleState();
}

class _OrderScheduleState extends State<OrderSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'package of orders',
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
        future: FirebaseFirestore.instance.collection('orderStates').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: CircularProgressIndicator(
              color: Color(0xFF7E0000),
            ));
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data!.docs.isNotEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (contex, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => Ordernfo(
                                orderId: snapshot.data!.docs[index].id,
                              )));
                    },
                    child: Container(
                      width: MediaQuery.of(contex).size.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          color: const Color(0xFF7E0000),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(contex).size.width * 0.93,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'clint name : ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          width: 160,
                                          child: Text(
                                            '${snapshot.data!.docs[index]['userName']}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 30,
                                      width: 20,
                                      child: InkWell(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('order')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .collection('items')
                                              .get()
                                              .then((value) {
                                            for (int i = 0;
                                                i < value.docs.length;
                                                i++)
                                              value.docs[i].reference.delete();
                                          }).then((value) async {
                                            await FirebaseFirestore.instance
                                                .collection('orderStates')
                                                .doc(snapshot
                                                    .data!.docs[index].id)
                                                .delete();
                                          }).then((value) => setState(() {}));
                                        },
                                        child: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'clint phone : ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 181,
                                    child: Text(
                                      '${snapshot.data!.docs[index]['number']}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Clint email: ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 170,
                                    child: Text(
                                      snapshot.data!.docs[index]['email']
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Total price : ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '${snapshot.data!.docs[index]['totalprice']} ₪',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'Package States :  ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Ordring',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                          height: 25,
                                          width: 23,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Checkbox(
                                            checkColor: Colors.black,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            activeColor: Colors.white,
                                            value: snapshot.data!.docs[index]
                                                        ['packageStutes'] ==
                                                    'Ordered'
                                                ? true
                                                : false,
                                            onChanged: (val) async {
                                              FirebaseFirestore.instance
                                                  .collection('orderStates')
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .update({
                                                'packageStutes': 'Ordered',
                                              }).then((value) =>
                                                      setState(() {}));
                                            },
                                          )),
                                      const Text(
                                        'Wrking on',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                          height: 25,
                                          width: 23,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Checkbox(
                                            checkColor: Colors.black,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            activeColor: Colors.white,
                                            value: snapshot.data!.docs[index]
                                                        ['packageStutes'] ==
                                                    'Working on'
                                                ? true
                                                : false,
                                            onChanged: (val) async {
                                              FirebaseFirestore.instance
                                                  .collection('orderStates')
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .update({
                                                'packageStutes': 'Working on',
                                              }).then((value) =>
                                                      setState(() {}));
                                            },
                                          )),
                                      const Text(
                                        'Completed',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                          height: 25,
                                          width: 23,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Checkbox(
                                            checkColor: Colors.black,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            activeColor: Colors.white,
                                            value: snapshot.data!.docs[index]
                                                        ['packageStutes'] ==
                                                    'Completed'
                                                ? true
                                                : false,
                                            onChanged: (val) {
                                              FirebaseFirestore.instance
                                                  .collection('orderStates')
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .update({
                                                'packageStutes': 'Completed',
                                              }).then((value) =>
                                                      setState(() {}));
                                            },
                                          )),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No package',
                style: TextStyle(color: Colors.black, fontSize: 26),
              ),
            );
          }
        },
      ),
    );
  }
}
