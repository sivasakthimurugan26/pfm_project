import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/transactions/new_transaction.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {

  String amountValue = "";
  String transferType = "From"; // transaction type
  String transactionCurrencyDB = ""; // currency
  String transactionAmountDB = ""; // Amount
  String transactionCategoryDB = ""; // Category
  String fromTransactionAccountIDDB = ""; // Account ID
  String toTransactionAccountIDDB = ""; // Account ID
  String fromTransactionAccountName = ""; //  From Account Name
  String toTransactionAccountName = ""; // To Account Name
  String fromTransactionAccountType = ""; //  from Account Type
  String toTransactionAccountType = ""; // to Account Type
  String transactionAccountBalance = "";
  String toTransactionAccountBalance = "";// To Account Balance
  String fromTransactionAccountBalance = "";// From Account Balance
  String transDateDB = ""; // Transaction Date
  String transactionIDDB = ""; // Transaction ID
  String transactionTransferDB = ""; // Transfer
  String transactionToAccountDB = ""; // To Account ID
  DateTime initialDate = DateTime.now();
  var inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  String transactionDD = "";
  String transactionMMM = "";
  bool transactionDateSet = false;
  bool status = false;
  final FocusNode amountFocus = FocusNode();
  TextEditingController amountTextController = TextEditingController();
  bool isFirst = true;
  bool onSelected = false;
  List<Map<String, dynamic>> accountList = [];
  bool from = true;
  bool to =false;
  bool toAccount =false;
  bool fromAccount =false;
  Color fromTopColor = const Color(0xffffffff);
  Color toTopColor = const Color(0xffffffff);
  Color fromBottomColor = const Color(0xffffffff);
  Color toBottomColor = const Color(0xffffffff);

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    // print('uid out: $uid');
    return uid;
  }

  Future<void> _transactionDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2022, 1),
      initialDate: initialDate,
      lastDate: DateTime(2050),
      helpText: 'Select Transaction Date',
    );
    if (selectedDate != null && selectedDate != initialDate) {
      setState(() {
        initialDate = selectedDate;
        transactionDD = DateFormat.d().format(initialDate);
        transactionMMM = DateFormat.MMM().format(initialDate);
        transDateDB = inputFormat.format(initialDate);
        // transDateDB = transactionLastUpdate;
        print('transactionDateDB: $transDateDB');
        transactionDateSet = true;
      });
    }
  }

  // searchList(String searchValue) {
  //   setState(() {
  //     print('value:$searchValue');
  //     print('categoriesList:${categoriesList.length}');
  //     searchData = categoriesList.where((element) => element['categoryName'].toLowerCase().contains(searchValue.toLowerCase())).toList();
  //     print('searchData:${searchData}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
  print('ww:${MyUtility(context).width * 0.188}');
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: SizedBox(
                // height: MyUtility(context).height * 0.85,
                width: MyUtility(context).width,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
//Select Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'New Transaction',
                              style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 30),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                const TextSpan(text: "Is this not a transfer ?", style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 17, color: Color(0xff464646))),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(() =>  NewTransaction());
                                      },
                                    text: " Click here",
                                    style: const TextStyle(
                                      fontFamily: 'Gilroy SemiBold',
                                      fontSize: 18,
                                      color: Color(0xffFF9E36),
                                    )),
                              ]),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _transactionDate(context);
                          },
                          child: Container(
                            decoration: const BoxDecoration(color: Color(0xffFFF0D3), borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: transactionDateSet
                                  ? Column(
                                children: [
                                  Text(
                                    transactionDD,
                                    style: const TextStyle(fontSize: 12, fontFamily: 'Gilroy Medium'),
                                  ),
                                  Text(
                                    transactionMMM,
                                    style: const TextStyle(fontSize: 15, fontFamily: 'Gilroy SemiBold', color: transDate),
                                  )
                                ],
                              )
                                  : Image.asset('assets/images/calender.png'),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MyUtility(context).height * 0.02),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) return const Text("Loading...");
                          final DocumentSnapshot? document = snapshot.data;
                          final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;

                          accountList = (documentData['accounts'] as List).map((accountList) => accountList as Map<String, dynamic>).toList();
                          accountList.insert(0, {'accountName': "Select Account"});
                          print('accountList: $accountList');
                          if (fromTransactionAccountType == 'Savings') {
                            fromBottomColor = const Color(0xff7EE8FF);
                            fromTopColor = const Color(0xffD6F8FF);
                          } else if (fromTransactionAccountType == 'Credit Card') {
                            fromBottomColor = const Color(0xffFF84AB);
                            fromTopColor = const Color(0xffFFDFE9);
                          } else if (fromTransactionAccountType == 'Cash') {
                            fromBottomColor = const Color(0xff88FFC7);
                            fromTopColor = const Color(0xffE2FFF2);
                          }
                          if (toTransactionAccountType == 'Savings') {
                            toBottomColor = const Color(0xff7EE8FF);
                            toTopColor = const Color(0xffD6F8FF);
                          } else if (toTransactionAccountType == 'Credit Card') {
                            toBottomColor = const Color(0xffFF84AB);
                            toTopColor = const Color(0xffFFDFE9);
                          } else if (toTransactionAccountType == 'Cash') {
                            toBottomColor = const Color(0xff88FFC7);
                            toTopColor = const Color(0xffE2FFF2);
                          }

                          return Column(
                            children: [
                              SizedBox(height: MyUtility(context).height * 0.07),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  status ? Text('From', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black.withOpacity(0.5))) : const Text('From', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black)),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  FlutterSwitch(
                                    width: 55.0,
                                    height: 30.0,
                                    activeIcon: SvgPicture.asset('assets/svg/switchOnIcon_yellow.svg'),
                                    inactiveIcon: SvgPicture.asset('assets/svg/switchOffIcon_yellow.svg'),
                                    activeColor: closeIconBg,
                                    inactiveColor: closeIconBg,
                                    activeToggleColor: dateSelect,
                                    inactiveToggleColor: dateSelect,
                                    toggleSize: 30.0,
                                    value: status,
                                    borderRadius: 30.0,
                                    padding: 2.0,
                                    onToggle: (val) {
                                      setState(() {
                                        status = val;
                                        // // print('status: $status');
                                        if (status == true) {
                                          setState(() {
                                            transferType = 'To';
                                            from = false;
                                            to = true;

                                          });
                                        } else {
                                          setState(() {
                                            transferType = 'From';
                                            to = false;
                                            from = true;
                                          });
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  status ? const Text('To', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black)) : Text('To', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black.withOpacity(0.5))),
                                ],
                              ),
                              SizedBox(height: MyUtility(context).height * 0.025),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                Visibility(
                                  visible:fromAccount,
                                  child: Container(
                                    width: MyUtility(context).width *0.25,
                                    decoration:  BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [fromTopColor, fromBottomColor], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          fromTransactionAccountName,
                                          style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 13, color: Colors.black.withOpacity(0.75)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                 Visibility(
                                   visible:toAccount,
                                   child: Container(
                                     width: MyUtility(context).width *0.25,
                                     decoration:  BoxDecoration(
                                       gradient: LinearGradient(
                                           colors: [toTopColor, toBottomColor], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                       borderRadius: const BorderRadius.all(Radius.circular(20)),
                                     ),
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Center(
                                         child: Text(
                                           toTransactionAccountName,
                                           style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 13, color: Colors.black.withOpacity(0.75)),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                              ],),
                              (fromAccount||toAccount) ? SizedBox(height: MyUtility(context).height * 0.040): SizedBox(height: MyUtility(context).height * 0.080),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '\u{20B9}',
                                        style: TextStyle(color:Colors.black, fontSize: 25),
                                      ),
                                      IntrinsicWidth(
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          controller: amountTextController,
                                          focusNode: amountFocus,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            String newValue = value.replaceAll(',', '').replaceAll('.', '');
                                            if (value.isEmpty || newValue == '00') {
                                              amountTextController.clear();
                                              isFirst = true;
                                              return;
                                            }
                                            double value1 = double.parse(newValue);
                                            if (!isFirst) value1 = value1 * 100;
                                            value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
                                            amountValue = value.contains(',') ? value.replaceAll(',', '') : value;
                                            amountTextController.value = TextEditingValue(
                                              text: value,
                                              selection: TextSelection.collapsed(offset: value.length),
                                            );
                                          },
                                          style: const TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold', color:Colors.black),
                                          decoration: const InputDecoration(
                                            hintText: "0.00 ",
                                            hintStyle: TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold', color:Colors.black),
                                            border: InputBorder.none,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      InkWell(
                                        child: SvgPicture.asset(
                                          'assets/svg/edit_button.svg',
                                          color: rupeeSymbol,
                                        ),
                                        onTap: () {
                                          amountFocus.requestFocus();
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: MyUtility(context).width * 0.5,
                                    decoration: const BoxDecoration(
                                      color: dateSelect,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' Available',
                                            style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 13, color: Colors.black.withOpacity(0.75)),
                                          ),
                                          Text(
                                            ' \u{20B9} ${transactionAccountBalance} ',
                                            style: const TextStyle(fontFamily: 'Gilroy Bold', fontSize: 15, color: amount),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: MyUtility(context).height * 0.053),
//select Account
                              Stack(
                                children: [
                                  Positioned(
                                    bottom: 40,
                                    child: Container(
                                      width: MyUtility(context).width - 50,
                                      height: MyUtility(context).height * 0.075,
                                      decoration: const BoxDecoration(
                                        color: closeIconBg,
                                        // color: Colors.grey,
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset('assets/images/account_arrow_left.png'),
                                            Image.asset('assets/images/account_arrow_right.png'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:from,
                                    child: SizedBox(
                                      height: 150,
                                      child: ListWheelScrollView(
                                          itemExtent: 50,
                                          useMagnifier: true,
                                          magnification: 1.3,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              fromAccount = true;
                                              fromTransactionAccountIDDB = accountList[index]['accountId'];
                                              fromTransactionAccountName = accountList[index]['accountName'];
                                              fromTransactionAccountType = accountList[index]['accountType'];
                                              transactionAccountBalance = accountList[index]['amountBalance'];
                                              fromTransactionAccountBalance = transactionAccountBalance;
                                            });

                                            //print('selectedAccount: $selectedAccount');
                                          },
                                          children: accountList.map((item) {
                                            print('acc no: ${item['accountType']}');
                                            return Center(
                                              child: Text(
                                                item['accountName'],
                                                style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 18),
                                              ),
                                            );
                                          }).toList()),
                                    ),
                                  ),
                                  Visibility(
                                    visible:to,
                                    child: SizedBox(
                                      height: 150,
                                      child: ListWheelScrollView(
                                          itemExtent: 50,
                                          useMagnifier: true,
                                          magnification: 1.3,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              toAccount = true;
                                              toTransactionAccountIDDB = accountList[index]['accountId'];
                                              toTransactionAccountName = accountList[index]['accountName'];
                                              toTransactionAccountType = accountList[index]['accountType'];
                                              transactionAccountBalance = accountList[index]['amountBalance'];
                                              toTransactionAccountBalance = transactionAccountBalance ;
                                            });

                                            //print('selectedAccount: $selectedAccount');
                                          },
                                          children: accountList.map((item) {
                                            print('Item: ${item['accountName']}');
                                            return Center(
                                              child: Text(
                                                item['accountName'],
                                                style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 18),
                                              ),
                                            );
                                          }).toList()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),

                    SizedBox(height: MyUtility(context).height * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => HomePage(index: 2,passedIndex: 2,));
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
                                    'Cancel',
                                    style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
                                  )),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                            var amount = amountValue.contains(",") ? double.parse(amountValue.replaceAll(',', '')) : double.parse(amountValue) ;
                            var fromAmount = fromTransactionAccountBalance.contains(",") ? double.parse(fromTransactionAccountBalance.replaceAll(',', '')) : double.parse(fromTransactionAccountBalance) ;
                            // print('amount:$amount');
                            // print('fromAmount:$fromAmount');
                            if (amountTextController.text.isEmpty) {
                              snackBarWidget("Help us here", "Please update the amount.");
                              amountFocus.requestFocus();
                            } else if (transDateDB.isEmpty) {
                              snackBarWidget("Help us here", "Please select the transaction date.");
                            }
                            else if (amount > fromAmount) {
                              snackBarWidget("Help us here", "Account balance exceed");
                            }
                            else {
                              addTransfer();
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
                                    'Continue',
                                    style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Colors.white),
                                  )),
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
      ),
    );
  }
  Future<void> addTransfer() async {
    var toAccountBalance = toTransactionAccountBalance.contains(",") ? double.parse(toTransactionAccountBalance.replaceAll(',', '')) : double.parse(toTransactionAccountBalance) ;
    var fromAccountBalance = fromTransactionAccountBalance.contains(",") ? double.parse(fromTransactionAccountBalance.replaceAll(',', '')) : double.parse(fromTransactionAccountBalance) ;
    var toUpdatedBalance = toAccountBalance + double.parse(amountValue);
    var fromUpdatedBalance = fromAccountBalance - double.parse(amountValue);
    var amountFormat = NumberFormat("###,###.00#", "en_US");
    var toAvailableCommaFormat = amountFormat.format(toUpdatedBalance);
    var fromAvailableCommaFormat = amountFormat.format(fromUpdatedBalance);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> document = await firebaseFirestore.collection("UserData").doc(getUid()).collection("TransactionData").doc(toTransactionAccountIDDB).get();
    FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').doc(toTransactionAccountIDDB).update({
      'accountTotal': toAvailableCommaFormat,
    });
    FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').doc(fromTransactionAccountIDDB).update({
      'accountTotal': fromAvailableCommaFormat,
      'transfer':'Y',
      'toAccountId':toTransactionAccountIDDB,
      'transferDate':transDateDB,
    });
    Get.to(() => HomePage());
    User? user = FirebaseAuth.instance.currentUser;
    var query = await firebaseFirestore.collection("UserData").doc(user?.uid);
    accountList.forEach((element) {
      List<Map<String, dynamic>> editList;
      if(element['accountName'] == fromTransactionAccountName){
        List newList = [];
        newList.add(element);
        editList = [
          {
            'accountId': element['accountId'],
            'accountName': element['accountName'],
            'accountType': element['accountType'],
            'amountBalance': fromAvailableCommaFormat,
            'currency': element['currency'],
            'isAvailable': element['isAvailable'],
          }
        ];
        query.update({'accounts': FieldValue.arrayRemove(newList)});
        query.update({'accounts': FieldValue.arrayUnion(editList)});
      }
      if(element['accountName'] == toTransactionAccountName){
        List newList = [];
        newList.add(element);
        editList = [
          {
            'accountId': element['accountId'],
            'accountName': element['accountName'],
            'accountType': element['accountType'],
            'amountBalance': toAvailableCommaFormat,
            'currency': element['currency'],
            'isAvailable': element['isAvailable'],
          }
        ];
        query.update({'accounts': FieldValue.arrayRemove(newList)});
        query.update({'accounts': FieldValue.arrayUnion(editList)});
      }
    });
  }
}
