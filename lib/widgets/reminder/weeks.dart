
import 'package:flutter/material.dart';

class Weeks extends StatefulWidget {
  const Weeks({Key? key}) : super(key: key);

  @override
  State<Weeks> createState() => _WeeksState();
}

class _WeeksState extends State<Weeks> {

  List weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            backgroundColor: const Color(0xffFEF8F1),
            child: Text(
              weekDays.first,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xffFAFAFA),
            child: Text(
              weekDays[1],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xffFAFAFA),
            child: Text(
              weekDays[2],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xffFAFAFA),
            child: Text(
              weekDays[3],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xffFAFAFA),
            child: Text(
              weekDays[4],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xffFAFAFA),
            child: Text(
              weekDays[5],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xffFAFAFA),
            child: Text(
              weekDays[6],
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}