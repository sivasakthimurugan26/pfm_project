import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/pages/HomeScreens/reminder_view.dart';
import 'package:personal_finance_management/pages/Reminder/new_month.dart';
import 'package:personal_finance_management/pages/Reminder/new_mylistview.dart';
import 'package:personal_finance_management/pages/Reminder/new_weekly.dart';
import 'package:personal_finance_management/widgets/reminder/customdialogbox.dart';
import 'package:personal_finance_management/widgets/reminder/expanded.dart';

class NewReminder extends StatefulWidget {
  const NewReminder({
    Key? key,
  }) : super(key: key);

  @override
  State<NewReminder> createState() => _NewReminderState();
}

class _NewReminderState extends State<NewReminder> {
  bool isStrechedDropDown = false;
  bool Allvisible = true;
  bool Weekvisible = false;
  bool Monthvisible = false;
  bool isExtended = false;
  bool openAppBar = true;
  bool closeTopContainer = false;

  String title = 'All';
  List weekDays = [
    'All',
    'Week',
    'Month',
  ];
  final reminderLayerLink = LayerLink();
  OverlayEntry? reminderEntry;
  bool reminderIsStretchedDropDown = false;
  String title1 = 'All Reminder';
  bool isScrolled = true;
  dynamic categoryListCount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(title1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontFamily: 'Gilroy Medium',
            )),
        centerTitle: true,
        actions: [
          CompositedTransformTarget(
            link: reminderLayerLink,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Stack(children: [
                SizedBox(
                  width: 140,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                              border: const Border(
                                top: BorderSide(color: Color(0xffFFF0D3)),
                                left: BorderSide(color: Color(0xffFFF0D3)),
                                right: BorderSide(color: Color(0xffFFF0D3)),
                                bottom: BorderSide(color: Color(0xffFFF0D3)),
                              ),
                              borderRadius: reminderIsStretchedDropDown
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    )
                                  : const BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(right: 5),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(24)),
                                  ),
                                  constraints: const BoxConstraints(
                                    minHeight: 40,
                                    minWidth: double.infinity,
                                  ),
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        reminderIsStretchedDropDown = !reminderIsStretchedDropDown;
                                        WidgetsBinding.instance.addPostFrameCallback((_) => reminderOverlay());
                                        //accountIsShowOverlay = true;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Image.asset('assets/images/calender.png', width: 18, height: 18, color: const Color(0xffFF9E36)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            title,
                                            style: const TextStyle(fontSize: 16, fontFamily: ' Gilroy Medium', color: Color(0xff5E5E5E)),
                                          ),
                                        ),
                                        Icon(
                                          reminderIsStretchedDropDown ? Icons.expand_less : Icons.expand_more,
                                          color: const Color(0xff444444),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xffFFFFFF),
      // backgroundColor: Colors.blue,
      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.reverse) {
                  setState(() {
                    isExtended = true;
                    // status = false;
                    openAppBar = false;
                    closeTopContainer = true;
                  });
                } else if (notification.direction == ScrollDirection.forward) {
                  setState(() {
                    isExtended = false;
                    // status = true;
                    openAppBar = true;
                    closeTopContainer = false;
                  });
                }
                return true;
              },
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    Visibility(
                        visible: true,
                        child: Allvisible
                            ? const NewMyListView()
                            : Weekvisible
                                ? const NewWeekly()
                                : Monthvisible
                                    ? const NewMonthPage()
                                    : const Text('error')),
                  ],
                ),
              ),
            ),
          ],
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
            Get.to(() => const ReminderLandingPage());
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
          icon: SvgPicture.asset(
            'assets/svg/inactiveRemMenu.svg',
          ),
          backgroundColor: Colors.black,

          foregroundColor: const Color(0xffAFAFAF),
        ),
      ),
    );
  }

  void reminderHideOverlay() {
    reminderEntry?.remove();
    reminderEntry = null;
  }

  void reminderOverlay() {
    reminderEntry = OverlayEntry(
      builder: (context) => Positioned(
          width: 150,
          child:
              CompositedTransformFollower(link: reminderLayerLink, showWhenUnlinked: false, offset: const Offset(0, 57), child: reminderDropdown())),
    );
    final overlay = Overlay.of(context);
    overlay.insert(reminderEntry!);
  }

  Widget reminderDropdown() => Material(
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Color(0xffFFF0D3)),
              left: BorderSide(color: Color(0xffFFF0D3)),
              right: BorderSide(color: Color(0xffFFF0D3)),
              bottom: BorderSide(color: Color(0xffFFF0D3)),
            ),
          ),
          child: ExpandedSection(
            expand: reminderIsStretchedDropDown,
            height: 100,
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 10),
                shrinkWrap: true,
                itemCount: weekDays.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          title = weekDays.elementAt(index);
                          if (weekDays.elementAt(index) == 'All') {
                            title1 = 'All Reminder';
                            Allvisible = true;
                            reminderIsStretchedDropDown = false;
                          } else if (weekDays.elementAt(index) == 'Week') {
                            title1 = 'Reminder';
                            Monthvisible = false;
                            Allvisible = false;
                            Weekvisible = true;
                            reminderIsStretchedDropDown = false;
                          } else if (weekDays.elementAt(index) == 'Month') {
                            title1 = 'Reminder';
                            Allvisible = false;
                            Weekvisible = false;
                            Monthvisible = true;
                            reminderIsStretchedDropDown = false;
                          } else {
                            Allvisible = false;
                            Weekvisible = false;
                            Monthvisible = true;
                            reminderIsStretchedDropDown = false;
                          }
                          reminderIsStretchedDropDown = false;
                          reminderHideOverlay();
                        });
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/images/calender.png', width: 18, height: 18, color: const Color(0xffFF9E36)),
                          const SizedBox(
                            width: 15,
                          ),
                          DefaultTextStyle(
                            style: const TextStyle(fontSize: 16, fontFamily: ' Gilroy Medium', color: Color(0xff5E5E5E)),
                            child: Text(
                              weekDays.elementAt(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      );
}
