import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'dropdown.dart';

class Weekly extends StatefulWidget {
  const Weekly({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  DateTime selectedDate = DateTime.now().subtract(const Duration(days: 5));
  int currentDateSelectedIndex = 0;
  ScrollController scrollController = ScrollController();
  String selectsDate = '';

  String? dataOne;
  String? dataTwo;
  String? dataThree;
  String? title;

  List activeButton = [true, true, true, true, true, true, true];
  var activeButtonIndex;

  bool _flag = false;
  String selectedIndex = '';
  var compareReminderCategory;

  @override
  void initState() {
    // TODO: implement initState
    _flag = true;
    getReminderCategory();
    super.initState();
  }

  // void getReminderCategory(){
  //   if(activeButton[activeButtonIndex] == )
  // }

  void getReminderCategory() async {
    FirebaseFirestore.instance.collection("remainder").get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        print(element['remainderName']);
        print(element['remainderCategory']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot == null) {
          return const CircularProgressIndicator();
        }

        final DocumentSnapshot? document = snapshot.data;
        final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xffFFFFFF),
              margin: const EdgeInsets.all(15),
              height: 80,
              child: ListView.separated(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 15);
                },
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print('index: $index');
                      setState(() {
                        currentDateSelectedIndex = index;
                        selectedDate = DateTime.now().add(Duration(days: index));
                        selectsDate = DateFormat('yyyy/MM/dd').format(selectedDate).toString();
                      });
                      DropDown(
                        title: 'Week',
                      );
                      // DropDown(title: widget.title,);

                      // print('DateFormat: ${DateFormat('yyyy/MM/dd').format(selectedDate)}');
                      // print('currentDateSelectedIndex: $currentDateSelectedIndex');

                      // for (var element in value.docs) {
                      //   cards.add(element.data());
                      // }

                      // forEach((element) {
                      //   print(element['reminderName']);
                      //   print(element['reminderCategory']);
                      // })

                      // if(selectsDate == documentData['remainder'][index]['createdDate']) {
                      //
                      //   dataOne = documentData['remainder'][index]['remainderName'];
                      //   dataTwo = documentData['remainder'][index]['remainderDesc'];
                      //   dataThree = documentData['remainder'][index]['remainderColor'];
                      //
                      //   print(documentData['remainder'][index]['createdDate']);
                      //   print(documentData['remainder'][index]['remainderName']);
                      //
                      // };

                      print('selectedDate: $selectsDate');
                    },
                    child: Container(
                      height: 60,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffF9F9F9),
                            )
                          ],
                          color: currentDateSelectedIndex == index ? const Color(0xffFFE2AB) : Colors.transparent),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 7.5,
                          ),
                          Container(
                            width: 39,
                            height: 33,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30), color: currentDateSelectedIndex == index ? Colors.white : Color(0xffFfFfFf)),
                            child: Center(
                              child: Text(
                                DateTime.now().add(Duration(days: index)).day.toString(),
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w700, color: currentDateSelectedIndex == index ? Colors.black : Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            listOfDays[DateTime.now().add(Duration(days: index)).weekday - 1].toString(),
                            style: TextStyle(fontSize: 16, color: currentDateSelectedIndex == index ? Colors.black : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 100,
              ),
            ),

            // ListView.builder(
            //     itemBuilder: (context, index){
            //       return Container();
            //     }
            // ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 4.0,
              height: 400, // MediaQuery.of(context).size.height / 1.0,
              child: GroupedListView<dynamic, String>(
                elements: documentData['remainder'],
                groupBy: (element) => element['remainderCreatedDate'],
                order: GroupedListOrder.ASC,
                // groupComparator: (value1, value2) {
                //   return value2.compareTo(value1);
                // },
                groupSeparatorBuilder: (String val) {
                  if (val.compareTo(DateFormat('yyyy/MM/dd').format(DateTime.now()).toString()) == 0) {
                    val = 'Today\'s Activities';
                  }
                  // else {
                  //   val = DateFormat("yyyy/MM/dd").format(DateTime.now());
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
                itemBuilder: (c, element) {
                  var reminderName = element['eventInfo']['remainderName'];
                  var reminderColor = element['eventInfo']['remainderColor'];
                  var reminderDesc = element['eventInfo']['remainderDesc'];
                  var reminderIcon = element['eventInfo']['remainderIcon'];

                  return Visibility(
                    visible: _flag,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  // color: const Color(0xff403f3f).withOpacity(0.15),
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
                                      color: Color(int.parse(reminderColor)),
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
                                          reminderName,
                                          style: const TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Color(0xff181818)),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          reminderDesc,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Gilroy Medium',
                                            color: Color(0xffCACACA),
                                          ),
                                        ),
                                      ],
                                    )),
                                    Image.asset(
                                      reminderIcon,
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
                    ),
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 25, top: 50),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 0,
                      backgroundColor: activeButton[0] ? const Color(0xffF6F6F6) : const Color(0xffFFBE78),
                      foregroundColor: const Color(0xff494949),
                    ),
                    onPressed: () {
                      setState(() {
                        activeButton[0] = !activeButton[0];
                      });
                    },
                    child: Text(
                      activeButton[0] ? 'sense' : 'sense x',
                      style: const TextStyle(
                        fontFamily: 'Gilroy Medium',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 0,
                      backgroundColor: activeButton[1] ? const Color(0xffF6F6F6) : const Color(0xffFFBE78),
                      foregroundColor: const Color(0xff494949),
                    ),
                    onPressed: () {
                      setState(() {
                        activeButton[1] = !activeButton[1];

                        // compareReminderCategory = activeButton[1];
                        // print(documentData['reminder'][1]['reminderCategory'] == 'Active');
                        // _flag = false;
                      });
                    },
                    child: Text(
                      activeButton[1] ? 'active' : 'active x',
                      style: const TextStyle(
                        fontFamily: 'Gilroy Medium',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 0,
                      backgroundColor: activeButton[2] ? const Color(0xffF6F6F6) : const Color(0xffFFBE78),
                      foregroundColor: const Color(0xff494949),
                    ),
                    onPressed: () {
                      setState(() {
                        activeButton[2] = !activeButton[2];
                      });
                    },
                    child: Text(
                      activeButton[2] ? 'category' : 'category x',
                      style: const TextStyle(
                        fontFamily: 'Gilroy Medium',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 0,
                      backgroundColor: activeButton[3] ? const Color(0xffF6F6F6) : const Color(0xffFFBE78),
                      foregroundColor: const Color(0xff494949),
                    ),
                    onPressed: () {
                      setState(() {
                        activeButton[3] = !activeButton[3];
                      });
                    },
                    child: Text(
                      activeButton[3] ? 'this' : 'this x',
                      style: const TextStyle(
                        fontFamily: 'Gilroy Medium',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 0,
                      backgroundColor: activeButton[4] ? const Color(0xffF6F6F6) : const Color(0xffFFBE78),
                      foregroundColor: const Color(0xff494949),
                    ),
                    onPressed: () {
                      setState(() {
                        activeButton[4] = !activeButton[4];
                      });
                    },
                    child: Text(
                      activeButton[4] ? 'remainder' : 'remainder x',
                      style: const TextStyle(
                        fontFamily: 'Gilroy Medium',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 0,
                      backgroundColor: activeButton[5] ? const Color(0xffF6F6F6) : const Color(0xffFFBE78),
                      foregroundColor: const Color(0xff494949),
                    ),
                    onPressed: () {
                      setState(() {
                        activeButton[5] = !activeButton[5];
                      });
                    },
                    child: Text(
                      activeButton[5] ? 'Items' : 'Items x',
                      style: const TextStyle(
                        fontFamily: 'Gilroy Medium',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 0,
                      backgroundColor: activeButton[6] ? const Color(0xffF6F6F6) : const Color(0xffFFBE78),
                      foregroundColor: const Color(0xff494949),
                    ),
                    onPressed: () {
                      setState(() {
                        activeButton[6] = !activeButton[6];
                      });
                    },
                    child: Text(
                      activeButton[6] ? 'passive' : 'passive x',
                      style: const TextStyle(
                        fontFamily: 'Gilroy Medium',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
