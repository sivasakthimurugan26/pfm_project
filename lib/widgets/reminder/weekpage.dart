import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_finance_management/widgets/reminder/customdialogbox.dart';

import '../../pages/HomeScreens/reminder_view.dart';
import 'dropdown.dart';
import 'weekly.dart';


class WeekPage extends StatefulWidget {
  const WeekPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: const Color(0xffFFFFFF),
                padding: const EdgeInsets.only(left: 110),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        transform: Matrix4.translationValues(0, -22, 0),
                        // padding: EdgeInsets.only(top: 0),

                        child: const Text('Reminder',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontFamily: 'Gilroy Medium',
                            ))),
                    // MyListView(title: widget.title,),

                    DropDown(
                      title: widget.title,
                    ),
                  ],
                ),
              ),

              Container(
                transform: Matrix4.translationValues(0, -30, 0),
                child: const Weekly(),
              ),

              // WeekListView(),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 130,
        height: 55,
        margin: const EdgeInsets.only(bottom: 10, right: 10),
        child: GestureDetector(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogBox();
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
      ),
    );
  }
}
