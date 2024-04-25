
import 'package:flutter/material.dart';

class Monthly extends StatefulWidget {
  const Monthly({Key? key}) : super(key: key);

  @override
  State<Monthly> createState() => _MonthlyState();
}

class _MonthlyState extends State<Monthly> {
  DateTime selectedDate = DateTime.now();

  final firstDate = DateTime(2022, 1);
  final lastDate = DateTime(2023, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CalendarDatePicker(
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate,
        onDateChanged: (newDate){
          setState(() {
            selectedDate = newDate;
            print(newDate.day);
          });
        },
      ),
    );
  }
}