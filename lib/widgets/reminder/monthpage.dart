import 'dart:collection';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance_management/widgets/reminder/dropdown.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../pages/HomeScreens/reminder_view.dart';
import 'customdialogbox.dart';

class MonthPage extends StatefulWidget {
  const MonthPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }

  stringToDate(String data) {
    var dayy = data.substring(8, 10);
    var month = data.substring(5, 7);
    var year = data.substring(0, 4);
    final intDay = int.parse(dayy);
    final intMonth = int.parse(month);
    final intYear = int.parse(year);
    final formattedDate = DateTime.utc(intYear, intMonth, intDay);
    print("formattedDate:${formattedDate}");
    return formattedDate;
  }

  dayFormat(DateTime d) {
    final DateTime now = d;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    print("formatted:${formatted}");
    return formatted;
  }

  loadEvents() async {
    var snapShot = await FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots();
    snapShot.forEach((element) {
      element.data()!['remainder'];
      for (int i = 0; i < element.data()!['remainder'].length; i++) {
        final day = stringToDate(element.data()!['remainder'][i]['remainderCreatedDate']);
        print('snapShotss :${element.data()!['remainder'][i]}');
        Map event = element.data()!['remainder'][i];
        print('event :${event}');
        print('object type: ${element.data()!['remainder'][i]['eventInfo']}');
        // Map event ={'eventInfo': {'remainderColor': '4283629519', 'remainderDesc': 'flutter', 'remainderDate': '2023/03/23',
        //   'remainderName': 'dart', 'remainderIcon': 'assets/images/gloves.png', 'remainderId': 'Rem1090', 'remainderCategory': 'Active'},
        //   'remainderDataInfo': {'remainderFormat': 'AM', 'remainderMinutes': '3', 'remainderHour': '3'}, 'remainderEventType': 'Daily',
        //   'remainderCreatedDate': '2023/03/23'};
        // print('snapShot :${event}');
        if (_events[day] == null) {
          _events[day] = [];
        }
        _events[day]!.add(event);

        // print('object type: ${element.data()!['remainder'][i]['remainderCreatedDate'].runtimeType}');
        // print('day: ${intDay}');
        // print('month: ${intMonth}');
        // print('year: ${intYear}');
        // print('date: ${day}');
        //
        // print('date: ${day.runtimeType}');
        //
        // print('day: ${intDay.runtimeType}');
        // print('snapShot :${element.data()!['remainder']}');
        print('_events[day] :${_events[day]}');
        //print('snapShot :${event}');
      }
    });
  }

  List _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.now().subtract(const Duration(days: 100));
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 100));
  DateTime? _selectedDay;
  CalendarFormat format = CalendarFormat.month;
  late Map<DateTime, List> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    print(LinkedHashMap().length);
    loadEvents();
    _selectedDay = DateTime.now();
    super.initState();
    dayFormat(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            // height: 800,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffFFFFFF),
                  padding: const EdgeInsets.only(left: 110),
                  child: Row(
                    children: [
                      Container(
                          transform: Matrix4.translationValues(0, -22, 0),
                          child: const Text('Reminder',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontFamily: 'Gilroy Medium',
                              ))),
                      // const DropDown(title: 'Month'),
                      const DropDown(
                        title: 'Month',
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                    // border: Border(
                    //   left: BorderSide(color: Colors.black),
                    //   right: BorderSide(color: Colors.black),
                    //   top: BorderSide(color: Colors.black),
                    //   bottom: BorderSide(color: Colors.black),
                    // ),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffE5E5E5),
                        offset: Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    focusedDay: _focusedDay,
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat _format) {
                      if (format != _format) {
                        setState(() {
                          format = _format;
                        });
                      }
                    },
                    eventLoader: _getEventsForTheDay,
                    headerStyle: HeaderStyle(
                      titleTextStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Gilroy SemiBold',
                      ),
                      leftChevronIcon: Container(
                        decoration: const BoxDecoration(color: Color(0xffFFBE78), shape: BoxShape.circle),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                      ),
                      rightChevronIcon: Container(
                        decoration: const BoxDecoration(color: Color(0xffFFBE78), shape: BoxShape.circle),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                      formatButtonVisible: false,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      formatButtonTextStyle: const TextStyle(
                        color: Colors.transparent,
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      isTodayHighlighted: false,
                      todayDecoration: BoxDecoration(
                        color: Color(0xffFFBE78),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xffFFBE78),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Color(0xffFBA2BF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                ),
                ..._getEventsForTheDay(_selectedDay!).map((event) => Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            dayFormat(DateTime.now()) == dayFormat(stringToDate(event['remainderCreatedDate']))
                                ? 'Today Activity'
                                : event['remainderCreatedDate'],
                            style: const TextStyle(fontFamily: 'Gilray Medium', fontSize: 20),
                          ),
                        ),
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
                                      //print('object type: ${element.data()!['remainder'][i]['eventInfo']['remainderName']}');
                                      color: Color(int.parse(event['eventInfo']['remainderColor'])),
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
                                          event['eventInfo']['remainderName'],
                                          style: const TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Color(0xff181818)),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          event['eventInfo']['remainderDesc'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Gilroy Medium',
                                            color: Color(0xffCACACA),
                                          ),
                                        ),
                                      ],
                                    )),
                                    Image.asset(
                                      event['eventInfo']['remainderIcon'],
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
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 3,
                      sigmaY: 3,
                    ),
                    child: CustomDialogBox());
              });
        },
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReminderLandingPage()),
            );
          },
          label: const Text(
            'New',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Gilroy Medium',
              color: Color(0xffAFAFAF),
            ),
          ),
          // isExtended: true,
          icon: SvgPicture.asset('assets/svg/inactiveRemMenu.svg'),
          backgroundColor: Colors.black,
          foregroundColor: const Color(0xffAFAFAF),
        ),
      ),
    );
  }
}
