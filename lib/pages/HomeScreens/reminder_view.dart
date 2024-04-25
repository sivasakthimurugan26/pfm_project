import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/service/localNotification.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderLandingPage extends StatefulWidget {
  const ReminderLandingPage({Key? key}) : super(key: key);

  @override
  State<ReminderLandingPage> createState() => _ReminderLandingPageState();
}

class _ReminderLandingPageState extends State<ReminderLandingPage> {
  PageController controller = PageController();
  int pageNumber = 0;
  bool status = true;
  int selectNumber = 0;
  int channelId = 0;
  DateTime? dt;
  var remainderDate = "";
  //final NotificationManager notificationManager = NotificationManager();

  final List<int> _changeColor = [
    0xFFFFE2AB,
    0xFF89DBED,
    0xFFFBA2BF,
    0xFFFFDFCD,
    0xFF52FFCF,
    0xFFC27AD3,
  ];
  var iconvalue = false;
  var selectedIndex = -1;
  var selectedIndex1 = -1;
  var selectedIndex2 = -1;
  var selectedIndexvalue = -1;
  var selectedMonthIndexvalue = -1;
  var bgColors;
  var colorSelected;
  bool isSelected = false;
  final animationDuration = const Duration(milliseconds: 3);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? formattedScheduledDate;

  bool _isEnable = false;
  String kl = '';
  bool test = true;

  List reminderType = [
    'Select',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];
  List selectedDates = [];
  Map jsonMonth = {
    'Jan': 31,
    'Feb': 28,
    'Mar': 31,
    'Apr': 30,
    'May': 31,
    'Jun': 30,
    'Jul': 31,
    'Aug': 31,
    'Sep': 30,
    'Oct': 31,
    'Nov': 30,
    'Dec': 31
  };

  Map<String, int> monthMap = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };

  String? remType = '';
  int? monthValue;

  switchWidgets(selectedIndexTwo, bool status) {
    status = false;
    switch (selectedIndexTwo) {
      case 'Yearly':
        return Column(
          children: [yearlyView(), const SizedBox(height: 30), getMonth()],
        );
      case 'Daily':
        return Container(padding: const EdgeInsets.only(top: 50), child: getCurrentTime());
      case 'Weekly':
        return Column(
          children: [weekPerDay(), getCurrentTime()],
        );
      case 'Monthly':
        return Container(padding: const EdgeInsets.only(top: 0), height: 300, child: monthlyView());
    }
  }

  List timeFormat = [
    '-',
    'AM',
    'PM',
  ];
  List ym = [];
  bool enabledList = false;
  int? _selectedIndexTwo;
  onHandleTap() {
    setState(() {
      enabledList = !enabledList;
    });
  }

  onChanged(var position) {
    setState(() {
      _selectedIndexTwo = position;
      enabledList = !enabledList;
    });
  }

  bool isStretchedDropDown = true;

  ///
  // Week Per Days
  ///
  List weekPerDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  int weekPerDaysIndex = 0;

  ///
  /// Month View
  ///
  DateTime selectedDate = DateTime.now();

  final firstDate = DateTime(2022, 1);
  final lastDate = DateTime(2026, 1);

  ///
  /// Years Views
  ///
  List monthWords = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  List<String> monthDays = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
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
    '31',
  ];
  List<int> monthDay = [
    -1,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
  ];
  List<int> monthMinutes = [
    -1,
    00,
    01,
    02,
    03,
    04,
    05,
    06,
    07,
    08,
    09,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    58,
    59,
  ];

  int monthSelectedIndex = 0;
  int yearSelectedIndex = 0;

  String? _hasBeenPressed;

  var updateHours;
  var updateMinutes;
  var updatetimeFormat;
  var updateWeekDays;
  var updateMonthlyView;
  var updateYearlyDate;
  var updateMonths;
  var hours;
  var mins;

  @override
  void initState() {
    setState(() {
      reminderType.elementAt(1);
    });
    super.initState();

    for (int i = 1; i <= jsonMonth['Jan']; i++) {
      String formattedNumber = i.toString().padLeft(2, '0');
      ym.add(formattedNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: PageView(
                      controller: controller,
                      onPageChanged: (num) {
                        setState(
                          () {
                            pageNumber = num;
                          },
                        );
                      },
                      children: [
//Page 1
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
//Auto,Manual
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Auto',
                                    style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSelected = !isSelected;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      height: 30,
                                      width: 55,
                                      duration: animationDuration,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: const Color(0xFFFEF8F1),
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: AnimatedAlign(
                                        duration: animationDuration,
                                        alignment: isSelected ? Alignment.centerRight : Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFBE78)),
                                            child: Icon(
                                              isSelected ? Icons.chevron_right : Icons.chevron_left,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Manual',
                                    style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 35),
//Name
                              Row(
                                children: [
                                  IntrinsicWidth(
                                    child: TextField(
                                      style: const TextStyle(
                                        fontFamily: "Gilroy Medium",
                                        fontSize: 30,
                                      ),
                                      decoration: const InputDecoration(
                                          hintText: 'Name', border: InputBorder.none, hintStyle: TextStyle(color: Colors.black)),
                                      controller: _nameController,
                                      // enabled: _isEnable,
                                      onTap: () {
                                        setState(() {
                                          _isEnable = true;
                                          if (kDebugMode) {
                                            print(_nameController.text);
                                          }
                                        });
                                      },
                                      onChanged: (_) {
                                        if (kDebugMode) {
                                          print(_nameController.text);
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      'assets/svg/edit_button.svg',
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
// Description
                              TextFormField(
                                controller: _descController,
                                style: const TextStyle(fontFamily: 'Gilroy Light'),
                                minLines: 1,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  fillColor: Color(0xff979797),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color(0xffFFBE78),
                                    width: 2,
                                  )),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.3,
                              ),
//Color selection
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _changeColor.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              bgColors = _changeColor[index];
                                              selectedIndex = index;
                                              colorSelected = bgColors;
                                              // print('bgColors:$bgColors');
                                              // print('colorSelected:$colorSelected');
                                            });
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(_changeColor[index]),
                                              ),
                                              width: 50.0,
                                              child: Row(
                                                children: [
                                                  Visibility(
                                                    visible: selectedIndex == index,
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(left: 14),
                                                      child: Icon(Icons.done_outlined),
                                                    ),
                                                  ),
                                                ],
                                              )
                                              // selectedIndex == index ? const Icon(Icons.done_outlined) : Container(),
                                              ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
//Page 2
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 50,
                                  child: Center(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.075,
                                      padding: const EdgeInsets.only(left: 15, right: 15),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFEF8F1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.arrow_right_outlined,
                                            size: 34,
                                            color: Color(0xffF8BD59),
                                          ),
                                          Icon(
                                            Icons.arrow_left_outlined,
                                            size: 34,
                                            color: Color(0xffF8BD59),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.09,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  margin: const EdgeInsets.only(top: 0, bottom: 40),
                                  child: ListWheelScrollView(
                                    itemExtent: 35,
                                    physics: const FixedExtentScrollPhysics(),
                                    overAndUnderCenterOpacity: 0.5,
                                    onSelectedItemChanged: (int index) {
                                      setState(() {
                                        remType = reminderType[index];
                                      });
                                    },
                                    children: List.generate(
                                      reminderType.length,
                                      (index) => Center(
                                        child: Text(
                                          '${reminderType.elementAt(index)}',
                                          style: const TextStyle(color: Colors.black, fontSize: 23, fontFamily: 'Gilroy Bold'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: switchWidgets(remType, status),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        2,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: AnimatedContainer(
                            curve: Curves.ease,
                            duration: const Duration(microseconds: 500),
                            width: pageNumber == index ? 48 : 8,
                            height: pageNumber == index ? 17 : 8,
                            decoration: BoxDecoration(
                              color: pageNumber == index ? const Color(0xFFFFBE78) : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                pageNumber == index ? '${index + 1}/2' : '', //$index
                                style: const TextStyle(fontFamily: 'Gilroy Bold', fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffF6F6F6),
                            style: BorderStyle.solid,
                            width: 17.5,
                          ),
                          color: const Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => HomePage());
                          },
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Gilroy Medium',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 160,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 17.5,
                          ),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // getRemainder();
                            if ((_nameController.text.isNotEmpty && _descController.text.isNotEmpty && bgColors != null) &&
                                (remType == 'Yearly' || remType == 'Daily' || remType == 'Weekly' || remType == 'Monthly')) {
                              if (remType == 'Yearly') {
                                if (updateMonths != null) {
                                  remainder();
                                  // getRemainder();
                                  // Get.to(() => NewReminder());
                                  Get.to(() => HomePage(index: 1));
                                } else {
                                  snackBarWidget("Help us here", "Please update reminder yearly data.");
                                }
                              }
                              if (remType == 'Monthly') {
                                if (selectedMonthIndexvalue != -1) {
                                  remainder();
                                  // getRemainder();
                                  // Get.to(() => NewReminder());
                                  Get.to(() => HomePage(index: 1));
                                } else {
                                  snackBarWidget("Help us here", "Please update reminder monthly data.");
                                }
                              }
                              if (remType == 'Weekly') {
                                if (updateWeekDays != null && updateHours != null && updateMinutes != null && updatetimeFormat != null) {
                                  remainder();
                                  // getRemainder();
                                  Get.to(() => HomePage(index: 1));
                                } else {
                                  snackBarWidget("Help us here", "Please update reminder weekly data.");
                                }
                              }
                              if (remType == 'Daily') {
                                if (updateHours != null && updateMinutes != null && updatetimeFormat != null) {
                                  remainder();
                                  // getRemainder();
                                  Get.to(() => HomePage(index: 1));
                                } else {
                                  snackBarWidget("Help us here", "Please update reminder daily data.");
                                }
                              }
                            } else {
                              snackBarWidget("Help us here", "Please update reminder data.");
                            }
                          },
                          child: Center(
                            child: Text(
                              // status!=true?"Continue":"Done",
                              pageNumber == 0 ? "Continue" : "Done",
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy Medium',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  yearlyView() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 12,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      runSpacing: 10,
      children: List.generate(monthWords.length, (index) {
        return GestureDetector(
            onTap: () {
              var days = jsonMonth[monthWords[index]];

              ym = [];
              for (int i = 1; i <= days; i++) {
                String formattedNumber = i.toString().padLeft(2, '0');
                ym.add(formattedNumber);
              }

              setState(() {
                updateMonths = monthWords[index];
                selectedDates = ym;
                selectedIndex1 = index;
              });
            },
            child: Container(
                height: MediaQuery.of(context).size.height * 0.038,
                width: MediaQuery.of(context).size.width * 0.18,
                decoration: BoxDecoration(
                    color: selectedIndex1 == index ? const Color(0xffFFBE78) : const Color(0xffF6F6F6),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monthWords[index],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Visibility(
                        visible: selectedIndex1 == index,
                        child: const SizedBox(
                          width: 15,
                        )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex1 = -1;
                        });
                      },
                      child: Visibility(
                        visible: selectedIndex1 == index,
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                )));
      }),
    );
  }

  getMonth() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.31,
      child: selectedIndex1 != -1
          ? GridView.builder(
              itemCount: selectedDates.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.7, crossAxisCount: 6, mainAxisSpacing: 5, crossAxisSpacing: 5),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex2 = index;
                      yearSelectedIndex = index;
                      updateYearlyDate = ym.elementAt(index);
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: selectedIndex2 == index ? const Color(0xffF8BD59) : const Color(0xffF6F6F6),
                    child: Text(
                      ym.elementAt(index).toString(),
                      style: const TextStyle(color: Colors.black, fontFamily: 'Gilroy Medium', fontSize: 15),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }

  monthlyView() {
    return GridView.builder(
      itemCount: monthDays.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.7, crossAxisCount: 6, mainAxisSpacing: 10, crossAxisSpacing: 5),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              monthSelectedIndex = index;
              selectedMonthIndexvalue = index;
              updateMonthlyView = monthDays.elementAt(index);
            });
          },
          child: CircleAvatar(
            backgroundColor: selectedMonthIndexvalue == index ? const Color(0xffFFBE78) : const Color(0xffF6F6F6),
            child: Text(
              monthDays.elementAt(index).toString(),
              style: const TextStyle(color: Colors.black, fontFamily: 'Gilroy Medium', fontSize: 15),
            ),
          ),
        );
      },
    );
  }

  weekPerDay() {
    return SizedBox(
      width: 350,
      height: 200,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 30,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        runSpacing: 30,
        children: List.generate(weekPerDays.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                updateWeekDays = weekPerDays[index];
                selectedIndexvalue = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedIndexvalue == index ? const Color(0xffFFBE78) : const Color(0xffF6F6F6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  weekPerDays[index],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Gilroy ExtraBold.ttf',
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  getCurrentTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  height: 50,
                  width: 100,
                  // width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    color: const Color(0xffFEF8F1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.arrow_right_outlined,
                        size: 34,
                        color: Color(0xffF8BD59),
                      ),
                      Icon(
                        Icons.arrow_left_outlined,
                        size: 34,
                        color: Color(0xffF8BD59),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              width: 110,
              child: ListWheelScrollView(
                itemExtent: 40,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.5,
                children: List.generate(monthDay.length, (index) {
                  final monthValue = monthDay[index];
                  final displayValue = monthValue == -1 ? "-" : monthValue.toString().padLeft(2, '0');
                  return Center(
                    child: Text(
                      displayValue,
                      style: const TextStyle(color: Colors.black, fontSize: 15.5, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
                onSelectedItemChanged: (minuteValue) {
                  updateHours = monthDay[minuteValue];
                },
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xffFEF8F1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.arrow_right_outlined,
                        size: 34,
                        color: Color(0xffF8BD59),
                      ),
                      Icon(
                        Icons.arrow_left_outlined,
                        size: 34,
                        color: Color(0xffF8BD59),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              width: 150,
              child: ListWheelScrollView(
                itemExtent: 40,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.5,
                children: List.generate(monthMinutes.length, (index) {
                  final minutesValue = monthMinutes[index];
                  final displayValue = minutesValue == -1 ? "-" : minutesValue.toString().padLeft(2, '0');
                  return Center(
                    child: Text(
                      displayValue,
                      style: const TextStyle(color: Colors.black, fontSize: 15.5, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
                onSelectedItemChanged: (value) {
                  updateMinutes = monthMinutes[value];
                },
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xffFEF8F1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.arrow_right_outlined,
                        size: 34,
                        color: Color(0xffF8BD59),
                      ),
                      Icon(
                        Icons.arrow_left_outlined,
                        size: 34,
                        color: Color(0xffF8BD59),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: ListWheelScrollView(
                itemExtent: 40,
                physics: const FixedExtentScrollPhysics(),
                overAndUnderCenterOpacity: 0.5,
                children: List.generate(
                    timeFormat.length,
                    (index) => Center(
                          child: Text(
                            timeFormat.elementAt(index),
                            style: const TextStyle(color: Colors.black, fontSize: 15.5, fontWeight: FontWeight.bold),
                          ),
                        )),
                onSelectedItemChanged: (value) {
                  updatetimeFormat = timeFormat[value];
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  getRemainderEventType() {
    if (remType == 'Yearly') {
      return 'Yearly';
    } else if (remType == 'Repeat') {
      return 'Repeat';
    } else if (remType == 'Weekly') {
      return 'Weekly';
    } else if (remType == 'Month') {
      return 'Month';
    } else {
      return 'Daily';
    }
  }

  getEventInfo() {
    remainderDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
    var remainder = Random();
    var random = remainder.nextInt(5000) + 1000;
    var remainderNumber = 'Rem$random';
    String remainderIcon;
    if (isSelected == true) {
      remainderIcon = 'assets/images/gloves.png';
    } else {
      remainderIcon = 'assets/images/automation.png';
    }

    return {
      'remainderDate': remainderDate,
      'remainderId': remainderNumber,
      'remainderName': _nameController.text,
      'remainderDesc': _descController.text,
      'remainderIcon': remainderIcon,
      'remainderColor': bgColors.toString(),
      'remainderCategory': 'Active',
    };
  }

  getRemainderDataInfo() {
    String remainderType;
    if (remType == 'Yearly') {
      remainderType = 'Yearly';
    } else if (remType == 'Repeat') {
      remainderType = 'Repeat';
    } else if (remType == 'Weekly') {
      remainderType = 'Weekly';
    } else if (remType == 'monthly') {
      remainderType = 'Monthly';
    } else {
      remainderType = 'Daily';
    }

    var reminderTime = '$updateHours:$updateMinutes $updatetimeFormat';

    switch (remType) {
      case 'Daily':
        return {
          'remainderTime': reminderTime,
        };
      case 'Weekly':
        return {
          'remainderTime': reminderTime,
          'remainderDay': updateWeekDays,
        };
      case 'Yearly':
        return {'remainderMonth': updateMonths, 'reminderDate': updateYearlyDate, 'reminderTime': '9:00 AM'};
      case 'Monthly':
        return {'remainderMonthDate': updateMonthlyView, 'reminderTime': '9:00 AM'};
      case 'Repeat':
        return {'Repeat': 'Repeat Activities'};
    }
    return remainderType;
  }

  remainder() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    Remainder userModel = Remainder();

    await firebaseFirestore.collection("UserData").doc(user?.uid).update(userModel.toMap(
          DateFormat('yyyy/MM/dd').format(DateTime.now()), // to get the remainderCreatedDate
          getRemainderEventType(),
          getEventInfo(),
          getRemainderDataInfo(),
        ));

    var data = getRemainderDataInfo();
    print('TypeInfo: $data');

    final now = tz.TZDateTime.now(tz.local);
    var monthlyTime;

    if (remType == 'Daily' || remType == 'Weekly') {
      final reminderTime = data['remainderTime'];
      final timeParts = reminderTime.split(' ')[0].split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final isPM = reminderTime.contains('PM');

      if (isPM && hour < 12) {
        hour += 12;
      } else if (!isPM && hour == 12) {
        hour = 0;
      }

      final scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(scheduledDate);
      formattedScheduledDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(formattedDate);
      // print('reminderTYpe: $remType , reminderTime: $formattedScheduledDate, Day: ${data['remainderDay']}');
    } else if (remType == 'Monthly') {
      DateFormat inputFormat = DateFormat.jm();
      DateTime dateTime = inputFormat.parse(data['reminderTime']);
      final scheduledDate = DateTime(now.year, now.month, now.day, dateTime.hour, dateTime.minute);
      monthlyTime = scheduledDate;
    } else if (remType == 'Yearly') {
      monthValue = monthMap[data['remainderMonth']];
      DateFormat inputFormat = DateFormat.jm();
      DateTime dateTime = inputFormat.parse(data['reminderTime']);
      final scheduledDate = DateTime(now.year, now.month, now.day, dateTime.hour, dateTime.minute);
      monthlyTime = scheduledDate;
      // print('monthValue: $monthValue , $scheduledDate');
    }

    switch (remType) {
      case 'Daily':
        NotificationService().scheduleRecurringNotification(
            id: 0,
            title: _nameController.text,
            body: _descController.text,
            payload: 'Daily Notification',
            scheduledDateTime: formattedScheduledDate!,
            reminderType: remType!);
        break;
      case 'Weekly':
        NotificationService().scheduleWeeklyNotification(
            id: 1,
            title: _nameController.text,
            body: _descController.text,
            payload: 'Weekly Notification',
            dayOfWeek: data['remainderDay'],
            scheduledTime: formattedScheduledDate!,
            reminderType: remType!);
        break;
      case 'Monthly':
        NotificationService().scheduleMonthlyNotification(
            id: 2,
            title: _nameController.text,
            body: _descController.text,
            payload: 'Monthly Notification',
            dayOfMonth: int.parse(data['remainderMonthDate']),
            scheduledTime: monthlyTime,
            reminderType: remType!);
        break;
      case 'Yearly':
        NotificationService().scheduleYearlyNotification(
            id: 3,
            title: _nameController.text,
            body: _descController.text,
            payload: 'Monthly Notification',
            monthOfYear: monthValue!,
            dayOfMonth: int.parse(data['reminderDate']),
            scheduledTime: monthlyTime,
            reminderType: remType!);
    }

    addNotification();
  }

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }

  addNotification() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();

    firebaseFirestore.collection("UserData").doc(user?.uid).update(userModel.notification(_nameController.text, remType!, DateTime.now()));
  }

  getRemainder() async {
    List<Map<String, dynamic>> remainderDataList = [];
    var snapShot = await FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots();
    snapShot.forEach((element) {
      for (int i = 0; i < element.data()!['remainder'].length; i++) {
        Map<String, dynamic> remainderData = {
          'remainderEventType': element.data()!['remainder'][i]['remainderEventType'],
          'remainderDataInfo': element.data()!['remainder'][i]['remainderDataInfo'],
        };
        remainderDataList.add(remainderData);

        // print('RemData: $remainderDataList');
      }
    });
  }
}
