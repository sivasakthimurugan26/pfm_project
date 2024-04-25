import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_management/constants/svg_constant.dart';
import 'package:personal_finance_management/pages/notification/notifcationPage.dart';
import 'package:personal_finance_management/pages/profile/profile_view.dart';
import 'package:personal_finance_management/pages/transactions/new_transaction.dart';
import 'package:personal_finance_management/service/firebase_query.dart';
import 'package:personal_finance_management/widgets/edit_popup/popup_box.dart';
import 'package:personal_finance_management/widgets/list_card_view_start.dart';
import 'package:personal_finance_management/widgets/list_card_view_stop.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onBoarding/add_account.dart';
import '../onBoarding/add_custom_category.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var boxColor;
  var switchColor;
  var switchButtonOn;
  var switchButtonOff;
  double budgetAvailableAmount = 1;
  double budgetAllocatedAmount = 1;

  calculatePercentage(double budgetAvailableAmount, double budgetAllocatedAmount) async {
    double percent = budgetAvailableAmount / budgetAllocatedAmount * 100;
    // print('percent:$percent');
    // print('currentAmount:$budgetAvailableAmount');
    // print('totalAmount:$budgetAllocatedAmount');
    if (percent >= 75.00) {
      boxColor = const Color(0xffE0FFF0);
      switchColor = const Color(0xff85E1B5);
      switchButtonOn = swtichOnIconGreen;
      switchButtonOff = swtichOffIconGreen;
    } else if (percent <= 75.00 && percent >= 40.00) {
      boxColor = const Color(0xffFFF3DC);
      switchColor = const Color(0xffFFBA41);
      switchButtonOn = swtichOnIconYellow;
      switchButtonOff = swtichOffIconYellow;
    } else if (percent < 40.00) {
      boxColor = const Color(0xffFFE3DE);
      switchColor = const Color(0xffFF7B65);
      switchButtonOn = swtichOnIconRed;
      switchButtonOff = swtichOffIconRed;
    }
// print('percent: $percent');
  }

  bool isExtended = false;
  int _currentIndex = 0;

  var editButton = 'assets/svg/edit_button.svg';
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  bool openAppBar = true;
  bool editButtonVisible = false;
  bool status = true;
  bool stopButton = true;
  bool startButton = false;

  bool switchValue = true;
  int toggleValue = 0;
  String togValue = 'Available';

  List<Map<String, dynamic>> accountList = [];
  String budgetAvailable = '0';
  String budgetAllocated = '0';
  String? totalFund;
  final amountFormat = NumberFormat("#,##0.0", "en_US");

  final List items = [];

  final AuthService auth = AuthService();

  List<String> get _listTextTabToggle => ["Available", "Spent"];

  int _tabTextIndexSelected = 0;

  _logOut() {
    auth.logOut();
  }

  @override
  void initState() {
    super.initState();
    calculatePercentage(budgetAvailableAmount, budgetAllocatedAmount);
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 0;
        openAppBar = controller.offset < 50;
      });
    });
  }

  bool isScrolled = true;
  dynamic categoryListCount;

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }

  query() {
    FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots();
  }

  getTotalFund(List accounts) {
    List amountData = [];
    double convertAmount;

    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i]['accountType'] == 'Savings' || accounts[i]['accountType'] == 'Cash') {
        amountData.add(double.parse(accounts[i]['amountBalance'].replaceAll(',', '')));
      }
    }
    convertAmount = amountData.reduce((value, element) => value + element);
    totalFund = amountFormat.format(convertAmount);
    if (kDebugMode) {
      print('totalFund: $totalFund');
    }
    return totalFund;
  }

  String? value;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double cardHeight = size.height * 0.37;
    double appBarHeight = size.height * 0.13;
    return Scaffold(
      floatingActionButton: status
          ? FloatingActionButton.extended(
              shape: isExtended ? const CircleBorder() : null,
              isExtended: isScrolled,
              label: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
                  opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                ),
                child: isExtended
                    ? SvgPicture.asset(
                        'assets/svg/floatIcon.svg',
                      )
                    : Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/floatIcon.svg',
                          ),
                          const Text(
                            ' New',
                            style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20, color: Color(0xffB0B0B0)),
                          ),
                        ],
                      ),
              ),
              backgroundColor: Colors.black,
              elevation: 0,
              onPressed: () {
                showGeneralDialog(
                  barrierDismissible: true,
                  barrierLabel: '',
                  barrierColor: Colors.black38,
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (ctx, anim1, anim2) => const PopUpBox(),
                  transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                    child: FadeTransition(
                      opacity: anim1,
                      child: child,
                    ),
                  ),
                  context: context,
                );
              },
            )
          : null,
      body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                isExtended = true;
                openAppBar = false;
                closeTopContainer = true;
              });
            } else if (notification.direction == ScrollDirection.forward) {
              setState(() {
                isExtended = false;
                openAppBar = true;
                closeTopContainer = false;
              });
            }
            return true;
          },
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          AnimatedOpacity(
                            opacity: openAppBar ? 0 : 1,
                            duration: const Duration(milliseconds: 500),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: size.width,
                              alignment: Alignment.topCenter,
                              height: openAppBar ? 0 : appBarHeight * 1.4,
                              child: SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient:
                                        LinearGradient(colors: [boxColor, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const SizedBox(
                                            width: 10,
                                          ),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              const Text(
                                                '\u{20B9} ',
                                                style: TextStyle(fontFamily: 'Gilroy Medium', color: Color(0xff9c9c9c)),
                                              ),
                                              Text(
                                                totalFund.toString(),
                                                style: const TextStyle(fontFamily: 'Gilroy Bold', fontSize: 21),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: switchColor,
                                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                  child: Text('Total Fund', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 15)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                categoryListCount.toString(),
                                                style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 12),
                                              ),
                                              const Text(
                                                'Items',
                                                style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                        status == true
                                            ? Container(
                                                decoration: BoxDecoration(boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(1, 3),
                                                    blurRadius: 5,
                                                    color: Colors.black.withOpacity(0.15),
                                                  ),
                                                ], color: const Color(0xffffffff), borderRadius: const BorderRadius.all(Radius.circular(30))),
                                                child: FlutterToggleTab(
                                                  width: Get.width * 0.17,
                                                  height: Get.width * 0.13, // width in percent
                                                  borderRadius: 30,
                                                  selectedIndex: toggleValue,
                                                  selectedBackgroundColors: [boxColor],
                                                  unSelectedBackgroundColors: const [Colors.white],
                                                  selectedTextStyle: const TextStyle(
                                                    fontFamily: 'Gilroy Medium',
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                  ),
                                                  unSelectedTextStyle: const TextStyle(
                                                    fontFamily: 'Gilroy Medium',
                                                    fontSize: 17,
                                                    color: Color(0xff848484),
                                                  ),
                                                  labels: _listTextTabToggle,
                                                  selectedLabelIndex: (index) {
                                                    setState(() {
                                                      toggleValue = index;
                                                    });
                                                  },
                                                  isScroll: false,
                                                  isShadowEnable: false,
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          SharedPreferences isOnboarding = await SharedPreferences.getInstance();
                                                          isOnboarding.setBool('isOnboarding', true);
                                                          Get.to(() => const AddCustomCategoryPage());
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey.withOpacity(0.2),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                                offset: const Offset(0, 3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(20.0),
                                                            child: SvgPicture.asset(
                                                              category,
                                                              width: 25,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.to(() => NewTransaction());
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey.withOpacity(0.2),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                                offset: const Offset(0, 3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(20.0),
                                                            child: SvgPicture.asset(transaction),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Get.to(() => const AddAccountType(
                                                                fromAccountPage: false,
                                                              ));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey.withOpacity(0.2),
                                                                spreadRadius: 1,
                                                                blurRadius: 5,
                                                                offset: const Offset(0, 3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(20.0),
                                                            child: SvgPicture.asset(account),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [Text('Category'), Text('Transaction'), Text('Account')],
                                                  )
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: closeTopContainer ? 0 : 1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: size.width,
                              alignment: Alignment.topCenter,
                              height: closeTopContainer ? 0 : cardHeight,
                              child: SingleChildScrollView(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 25),
                                      child: StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots(),
                                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else {
                                              if (snapshot.hasError) {
                                                return const Text("error");
                                              } else {
                                                final DocumentSnapshot? document = snapshot.data;
                                                final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;

                                                accountList = (documentData['accounts'] as List)
                                                    .map((accountList) => accountList as Map<String, dynamic>)
                                                    .toList();
                                                budgetAvailable = (documentData['budget']['availableAmount']);
                                                budgetAllocated = (documentData['budget']['allocatedAmount']);
                                                // print('budgetAllocated:$budgetAllocated');
                                                budgetAvailableAmount = budgetAvailable.contains(",")
                                                    ? double.parse(budgetAvailable.replaceAll(',', ''))
                                                    : double.parse(budgetAvailable);
                                                budgetAllocatedAmount = budgetAllocated.contains(",")
                                                    ? double.parse(budgetAllocated.replaceAll(',', ''))
                                                    : double.parse(budgetAllocated);
                                                calculatePercentage(budgetAvailableAmount, budgetAllocatedAmount);

// getTotalFund(accountList);
                                                List amountData = [];
                                                double convertAmount;

                                                for (int i = 0; i < accountList.length; i++) {
                                                  if (accountList[i]['accountType'] == 'Savings' || accountList[i]['accountType'] == 'Cash') {
                                                    amountData.add(double.parse(accountList[i]['amountBalance'].replaceAll(',', '')));
                                                  }
                                                }
                                                convertAmount = amountData.reduce((value, element) => value + element);
                                                totalFund = amountFormat.format(convertAmount);

                                                return SizedBox(
                                                  height: cardHeight,
                                                  child: Stack(
                                                    alignment: Alignment.topCenter,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                                colors: [boxColor, Colors.white],
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter),
                                                            border: Border.all(
                                                              color: const Color(0xffE5E5E5),
                                                            ),
                                                            borderRadius: const BorderRadius.all(Radius.circular(40))),
                                                        height: cardHeight - 50,
                                                        child: Padding(
                                                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                          child: Stack(
                                                            alignment: Alignment.center,
                                                            children: [
// Name and Notification Icon
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          Get.to(() => const ProfilePage(),
                                                                              arguments: [documentData['name']],
                                                                              duration: const Duration(milliseconds: 500),
                                                                              transition: Transition.leftToRightWithFade);
                                                                        },
                                                                        child: StreamBuilder(
                                                                            stream: FirebaseFirestore.instance
                                                                                .collection('UserData')
                                                                                .doc(user?.uid)
                                                                                .snapshots(),
                                                                            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                                              final document = snapshot.data;
                                                                              if (snapshot.data == null) {
                                                                                return const Center(
                                                                                  child: CircularProgressIndicator(),
                                                                                );
                                                                              }

                                                                              return Padding(
                                                                                padding: const EdgeInsets.only(top: 10),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    (document!['profileImage'] == null)
                                                                                        ? SvgPicture.asset('assets/svg/avatar.svg')
                                                                                        : Container(
                                                                                            decoration: const BoxDecoration(
                                                                                              color: Colors.white,
                                                                                              shape: BoxShape.circle,
                                                                                              boxShadow: [
                                                                                                BoxShadow(
                                                                                                    blurRadius: 3,
                                                                                                    color: Color(0xffE9E9E9),
                                                                                                    spreadRadius: 2)
                                                                                              ],
                                                                                            ),
                                                                                            child: CircleAvatar(
                                                                                              radius: 20.0,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(top: 5),
                                                                                                child: Image.asset(document['profileImage']),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 5, top: 15),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Good ${greeting()}',
                                                                              style: const TextStyle(fontFamily: "Gilroy Medium", fontSize: 12),
                                                                            ),
                                                                            Text(
                                                                              documentData['name'],
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontFamily: "Gilroy SemiBold",
                                                                              ),
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Get.to(() => const NotificationPage());
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                                                      child: SvgPicture.asset(
                                                                        notifyIcon,
                                                                        width: 25,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
//Start and stop Toggle
                                                              Positioned(
                                                                top: cardHeight / 4,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <Widget>[
                                                                    status
                                                                        ? const Text('Start',
                                                                            style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 12))
                                                                        : const Text('Start',
                                                                            style: TextStyle(fontFamily: "Gilroy Bold", fontSize: 12)),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    FlutterSwitch(
                                                                      width: 55.0,
                                                                      height: 30.0,
                                                                      activeIcon: SvgPicture.asset(switchButtonOn),
                                                                      inactiveIcon: SvgPicture.asset(switchButtonOff),
                                                                      activeColor: const Color(0xffffffff),
                                                                      inactiveColor: const Color(0xffffffff),
                                                                      activeToggleColor: switchColor,
                                                                      inactiveToggleColor: switchColor,
                                                                      toggleSize: 30.0,
                                                                      value: status,
                                                                      borderRadius: 30.0,
                                                                      padding: 2.0,
                                                                      onToggle: (val) {
                                                                        setState(() {
                                                                          status = val;
                                                                          // print('status: $status');
                                                                          if (status == true) {
                                                                            startButton = false;
                                                                            stopButton = true;
                                                                            editButtonVisible = false;
                                                                          } else {
                                                                            startButton = true;
                                                                            stopButton = false;
                                                                            editButtonVisible = true;
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    status
                                                                        ? const Text('Stop',
                                                                            style: TextStyle(fontFamily: "Gilroy Bold", fontSize: 12))
                                                                        : const Text('Stop',
                                                                            style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 12))
                                                                  ],
                                                                ),
                                                              ),
// Total Amount
                                                              Positioned(
                                                                top: cardHeight / 2.60,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: <Widget>[
                                                                    const Text('\u{20B9} ',
                                                                        style: TextStyle(
                                                                            color: Color(0xff9c9c9c), fontFamily: "Gilroy Medium", fontSize: 23)),
                                                                    Text(startButton ? budgetAvailable : '${totalFund ?? 0}',
                                                                        style: const TextStyle(
                                                                            color: Colors.black, fontFamily: "Gilroy Bold", fontSize: 35)),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Visibility(
                                                                      visible: editButtonVisible,
                                                                      child: SvgPicture.asset(
                                                                        editButton,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
//Budget or Total
                                                              Positioned(
                                                                top: cardHeight / 1.75,
                                                                child: Center(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: switchColor,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                                                      child: startButton
                                                                          ? const Text('Budget',
                                                                              style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 15))
                                                                          : const Text('Total Fund',
                                                                              style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 15)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
// Available and spend
                                                      Positioned(
                                                        bottom: 30,
                                                        child: Visibility(
                                                            visible: stopButton,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      offset: const Offset(1, 3),
                                                                      blurRadius: 5,
                                                                      color: Colors.black.withOpacity(0.15),
                                                                    ),
                                                                  ],
                                                                  color: const Color(0xffffffff),
                                                                  borderRadius: const BorderRadius.all(Radius.circular(30))),
                                                              child: FlutterToggleTab(
                                                                width: Get.width * 0.17,
                                                                height: Get.width * 0.13, // width in percent
                                                                borderRadius: 30,
                                                                selectedIndex: toggleValue,
                                                                selectedBackgroundColors: [boxColor],
                                                                unSelectedBackgroundColors: const [Colors.white],
                                                                selectedTextStyle: const TextStyle(
                                                                  fontFamily: 'Gilroy Medium',
                                                                  fontSize: 17,
                                                                  color: Colors.black,
                                                                ),
                                                                unSelectedTextStyle: const TextStyle(
                                                                  fontFamily: 'Gilroy Medium',
                                                                  fontSize: 17,
                                                                  color: Color(0xff848484),
                                                                ),
                                                                labels: _listTextTabToggle,
                                                                selectedLabelIndex: (index) {
                                                                  setState(() {
                                                                    toggleValue = index;
                                                                  });
                                                                },
                                                                isScroll: false,
                                                                isShadowEnable: false,
                                                              ),
                                                            )),
                                                      ),
// Category, Transaction, Account Button
                                                      Positioned(
                                                        bottom: 0,
                                                        child: Visibility(
                                                          visible: startButton,
                                                          child: Container(
                                                            color: Colors.transparent,
                                                            width: MediaQuery.of(context).size.width / 1.2,
                                                            height: 95,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        SharedPreferences isOnboarding = await SharedPreferences.getInstance();
                                                                        isOnboarding.setBool('isOnboarding', true);
                                                                        Get.to(() => const AddCustomCategoryPage());
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          shape: BoxShape.circle,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.grey.withOpacity(0.2),
                                                                              spreadRadius: 1,
                                                                              blurRadius: 5,
                                                                              offset: const Offset(0, 3), // changes position of shadow
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(20.0),
                                                                          child: SvgPicture.asset(
                                                                            category,
                                                                            width: 25,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Get.to(() => NewTransaction());
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          shape: BoxShape.circle,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.grey.withOpacity(0.2),
                                                                              spreadRadius: 1,
                                                                              blurRadius: 5,
                                                                              offset: const Offset(0, 3), // changes position of shadow
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(20.0),
                                                                          child: SvgPicture.asset(transaction),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        Get.to(() => const AddAccountType(
                                                                              fromAccountPage: true,
                                                                            ));
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          shape: BoxShape.circle,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.grey.withOpacity(0.2),
                                                                              spreadRadius: 1,
                                                                              blurRadius: 5,
                                                                              offset: const Offset(0, 3), // changes position of shadow
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(20.0),
                                                                          child: SvgPicture.asset(account),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [Text('Category'), Text('Transaction'), Text('Account')],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
// Start and Stop Button
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots(),
                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot)
                          {
                            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                            final DocumentSnapshot? document = snapshot.data;
                            final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;

                            final List<Map<String, dynamic>> categoryList =
                                (documentData['categories'] as List).map((categoryLists) => categoryLists as Map<String, dynamic>).toList();
                            categoryListCount = categoryList.length;
                            return ListView.builder(
//physics:ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: categoryList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return startButton
                                      ? listCardViewStart(context, categoryList[index])
                                      : listCardViewStop(context, categoryList[index], toggleValue);
                                });
                          }),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
