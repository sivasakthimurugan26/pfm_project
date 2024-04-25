import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class NewMonthPage extends StatefulWidget {
  const NewMonthPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NewMonthPage> createState() => _NewMonthPageState();
}

class _NewMonthPageState extends State<NewMonthPage> {
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
    //print("formattedDate:${formattedDate}");
    return formattedDate;
  }

  dayFormat(DateTime d) {
    final DateTime now = d;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    //print("formatted:${formatted}");
    return formatted;
  }

  loadEvents() async {
    var snapShot = await FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots();
    snapShot.forEach((element) {
      for (int i = 0; i < element.data()!['remainder'].length; i++) {
        final day = stringToDate(element.data()!['remainder'][i]['remainderCreatedDate']);
        // print('snapShotss :${element.data()!['remainder'][i]}');
        setState(() {
          Map event = element.data()!['remainder'][i];
          print('event :${event}');
          if (_events[day] == null) {
            _events[day] = [];
          }
          _events[day]!.add(event);
        });
        // print('_events[day] :${_events[day]}');
      }
    });
  }

  List _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  DateTime _focusedDay = DateTime.now();
  DateTime _firstDay = DateTime.now().subtract(const Duration(days: 100));
  DateTime _lastDay = DateTime.now().add(const Duration(days: 100));
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
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
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
            if (_events[_selectedDay] != null)
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
                                    color: Color(int.parse(event['eventInfo']['remainderColor'])),
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
            if (_events[_selectedDay] == null)
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: const Text('No activity for the day'),
              )
          ],
        ),
      ),
    );
  }
}
