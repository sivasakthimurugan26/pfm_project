import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/pages/onBoarding/add_account_credit.dart';
import 'package:personal_finance_management/pages/onBoarding/add_account_saving.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

class AddAccountType extends StatefulWidget {
  final bool fromAccountPage;
  const AddAccountType({Key? key, required this.fromAccountPage}) : super(key: key);
  @override
  _AddAccountTypeState createState() => _AddAccountTypeState();
}

class _AddAccountTypeState extends State<AddAccountType> {
  bool selected = false;
  bool saving = false;
  bool credit = false;
  double selectedWidthActive = 0;
  double selectedHeightActive = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    double selectedWidthInActive = width * 0.40;
    double selectedHeightInActive = width * 0.40;

    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            // FocusScope.of(context).unfocus();
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
              body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.1,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Help us here',
                              style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 30),
                            ),
                            Text(
                              'Choose your account type',
                              style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 17, color: Color(0xff747474)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
//Savings
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                saving = !saving;
                                credit = false;
                                selectedWidthActive = width * 0.45;
                                selectedHeightActive = height * 0.45;
                              });
                            },
                            child: Container(
                              width: saving ? selectedWidthActive : selectedWidthInActive,
                              height: saving ? selectedHeightActive : selectedHeightInActive,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  if (saving == true) ...[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 10,
                                    ),
                                  ]
                                ],
                                gradient: const LinearGradient(
                                    colors: [Color(0xffC4F4FF), Color(0xff78E7FF)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: saving
                                  ? Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5, top: 10),
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: SvgPicture.asset(
                                                'assets/svg/tick.svg',
                                                width: 30,
                                              )),
                                        ),
                                        Container(
                                          height: selectedHeightActive * 0.60,
                                          // color: Colors.black12,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Image.asset('assets/images/accountSavings.png', width: 50),
                                                Container(
                                                  // width: selectedWidthInActive * 0.6,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.75),
                                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                    child: Text(
                                                      'Savings',
                                                      style: TextStyle(fontSize: 13, fontFamily: 'Gilroy Medium'),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Image.asset('assets/images/accountSavings.png', width: 50),
                                            Container(
                                              // width: selectedWidthInActive * 0.6,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.75),
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                child: Text(
                                                  'Savings',
                                                  style: TextStyle(fontSize: 13, fontFamily: 'Gilroy Medium'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            if (credit == true) ...[
                                              BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                                child: const SizedBox(),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
//Credit Card
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                credit = !credit;
                                saving = false;
                                selectedWidthActive = width * 0.45;
                                selectedHeightActive = height * 0.45;
                              });
                            },
                            child: Container(
                              width: credit ? selectedWidthActive : selectedWidthInActive,
                              height: credit ? selectedHeightActive : selectedHeightInActive,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  if (credit == true) ...[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 10,
                                    ),
                                  ]
                                ],
                                gradient: const LinearGradient(
                                    colors: [Color(0xffFFD4E2), Color(0xffFF8FB3)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: credit
                                  ? Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5, top: 10),
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: SvgPicture.asset(
                                                'assets/svg/tick.svg',
                                                width: 30,
                                              )),
                                        ),
                                        Container(
                                          height: selectedHeightActive * 0.60,
                                          // color: Colors.black12,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Image.asset('assets/images/accountCredit.png', width: 40),
                                                Container(
                                                  width: selectedWidthInActive * 0.6,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.75),
                                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 5),
                                                    child: Text(
                                                      'Credit Card',
                                                      style: TextStyle(fontSize: 13, fontFamily: 'Gilroy Medium'),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Image.asset('assets/images/accountCredit.png', width: 40),
                                            Container(
                                              // width: selectedWidthInActive * 0.7,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.75),
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                child: Text(
                                                  'Credit Card',
                                                  style: TextStyle(fontSize: 13, fontFamily: 'Gilroy Medium'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            if (saving == true) ...[
                                              BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                                child: const SizedBox(),
                                              ),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: width * 0.42,
                              decoration: const BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.all(Radius.circular(40)),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Center(
                                    child: Text(
                                  'Back',
                                  style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
                                )),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // print('saving: $saving, Credit: $credit');
                              if (saving == true) {
                                Get.to(() => AddSavingsAccount(fromAccountPage: widget.fromAccountPage,));
                              } else if (credit == true) {
                                Get.to(() => AddCreditAccount(fromAccountPage: widget.fromAccountPage,));
                              } else {
                                snackBarWidget(
                                  "Help us here",
                                  "Please choose your account type",
                                );
                              }
                            },
                            child: Container(
                              width: width * 0.42,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(40)),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Center(
                                    child: Text(
                                  'Continue',
                                  style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
        ),
        onWillPop: () async => false);
  }
}
