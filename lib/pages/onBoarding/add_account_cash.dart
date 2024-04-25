
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/stepper.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_budget.dart';

class AddCashAccount extends StatefulWidget {
  const AddCashAccount({Key? key}) : super(key: key);

  @override
  _AddCashAccountState createState() => _AddCashAccountState();
}

class _AddCashAccountState extends State<AddCashAccount> {
  bool isFirst = true;
  bool skip = false;
  var actName = [];
  String visited = 'budgetVisited';
  int activeIndex = 2;
  bool accountCompleted = true;


  final FocusNode cashFocus = FocusNode();
  TextEditingController cashAmountTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: ()  async {
          // FocusScope.of(context).unfocus();
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xffE3FFF2), Color(0xffffffff)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/svg/debit_account.svg', width: 50),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.75),
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                      child: Text(
                                        'Cash',
                                        style: TextStyle(fontSize: 13, fontFamily: 'Gilroy Medium'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  skip = true;
                                });
                                SharedPreferences isOnboarding = await SharedPreferences.getInstance();
                                print('onboarding:${isOnboarding.getBool('isOnboarding')}');
                                checkCashAccount();
                              },
                              child: const Text(
                                'Skip >>',
                                style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 17),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        const Text(
                          'Cash balance',
                          style: TextStyle(fontSize: 25, fontFamily: 'Gilroy Medium'),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        const Text(
                          'How much cash do you have in hand?',
                          style: TextStyle(fontSize: 16, fontFamily: 'Gilroy Light'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '\u{20B9} ',
                          style: TextStyle(color: Color(0xff727272), fontSize: 25),
                        ),
                        IntrinsicWidth(
                          child: TextField(
                            controller: cashAmountTextController,
                            focusNode: cashFocus,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              String newValue = value.replaceAll(',', '').replaceAll('.', '');
                              if (value.isEmpty || newValue == '00') {
                                cashAmountTextController.clear();
                                isFirst = true;
                                return;
                              }
                              double value1 = double.parse(newValue);
                              if (!isFirst) value1 = value1 * 100;
                              value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
                              cashAmountTextController.value = TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(offset: value.length),
                              );
                            },
                            style: const TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold'),
                            decoration: const InputDecoration(
                              hintText: "0.00 ",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black)
                            ),
                            maxLines: 1,
                          ),
                        ),
                        InkWell(
                          child: SvgPicture.asset('assets/svg/edit_button.svg'),
                          onTap: () {
                            cashFocus.requestFocus();
                          },
                        ),
                      ],
                    ),

                    // Text('0.00', style: TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 45),),
                    SizedBox(
                      height: height * 0.23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: width * 0.40,
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
                            if (cashAmountTextController.text.isEmpty) {
                              snackBarWidget("Help us here", "Please update the balance.");
                              cashFocus.requestFocus();
                            } else {
                              checkCashAccount();
                              // addCashAccount();
                              // Get.to(()=> AddBudget());
                              // Get.to(() => const AddAccountName(), arguments: ['0xffDDF9FF','Savings',cashAmountTextController.text]);
                            }
                          },
                          child: Container(
                            width: width * 0.40,
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
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  generateAccountNumber() {
    var rng = Random();
    var rand = rng.nextInt(5000) + 1000;
    var date = DateTime.now();
    var dd = DateFormat("dd").format(date);
    var mm = DateFormat("MMM").format(date);
    var accNum = dd + mm + rand.toString() + 'Cash';
    return accNum;
  }

  checkCashAccount() async {
    SharedPreferences isOnboarding =await SharedPreferences.getInstance();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();

    await firebaseFirestore.collection("UserData").doc(user?.uid).get().then((value) {
      var accountList = value['accounts'].length;
      List tempList = [];
      for (int i = 0; i < accountList; i++) {
        tempList.add(value['accounts'][i]['accountType']);
      }
      if (tempList.contains('Cash')) {
        //
        if(isOnboarding.getBool('isOnboarding') != true){
          Get.to(() => StepperPage(visited, activeIndex));
        }
        if( isOnboarding.getBool('isOnboarding') == true){
          Get.to(()=> HomePage());
        }

        print('Cash Account exist');
      } else {
        addCashAccount();
        print('No Cash Account');
      }
    });
  }

  addCashAccount() async {
    SharedPreferences isOnboarding =await SharedPreferences.getInstance();

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();

    // myProgressIndicator(context);

    await firebaseFirestore
        .collection("UserData")
        .doc(user?.uid)
        .update(userModel.accounts(generateAccountNumber(), 'Cash', 'Cash', 'INR', skip ? 0.toString() : cashAmountTextController.text, 'Y'));

    //
    if( isOnboarding.getBool('isOnboarding') != true){
      Get.to(() => StepperPage(visited, activeIndex));
    }
    if( isOnboarding.getBool('isOnboarding') == true){
      Get.to(()=> AddBudget());
    }
    // else{
    //   Get.to(()=>  AddBudget());
    // }

  }
}