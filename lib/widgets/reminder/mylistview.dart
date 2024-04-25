
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class MyListView extends StatefulWidget {
  const MyListView({Key? key, required String title}) : super(key: key);

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {

  bool visibleMenu = false;
  String updateValue = '';

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }
  final firestoreInstance = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getInformation() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    return firestoreInstance.collection("UserData").doc(firebaseUser?.uid).get();
  }

  @override
  void initState() {
    visibleMenu = true;
    getInformation();
  }

  @override
  Widget build(BuildContext context) {
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('UserData')
          .doc(firebaseUser?.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        final DocumentSnapshot? document = snapshot.data;
        final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;

        if(snapshot == null) {
          return const CircularProgressIndicator();
        }

        return documentData['remainder'] != null ? Container(
          color: const Color(0xffFFFFFF),
          width: MediaQuery.of(context).size.width * 4.0,
          height: MediaQuery.of(context).size.height / 1.0,
          child: GroupedListView<dynamic, String>(
            elements: documentData['remainder'],
            groupBy: (element) => element['remainderCreatedDate'],
            order: GroupedListOrder.ASC,
            groupComparator: (value1, value2) => value2.compareTo(value1),
            groupSeparatorBuilder: (String val) {

              if(val.compareTo(DateFormat('yyyy/MM/dd').format(DateTime.now()).toString()) == 0) {
                val = 'Today\'s Activities';
              }
              // else {
              //   val = DateFormat("yyyy/MM/dd").format(DateTime.now());
              // }

              // if(val.compareTo(DateTime.now().toString()) < 0) {
              //   val = 'Yesterday\'s Activities';
              // }

              return Container(
                padding: const EdgeInsets.only(left: 35, bottom: 10, top: 10),
                child: Text(
                  val,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Gilroy Medium',
                  ),
                ),
              );
            },
            itemBuilder: (c, element){
              var remainderName = element['eventInfo']['remainderName'];
              var remainderColor = element['eventInfo']['remainderColor'];
              var remainderDesc = element['eventInfo']['remainderDesc'];
              var remainderIcon = element['eventInfo']['remainderIcon'];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff403f3f).withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(15, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Container(
                          height: 80,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                color: Color(int.parse(remainderColor)),
                                // color: Colors.red,
                              ),
                              const SizedBox(
                                width: 18,
                              ),

                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        remainderName,
                                        style:
                                        const TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Color(0xff181818)),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        remainderDesc,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Gilroy Medium',
                                          color: Color(0xffCACACA),
                                        ),
                                      ),
                                    ],
                                  )),
                              Image.asset(
                                remainderIcon,
                                width: 35,
                                height: 35,
                              ),
                              const SizedBox(
                                width: 10,
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },

          ),
        ) : Container(color: Colors.transparent,);


        // return SingleChildScrollView(
        //   child: Column(
        //     children: [
        //
        //       Container(
        //         width: 350,
        //         height: MediaQuery.of(context).size.height / 1.0,
        //         child: ListView.builder(
        //           itemCount: documentData['reminder'].length,
        //           // separatorBuilder: (BuildContext context, int index) {
        //           // var time = documentData['reminder'][index]['reminderType'];
        //           // var groupByData = groupBy(documentData['reminder'][index]['createdDate'],
        //           //         (Map mapObject) => mapObject[DateTime.parse(documentData['reminder'][index]['createdDate'].isBefore(DateTime.now()))]);
        //           // if(groupByData == 'hello') {
        //           //   return Text('Today Activity', style: const TextStyle(fontSize: 20, fontFamily: 'Gilroy Medium'));
        //           // }
        //           // if (groupByData == 'Weekly') {
        //           //   return Text('Yesterday Activity', style: const TextStyle(fontSize: 20, fontFamily: 'Gilroy Medium'));
        //           // }
        //           // else {
        //           //   return Text('Other', style: const TextStyle(fontSize: 20, fontFamily: 'Gilroy Medium'));
        //           // }
        //           // },
        //           itemBuilder: (context, index) {
        //             return Column(
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        //                   child: Container(
        //                     decoration: BoxDecoration(
        //                       boxShadow: [
        //                         BoxShadow(
        //                           color: const Color(0xff403f3f).withOpacity(0.15),
        //                           spreadRadius: 1,
        //                           blurRadius: 10,
        //                         ),
        //                       ],
        //                     ),
        //                     child: ClipRRect(
        //                       borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
        //                       child: Container(
        //                         height: 80,
        //                         color: Colors.white,
        //                         child: Row(
        //                           children: [
        //                             Container(
        //                               width: 8,
        //                               color: Color(int.parse('${documentData['reminder'][index]['reminderColor']}')),
        //                               // color: Colors.red,
        //                             ),
        //                             const SizedBox(
        //                               width: 18,
        //                             ),
        //                             Expanded(
        //                                 child: Column(
        //                                   mainAxisAlignment: MainAxisAlignment.center,
        //                                   crossAxisAlignment: CrossAxisAlignment.start,
        //                                   children: [
        //                                     Text(
        //                                       '${documentData['reminder'][index]['reminderName']}',
        //                                       style:
        //                                       const TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Color(0xff181818)),
        //                                     ),
        //                                     const SizedBox(height: 8),
        //                                     Text(
        //                                       '${documentData['reminder'][index]['reminderDesc']}',
        //                                       style: const TextStyle(
        //                                         fontSize: 14,
        //                                         fontFamily: 'Gilroy Medium',
        //                                         color: Color(0xffCACACA),
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 )),
        //                             Image.asset(
        //                               '${documentData['reminder'][index]['reminderIcons']}',
        //                               width: 35,
        //                               height: 35,
        //                             ),
        //                             const SizedBox(
        //                               width: 10,
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             );
        //
        //
        //           },
        //         ),
        //       ),
        //
        //     ],
        //   ),
        // );

      },
    );
  }
}