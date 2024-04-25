
import 'package:flutter/material.dart';

class Years extends StatefulWidget {
  const Years({Key? key}) : super(key: key);

  @override
  State<Years> createState() => _YearsState();
}

class _YearsState extends State<Years> {
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

  int selectedIndex = 0;
  String? _hasBeenPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: GridView.builder(
            itemCount: monthDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  backgroundColor: selectedIndex == index ? const Color(0xffFEF8F1) : const Color(0xffFAFAFA),
                  child: Text(
                    monthDays.elementAt(index),
                    style: const TextStyle(color: Colors.black, fontFamily: 'Gilroy Medium', fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
