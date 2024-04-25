import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:intl/intl.dart';
import 'package:personal_finance_management/pages/onBoarding/add_account.dart';
import 'package:personal_finance_management/widgets/edit_popup/account_popup.dart';

import '../notification/notifcationPage.dart';
import '../profile/profile_view.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  var bgColor1, bgColor2;
  var imageIcon;
  var linkedAccount;
  bool showBalance = false;
  bool status = true;
  bool isExtended = false;
  bool closeTopContainer = false;
  bool fromAccountPage = false;
  bool openAppBar = true;
  final amountFormat = NumberFormat("#,##0.0", "en_US");
  var totalAmount;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: status
          ? FloatingActionButton.extended(
        shape: isExtended ? CircleBorder() : null,
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
        onPressed: () async {
          setState(() {
            fromAccountPage = true;
          });
          showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: '',
            barrierColor: Colors.black38,
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (ctx, anim1, anim2) => AddAccountType(
              fromAccountPage: fromAccountPage,
            ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.to(() => const ProfilePage());

                          },
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('UserData').doc(user?.uid).snapshots(),
                              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                final document = snapshot.data;
                                if (snapshot.data == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    (document!['profileImage'] == null)
                                        ? SvgPicture.asset('assets/svg/avatar.svg')
                                        : Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(blurRadius: 3, color: Color(0xffE9E9E9), spreadRadius: 2)],
                                      ),
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Image.asset(document['profileImage']),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        // SvgPicture.asset('assets/svg/avatar.svg'),
                        GestureDetector(
                          onTap: (){
                            Get.to(() => const NotificationPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: SvgPicture.asset(
                              'assets/svg/notify.svg',
                              width: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('UserData').doc(user?.uid).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) return const Text("Loading...");
                          final DocumentSnapshot? document = snapshot.data;
                          final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;

                          if (documentData['accounts'] == null) {
                            return const Text('No accounts Added');
                          }

                          final List<Map<String, dynamic>> accountList =
                          (documentData['accounts'] as List).map((accountsList) => accountsList as Map<String, dynamic>).toList();

                          linkedAccount = accountList.length;

                          List amount = [];
                          double totAmt = 0.0;
                          for (int i = 0; i < linkedAccount; i++) {
                            if (accountList[i]['accountType'] == 'Savings' || accountList[i]['accountType'] == 'Cash') {
                              var temp = accountList[i]['amountBalance'].replaceAll(",", "");
                              amount.add(temp);
                            }
                          }
                          for (var element in amount) {
                            totAmt += double.parse(element);
                            totalAmount = amountFormat.format(totAmt);
                          }

                          return Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          'Total Balance',
                                          style: TextStyle(fontSize: 16, fontFamily: 'Gilroy Light'),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xff50CB93),
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                                          child: Text('$linkedAccount linked',
                                              style: const TextStyle(fontFamily: "Gilroy Medium", fontSize: 10, color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            '\u{20B9} ',
                                            style: TextStyle(fontFamily: 'Gilroy Bold', fontSize: 25, color: Color(0xff757575)),
                                          ),
                                          showBalance
                                              ? Text(
                                            totalAmount,
                                            style: const TextStyle(fontFamily: 'Gilroy Bold', fontSize: 25, color: Color(0xff757575)),
                                          )
                                              : Image.asset(
                                            'assets/images/hideBalAmount.png',
                                            width: 70,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            showBalance ? 'Hide Balance' : 'Show Balance',
                                            style: const TextStyle(fontSize: 16, fontFamily: 'Gilroy Medium'),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showBalance = !showBalance;
                                              });
                                            },
                                            child: Image.asset(
                                              showBalance ? 'assets/images/hideBalance.png' : 'assets/images/showBalance.png',
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: accountList.length,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 15, crossAxisSpacing: 15, crossAxisCount: 2),
                                  itemBuilder: (BuildContext context, int index) {
                                    final Map<String, dynamic> accountsData = accountList[index];

                                    if (accountsData['accountType'] == 'Savings') {
                                      bgColor1 = const Color(0xffD3F7FF);
                                      bgColor2 = const Color(0xff6AE2FF);
                                    } else if (accountsData['accountType'] == 'Credit Card') {
                                      bgColor1 = const Color(0xffFFDBE7);
                                      bgColor2 = const Color(0xffFF8BB1);
                                    } else if (accountsData['accountType'] == 'Cash') {
                                      bgColor1 = const Color(0xffDEFFF0);
                                      bgColor2 = const Color(0xff7FFFC2);
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        showGeneralDialog(
                                          barrierDismissible: true,
                                          barrierLabel: '',
                                          barrierColor: Colors.black38,
                                          transitionDuration: const Duration(milliseconds: 500),
                                          pageBuilder: (ctx, anim1, anim2) => AccountEditPopUp(accountData: accountList[index]),
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
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient:
                                                LinearGradient(colors: [bgColor1, bgColor2], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                            borderRadius: const BorderRadius.all(Radius.circular(40))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    accountsData['accountName'],
                                                    style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16),
                                                  ),
                                                  getAccountIcon(accountsData['accountType']),
// imageIcon
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        '\u{20B9} ',
                                                        style: TextStyle(fontFamily: 'Gilroy Bold', fontSize: 25, color: Color(0xff757575)),
                                                      ),
                                                      showBalance
                                                          ? Text(accountsData['amountBalance'],
                                                              style:
                                                                  const TextStyle(fontFamily: 'Gilroy Bold', fontSize: 23, color: Color(0xff2d2d2d)))
                                                          : Image.asset(
                                                        'assets/images/hideBalAmount.png',
                                                        width: 70,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.75),
                                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                                                      child: Text(accountsData['accountType'],
                                                          style:
                                                              const TextStyle(fontFamily: "Gilroy Medium", fontSize: 13, color: Color(0xff3a3a3a))),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getAccountColor(type) {
    if (type == 'Savings') {
      setState(() {
        bgColor1 = const Color(0xffD3F7FF);
        bgColor2 = const Color(0xff6AE2FF);
      });
    }
  }

  getAccountIcon(type) {
    if (type == 'Savings') {
      return Image.asset(
        'assets/images/category/Savings.png',
        width: 30,
      );
    } else if (type == 'Credit Card') {
      return Image.asset(
        'assets/images/category/Wallet.png',
        width: 30,
      );
    } else if (type == 'Cash') {
      return Image.asset(
        'assets/images/category/Money.png',
        width: 30,
      );
    }
  }

  calculateBalance(balance, type) {
    List amount = [];
    amount.add(balance);
  }
}
