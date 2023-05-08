import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class chooseColor extends StatefulWidget {
  const chooseColor({super.key});

  @override
  State<chooseColor> createState() => _chooseColorState();
}

List<String> choosesRegulerColor = [];
List<String> choosesRegulerNameColor = [];
List<String> choosesWoodsColor = [];
List<String> choosesWoodsNameColor = [];

class _chooseColorState extends State<chooseColor> {
  bool isColorTypeReguler = true;
  bool isColorTypeWoods = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Choese Product Colors'),
      collapsedBackgroundColor: const Color.fromARGB(179, 241, 185, 185),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      textColor: Colors.black,
      collapsedIconColor: Colors.black,
      backgroundColor: const Color.fromARGB(179, 241, 185, 185),
      iconColor: Colors.black,
      collapsedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('adminData')
                  .doc(isColorTypeReguler ? 'regularColors' : 'uniqueColors')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.data?.data()?.length != 0 &&
                    snapshot.connectionState != ConnectionState.done) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            color: Color(0xFF7E0000),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'please wait...',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ));
                } else if (snapshot.data!.data()!.isEmpty &&
                    snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Center(
                          child: Text(
                              'Connecting fild !\nplease check your Internet')));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.zero,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    if (isColorTypeReguler) {
                                      isColorTypeReguler = true;
                                      isColorTypeWoods = false;
                                    } else {
                                      isColorTypeReguler = true;

                                      isColorTypeWoods = false;
                                    }
                                  });
                                },
                                elevation: 0,
                                fillColor: isColorTypeReguler == true
                                    ? const Color(0xFF7E0000)
                                    : Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                splashColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'Reguler Colors',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isColorTypeReguler == true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    if (isColorTypeWoods) {
                                      isColorTypeWoods = true;
                                      isColorTypeReguler = false;
                                    } else {
                                      isColorTypeWoods = true;

                                      isColorTypeReguler = false;
                                    }
                                  });
                                },
                                fillColor: isColorTypeWoods == true
                                    ? const Color(0xFF7E0000)
                                    : Colors.white,
                                elevation: 0,
                                // autofocus: true,
                                splashColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'Woods Colors',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isColorTypeWoods == true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 18,
                        child: Marquee(
                          text: (choosesRegulerNameColor.isEmpty) &&
                                  (choosesWoodsNameColor.isEmpty)
                              ? 'you didnt choses any color'
                              : 'You choses from Reguler color : $choosesRegulerNameColor  And You choses from Woods color : $choosesWoodsNameColor',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 100.0,
                          pauseAfterRound: const Duration(seconds: 2),
                          startPadding: 8.0,
                          accelerationDuration: const Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration:
                              const Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.data()!.length ~/ 2,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                MediaQuery.of(context).size.height * 0.25,
                            mainAxisExtent: 120,
                            childAspectRatio: 1,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 2),
                              decoration: BoxDecoration(
                                image: !isColorTypeReguler
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data?['colors$index']),
                                        fit: BoxFit.fill)
                                    : null,
                                color: isColorTypeReguler
                                    ? Color(int.tryParse(snapshot
                                        .data!['colors$index']
                                        .toString()) as int)
                                    : null,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if ((choosesRegulerColor.any((element) =>
                                              element ==
                                              snapshot.data!['colors$index']) &&
                                          choosesRegulerNameColor.any(
                                              (element) =>
                                                  element ==
                                                  snapshot.data![
                                                      'nameOfColor$index'])) ||
                                      (choosesWoodsColor.any((element) =>
                                              element ==
                                              snapshot.data!['colors$index']) &&
                                          choosesWoodsNameColor.any((element) =>
                                              element ==
                                              snapshot.data![
                                                  'nameOfColor$index']))) {
                                    setState(() {
                                      if (isColorTypeReguler) {
                                        choosesRegulerColor.remove(
                                            snapshot.data!['colors$index']);
                                        choosesRegulerNameColor.remove(snapshot
                                            .data!['nameOfColor$index']);
                                      } else {
                                        choosesWoodsColor.remove(
                                            snapshot.data!['colors$index']);
                                        choosesWoodsNameColor.remove(snapshot
                                            .data!['nameOfColor$index']);
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      if (isColorTypeReguler) {
                                        choosesRegulerColor.add(
                                            snapshot.data!['colors$index']);
                                        choosesRegulerNameColor.add(snapshot
                                            .data!['nameOfColor$index']);
                                      } else {
                                        choosesWoodsColor.add(
                                            snapshot.data!['colors$index']);
                                        choosesWoodsNameColor.add(snapshot
                                            .data!['nameOfColor$index']);
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: ListTile(
                                    title: Text(
                                      snapshot.data!['nameOfColor$index'],
                                      style: TextStyle(
                                          color: snapshot.data![
                                                      'nameOfColor$index'] ==
                                                  'Reguler Mirror'
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          overflow: TextOverflow.clip),
                                    ),
                                    trailing: choosesRegulerNameColor.any(
                                                (element) =>
                                                    element ==
                                                    snapshot.data![
                                                        'nameOfColor$index']) ||
                                            choosesWoodsNameColor.any(
                                                (element) =>
                                                    element ==
                                                    snapshot.data![
                                                        'nameOfColor$index'])
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                        : const SizedBox(
                                            height: 2,
                                            width: 2,
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }
}
