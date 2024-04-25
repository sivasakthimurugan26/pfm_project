import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/models/transaction_model.dart';
import 'package:personal_finance_management/widgets/limit_amount.dart';
import 'package:personal_finance_management/widgets/slider_thumb_shape.dart';

import '../../constants/svg_constant.dart';
import 'second_popup_dashboard.dart';
class PopUpBox extends StatefulWidget {
  const PopUpBox({Key? key}) : super(key: key);

  @override
  _PopUpBoxState createState() => _PopUpBoxState();
}

class _PopUpBoxState extends State<PopUpBox> {
  bool status = true;
  bool credit = true;
  bool debit = false;
  bool isDisabled = false;
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  final FocusNode amountFocus = FocusNode();
  final FocusNode categoryNameFocus = FocusNode();
  final FocusNode budgetFocus = FocusNode();
  String transactionType = "";
  var editIcon = 'assets/svg/edit_button.svg';

  final double _sliderValue = 0.0;
  TextEditingController _sliderTextController = TextEditingController();
  TextEditingController _secondSliderTextController = TextEditingController();

  int value = 0;
  int availableValue = 0;
  int budgetValue = 0;

  double minValue = 0.0;
  double maxValue = 25000.0;
  double _availableValue = 0;
  double _budgetValue = 5450.0;

  String transactionAccountIDDB = "";
  String transactionAccountType = "";
  String transactionAccountBalance = "";
  String transDateDB = "";
  var transactionAccountName = 'Cash';
  var transactionTypeDB = 'Debit';
  var transactionCategoryDB = '';
  var transCatColor = '';
  var transCatIcon = '';
  var inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');

  final _formatedAmount = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
  ).format(25000);

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    // print('uid out: $uid');
    return uid;
  }

  @override
  void initState() {
    generateTransactionNumber();
    print('generateTransactionNumber: ${generateTransactionNumber()}');
    super.initState();
    amountController.text = _availableValue.toString();
    amountController.addListener(_setAmountValue);
    budgetController.addListener(_setBudgetValue);
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
  }

  void _setAmountValue() {
    // print('Amount: ${double.parse(amountController.text)}');
    transactionAccountBalance = amountController.text;
    if (double.parse(amountController.text).roundToDouble() >= minValue && double.parse(amountController.text).roundToDouble() <= maxValue) {
      setState(() {
        _availableValue = double.tryParse(amountController.text) ?? 0;
      });
    }
  }

  void _setBudgetValue() {
    print('Budget: ${double.parse(budgetController.text)}');
    if (double.parse(budgetController.text).roundToDouble() >= minValue && double.parse(budgetController.text).roundToDouble() <= maxValue) {
      setState(() {
        _budgetValue = double.parse(budgetController.text).roundToDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return dialogBox1();
  }

  Widget dialogBox1() => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20.0,
            ),
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xffFFE4C8), Colors.white], begin: Alignment.topCenter, end: Alignment.center),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          height: MyUtility(context).height / 2.75,
          width: MyUtility(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //Debit/Credit
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Debit',
                          style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: debit ? Colors.black : const Color(0xff81786f))),
                      const SizedBox(
                        width: 5,
                      ),
                      FlutterSwitch(
                        width: 60.0,
                        height: 35.0,
                        activeIcon: SvgPicture.asset(swtichOnIconYellow),
                        inactiveIcon: SvgPicture.asset(swtichOffIconYellow),
                        activeColor: const Color(0xffffffff),
                        inactiveColor: const Color(0xffffffff),
                        activeToggleColor: const Color(0xffFFBA41),
                        inactiveToggleColor: const Color(0xffFFBA41),
                        toggleSize: 30.0,
                        value: status,
                        borderRadius: 30.0,
                        padding: 5.0,
                        onToggle: (val) {
                          setState(() {
                            status = val;
                            // print('status: $val');
                            if (status == true) {
                              debit = false;
                              credit = true;
                              setState(() {
                                transactionType = 'Credit';
                              });
                            } else {
                              debit = true;
                              credit = false;
                              setState(() {
                                transactionType = 'Debit';
                              });
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('Credit',
                          style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: credit ? Colors.black : const Color(0xff81786f)))
                    ],
                  ),
//Amount
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Amount',
                          style: TextStyle(fontSize: 20, fontFamily: 'Gilroy Medium', color: Color(0xff2d2d2d)),
                        ),
                        Row(
                          children: [
                            const Text(
                              '\u{20B9} ',
                              style: TextStyle(color: Color(0xff757575), fontSize: 20, fontFamily: 'Gilroy Medium'),
                            ),
                            IntrinsicWidth(
                                child: TextField(
                              controller: amountController,
                              inputFormatters: [
                                // LengthLimitingTextInputFormatter(2),
                                LimitRange(0, 25000),
                              ],
                              focusNode: amountFocus,
                              onChanged: (value) {
                                bool isFirst = true;
                                String newValue = value.replaceAll(',', '').replaceAll('.', '');
                                double value1 = double.parse(newValue);
                                if (!isFirst) value1 = value1 * 100;
                                value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
                                amountController.value = TextEditingValue(
                                  text: value,
                                  selection: TextSelection.collapsed(offset: value.length),
                                );
                                setState(() {
                                  _availableValue = double.tryParse(value.replaceAll(',', '')) ?? 0.00;

                                  print('amountSlider:${_availableValue}');
                                  print('value:${value}');
                                });
                                // print('TextEdit:$value');
                              },
                              style: const TextStyle(color: Color(0xff757575), fontSize: 15, fontFamily: 'Gilroy Medium'),
                              decoration: const InputDecoration(
                                // hintText: "12,450.00",
                                border: InputBorder.none,
                              ),
                              maxLines: 1,
                            )),
                            InkWell(
                              child: SvgPicture.asset(editIcon),
                              onTap: () {
                                amountFocus.requestFocus();
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
//Slider
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: SliderTheme(
                      data: SliderThemeData(
                        thumbShape: SliderThumbShape(inColor: 0xffFFBE78),
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Slider(
                        value: _availableValue,
                        min: minValue,
                        max: maxValue,
                        onChanged: (double newValue) {
                          setState(() {
                            _availableValue = newValue.roundToDouble();
                            amountController.text = _availableValue.toString();
                            storageContainer.write('amount', amountController.text);
                          });
                        },
                        activeColor: const Color(0xffFFBE78),
                        inactiveColor: const Color(0xfff5e0c5),
                      ),
                    ),
                  ),
//Amount min/max
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text(
                        "0",
                        style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 15, color: Color(0xff7d7d7d)),
                      ),
                      Text(
                        _formatedAmount,
                        style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 15, color: Color(0xff7d7d7d)),
                      ),
                    ]),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        print(amountController.text);
                        addTransaction();
                        Get.back();
                        // dialogBox2();
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(40))),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                              child: Text(
                            'Save',
                            style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Medium', color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  generateTransactionNumber() {
    var rng = Random();
    var rand = rng.nextInt(5000) + 1000;
    var date = DateTime.now();
    var dd = DateFormat("dd").format(date);
    var mm = DateFormat("MMM").format(date);
    var transType = transactionType == 'Credit' ? 'Cre' : 'Deb';
    transactionAccountIDDB = dd + mm + rand.toString() + transType;
    // print('transNum: $transNum');
    // print(dd);
    // print(mm + dd + transactionType == 'Credit' ? 'cre' : 'deb' + rand.toString());
    return transactionAccountIDDB;
  }

  getTransactionAccountType() {
    if (transactionType == 'Credit') {
      transactionAccountType = 'Credit';
    } else {
      transactionAccountType = 'Debit';
    }
    print(transactionAccountType);
    return transactionAccountType;
  }

  generateAccTransactionNumber() {
    var rng = Random().nextInt(500);
    var transNumber = 'accTrans$rng';
    return transNumber;
  }

  addTransaction() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    TransactionModel transactionModel = TransactionModel();

    var transactionLastUpdate = inputFormat.format(DateTime.now());
    DateTime initialDate = DateTime.now();
    transDateDB = inputFormat.format(initialDate);
    transactionCategoryDB = '';
    transCatIcon = 'assets/images/exclamation_mark.png';
    transCatColor = '';
    print('transactionDateDB: $transDateDB');

    var docRef =
        FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser?.uid).collection('TransactionData').doc('Untagged');

    docRef.get().then((value) {
      if (value.exists) {
        firebaseFirestore.collection("UserData").doc(getUid()).collection("TransactionData").doc('Untagged').update(transactionModel.transaction(
            transDateDB,
            generateTransactionNumber(),
            getTransactionAccountType(),
            amountController.text,
            'Y',
            transactionCategoryDB,
            transCatIcon,
            transCatColor,
            transactionLastUpdate,
            transactionLastUpdate));
      } else {
        firebaseFirestore.collection("UserData").doc(getUid()).collection("TransactionData").doc('Untagged').set(transactionModel.transaction(
            transDateDB,
            generateTransactionNumber(),
            getTransactionAccountType(),
            amountController.text,
            'N',
            transactionCategoryDB,
            transCatIcon,
            transCatColor,
            transactionLastUpdate,
            transactionLastUpdate));
      }
    });
  }

  Future<Object?> dialogBox2() {
    return showDialog(context: context, barrierColor: Colors.transparent, builder: (_) => SecondPopUpDashboard());
  }
}
