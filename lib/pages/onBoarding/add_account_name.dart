import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/models/transaction_model.dart';
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/onBoarding/add_more_options.dart';
import 'package:personal_finance_management/widgets/custom_progress_indicator.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

class AddAccountName extends StatefulWidget {
  final bool fromAccountPage;
  const AddAccountName({Key? key, required this.fromAccountPage}) : super(key: key);

  @override
  _AddAccountNameState createState() => _AddAccountNameState();
}

class _AddAccountNameState extends State<AddAccountName> {
  var data = Get.arguments;

  bool isFirst = true;
  static const _locale = 'en';

  var actName = [];
  var transactionId;
  final FocusNode nameFocus = FocusNode();
  TextEditingController nameTextController = TextEditingController();
  var formatter = NumberFormat.currency(locale: "en_US", symbol: "\u{20B9}");

  @override
  Widget build(BuildContext context) {
    // print('Data: ${data}');
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          // FocusScope.of(context).unfocus();
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MyUtility(context).height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(int.parse(data[0])), const Color(0xffffffff)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            children: <Widget>[
                              Image.asset(data[3], width: 40),
                              SizedBox(
                                width: MyUtility(context).width * 0.02,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Text(
                                    data[1],
                                    style: const TextStyle(fontSize: 13, fontFamily: 'Gilroy Medium'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MyUtility(context).height * 0.02,
                        ),
                        const Text(
                          'Give Account a Name',
                          style: TextStyle(fontSize: 25, fontFamily: 'Gilroy Medium'),
                        ),
                        SizedBox(
                          height: MyUtility(context).height * 0.01,
                        ),
                        const Text(
                          'How would you like to display this account',
                          style: TextStyle(fontSize: 16, fontFamily: 'Gilroy Light'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MyUtility(context).height * 0.15,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: IntrinsicWidth(
                                child: TextField(
                                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                                  textAlign: TextAlign.center,
                                  controller: nameTextController,
                                  focusNode: nameFocus,
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.1, fontFamily: 'Gilroy SemiBold'),
                                  decoration: const InputDecoration(
                                    hintText: "Account Name ",
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            InkWell(
                              child: SvgPicture.asset('assets/svg/edit_button.svg'),
                              onTap: () {
                                nameFocus.requestFocus();
                              },
                            ),
                          ],
                        ),
                        Container(
                          width: MyUtility(context).width * 0.5,
                          decoration: BoxDecoration(
                            color: data[1] == 'Savings' ? const Color(0xff4AD66D) : const Color(0xffFFBE78),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ' Available',
                                  style:
                                      TextStyle(fontFamily: 'Gilroy Medium', fontSize: 13, color: data[1] == 'Savings' ? Colors.white : Colors.black),
                                ),
                                Text(
                                  ' \u{20B9} ${data[2]}',
                                  style: TextStyle(
                                      fontFamily: 'Gilroy Bold', fontSize: 15, color: data[1] == 'Savings' ? Colors.white : const Color(0xff2d2d2d)),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MyUtility(context).height * 0.23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: MyUtility(context).width * 0.40,
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
                            if (nameTextController.text.isNotEmpty) {
                              addAccount();
                            } else {
                              snackBarWidget("Help us here", "Please update account name.");
                              nameFocus.requestFocus();
                            }
                          },
                          child: Container(
                            width: MyUtility(context).width * 0.40,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                  child: Text(
                                'Done',
                                style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MyUtility(context).height * 0.05,
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
    var accNum = dd + mm + rand.toString() + (data[1] == 'Savings' ? 'Sav' : 'Cre');
    setState(() {
      print('acc num:$accNum');
      transactionId = accNum;
      print('transactionId:$transactionId');
    });

    return accNum;
  }

  addAccount() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    TransactionModel transactionModel = TransactionModel();
    transactionModel.uid = user?.uid;
    transactionModel.currency = 'INR';

    transactionModel.accountName = nameTextController.text;
    transactionModel.accountType = data[1] == 'Savings' ? 'Savings' : 'Credit Card';
    transactionModel.accountTotal = data[2];
    transactionModel.auto = 'Y';
    transactionModel.transfer = 'N';
    transactionModel.toAccountId = '';
    transactionModel.transferDate = '';
    myProgressIndicator(context);
    print('accountId:${transactionId}');
    print('name:${nameTextController.text}');
    await firebaseFirestore.collection("UserData").doc(user?.uid).update(
        userModel.accounts(generateAccountNumber(), nameTextController.text, data[1] == 'Savings' ? 'Savings' : 'Credit Card', 'INR', data[2], 'Y'));
    transactionModel.accountId = transactionId;
    await firebaseFirestore.collection("UserData").doc(user?.uid).collection("TransactionData").doc(transactionId).set(transactionModel.toMap());
    if (widget.fromAccountPage) {
      snackBarWidget(
        "Hi",
        "New Account is added",
      );
      Get.to(() => HomePage(passedIndex:3));
    } else {
      Get.offAll(() => const AddMoreOptionsPage(
            name: 'Accounts',
          ));
    }
  }
}
