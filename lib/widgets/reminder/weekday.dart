
import 'package:flutter/material.dart';

class WeekDay extends StatefulWidget {
  @override
  State<WeekDay> createState() => _WeekDayState();
}

class _WeekDayState extends State<WeekDay> {
  List weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  List monthWords = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List monthDays = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  ];
  bool _hasBeenPressed = false;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 350,
                height: 200,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 50,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 30,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xffFEF8F1),
                      child: Text(
                        weekDays.first,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Color(0xffFAFAFA),
                      child: Text(
                        weekDays[1],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Color(0xffFAFAFA),
                      child: Text(
                        weekDays[2],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Color(0xffFAFAFA),
                      child: Text(
                        weekDays[3],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Color(0xffFAFAFA),
                      child: Text(
                        weekDays[4],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Color(0xffFAFAFA),
                      child: Text(
                        weekDays[5],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Color(0xffFAFAFA),
                      child: Text(
                        weekDays[6],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 400,
                child: GridView.builder(
                  itemCount: monthDays.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: selectedIndex == index
                            ? Color(0xffFEF8F1)
                            : Color(0xffFAFAFA),
                        child: Text(
                          monthDays.elementAt(index),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}