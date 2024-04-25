import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_management/pages/Reminder/new_reminder.dart';

class NewWeekly extends StatefulWidget {
  final String? title;

  const NewWeekly({Key? key, this.title}) : super(key: key);

  @override
  State<NewWeekly> createState() => _NewWeeklyState();
}

class _NewWeeklyState extends State<NewWeekly> {
  List<String> listOfDays = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];
  DateTime selectedDate = DateTime.now();
  int currentDateSelectedIndex = DateTime.now().weekday - 1;
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

  stringToDate(String data) {
    var dayy = data.substring(8, 10);
    var month = data.substring(5, 7);
    var year = data.substring(0, 4);
    final intDay = int.parse(dayy);
    final intMonth = int.parse(month);
    final intYear = int.parse(year);
    final formattedDate = DateTime.utc(intYear, intMonth, intDay);
    // print("formattedDate:${formattedDate}");
    return formattedDate;
  }

  @override
  void initState() {
    // Calculate the initial index based on today's date
    int daysDifference = selectedDate.weekday - DateTime.sunday;
    if (daysDifference < 0) {
      // Adjust for daysDifference less than 0 (e.g., if today is a Monday)
      daysDifference += 7;
    }
    currentDateSelectedIndex = daysDifference;

    _flag = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrollController = ScrollController(
      initialScrollOffset: currentDateSelectedIndex * (MediaQuery.of(context).size.height * 0.05),
    );
    // print('width: ${MediaQuery.of(context).size.width * 0.103}, height: ${MediaQuery.of(context).size.height * 0.05}');
    int numberOfWeeksToDisplay = 10;

    return Column(
      children: [
//DateView
        Container(
          color: const Color(0xffFFFFFF),
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height * 0.09,
          child: ListView.separated(
            physics: const PageScrollPhysics(),
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: MediaQuery.of(context).size.width * 0.027);
            },
            itemBuilder: (BuildContext context, int index) {
              // DateTime currentDate = DateTime.now().add(Duration(days: index * 1));
              DateTime currentDate = selectedDate.subtract(Duration(days: currentDateSelectedIndex - index));
              // DateTime currentDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)).add(Duration(days: index));
              int normalizedIndex = index % 7;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentDateSelectedIndex = index;
                    // selectedDate = DateTime.now().add(Duration(days: index));
                    selectedDate = currentDate;
                    selectsDate = DateFormat('yyyy/MM/dd').format(selectedDate).toString();
                  });
                  const NewReminder();
                },
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.05,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffF9F9F9),
                        )
                      ],
                      color: currentDateSelectedIndex == index ? const Color(0xffFFE2AB) : Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.103,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: currentDateSelectedIndex == index ? Colors.white : const Color(0xffF9F9F9)),
                        child: Center(
                          child: Text(
                            currentDate.day.toString(),
                            // DateTime.now().add(Duration(days: index)).day.toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Gilroy Medium',
                                color: currentDateSelectedIndex == index ? const Color(0xff202020) : const Color(0xffA4A4A4)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          listOfDays[normalizedIndex].toString(),
                          // listOfDays[DateTime.now().add(Duration(days: index)).weekday - 1].toString(),
                          style: TextStyle(
                              fontFamily: 'Gilroy SemiBold',
                              fontSize: 15,
                              color: currentDateSelectedIndex == index ? const Color(0xff202020) : const Color(0xffA4A4A4)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: 7 * numberOfWeeksToDisplay,
          ),
        ),

        StreamBuilder(
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

            return documentData['remainder'] != null
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 4.0,
                    height: MediaQuery.of(context).size.height / 1.0,
                    child: GroupedListView<dynamic, String>(
                      elements: documentData['remainder'],
                      groupBy: (element) => element['remainderCreatedDate'],
                      order: GroupedListOrder.DESC,
                      groupSeparatorBuilder: (String val) {
                        if (val.compareTo(DateFormat('yyyy/MM/dd').format(DateTime.now()).toString()) == 0) {
                          val = 'Today\'s Activities';
                        } else {
                          val = DateFormat("dd/MM/yyyy").format(stringToDate(val));
                        }

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
                  )
                : Container(
                    color: Colors.transparent,
                    child: const Text('There is no activities for the day.'),
                  );
          },
        ),
      ],
    );
  }
}
