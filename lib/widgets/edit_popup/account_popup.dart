// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import "package:intl/intl.dart";
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:personal_finance_management/constants/my_utility.dart';
// import 'package:personal_finance_management/constants/svg_constant.dart';
// import 'package:personal_finance_management/pages/homePage.dart';
// import 'package:personal_finance_management/widgets/limit_amount.dart';
// import 'package:personal_finance_management/widgets/slider_thumb_shape.dart';
//
// class AccountEditPopUp extends StatefulWidget {
//   final Map accountData;
//   const AccountEditPopUp({Key? key, required this.accountData}) : super(key: key);
//
//   @override
//   State<AccountEditPopUp> createState() => _AccountEditPopUpState();
// }
//
// class _AccountEditPopUpState extends State<AccountEditPopUp> {
//   double minValue = 0.00;
//   double maxValue = 25000.00;
//   bool status = true;
//   bool debit = false;
//   bool credit = true;
//   String accountType = "";
//   double amountSlider = 0.00;
//   TextEditingController accountTextController = TextEditingController();
//   TextEditingController amountTextController = TextEditingController();
//   final FocusNode amountFocus = FocusNode();
//   final FocusNode accountTextFocus = FocusNode();
//
//   final _formattedAmount = NumberFormat.compactCurrency(
//     decimalDigits: 2,
//     symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
//   ).format(25000);
//
//   @override
//   void initState() {
//     super.initState();
//     accountTextController.text = widget.accountData['accountName'];
//     amountTextController.text = widget.accountData['amountBalance'].replaceAll(',', '');
//     print('amount controller:${double.parse(amountTextController.text).runtimeType}');
//     print('amount controller:${widget.accountData['amountBalance']}');
//     amountSlider = double.parse(widget.accountData['amountBalance'].replaceAll(',', ''));
//     //minValue = double.parse(amountTextController.text);
//     if (widget.accountData['accountType'] == 'Savings') {
//       setState(() {
//         status = false;
//         debit = true;
//         credit = false;
//         accountType = 'Savings';
//       });
//     } else if (widget.accountData['accountType'] == 'Credit') {
//       setState(() {
//         status = true;
//         debit = false;
//         credit = true;
//         accountType = 'Credit Card';
//       });
//     } else if (widget.accountData['accountType'] == 'Cash') {
//       setState(() {
//         accountType = 'Cash';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // print(widget.accountData);
//     return AlertDialog(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(
//             20.0,
//           ),
//         ),
//       ),
//       contentPadding: EdgeInsets.all(0),
//       content: Container(
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(colors: [Color(0xffFFE4C8), Colors.white], begin: Alignment.topCenter, end: Alignment.center),
//             borderRadius: BorderRadius.all(Radius.circular(20))),
//         height: MyUtility(context).height / 2.15,
//         width: MyUtility(context).width,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
// // debit/credit
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text('Savings', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: debit ? Colors.black : const Color(0xff81786f))),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 FlutterSwitch(
//                   width: 50.0,
//                   height: 30.0,
//                   activeIcon: SvgPicture.asset(swtichOnIconYellow),
//                   inactiveIcon: SvgPicture.asset(swtichOffIconYellow),
//                   activeColor: const Color(0xffffffff),
//                   inactiveColor: const Color(0xffffffff),
//                   activeToggleColor: const Color(0xffFFBA41),
//                   inactiveToggleColor: const Color(0xffFFBA41),
//                   toggleSize: 25.0,
//                   value: status,
//                   borderRadius: 30.0,
//                   padding: 3.0,
//                   onToggle: (val) {
//                     setState(() {
//                       status = val;
//                       if (status == true) {
//                         debit = false;
//                         credit = true;
//                         setState(() {
//                           accountType = 'Credit Card';
//                         });
//                       } else {
//                         debit = true;
//                         credit = false;
//                         setState(() {
//                           accountType = 'Savings';
//                         });
//                       }
//                     });
//                     // print('status: $accountType');
//                   },
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text('Credit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: credit ? Colors.black : const Color(0xff81786f)))
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
// // account name
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IntrinsicWidth(
//                     // width: 150,
//                     child: TextField(
//                   controller: accountTextController,
//                   focusNode: accountTextFocus,
//                   style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Gilroy SemiBold'),
//                   decoration: InputDecoration(
//                     hintText: accountTextController.text,
//                     border: InputBorder.none,
//                   ),
//                   maxLines: 1,
//                 )),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 7),
//                   child: InkWell(
//                     child: SvgPicture.asset('assets/svg/edit_button.svg'),
//                     onTap: () {
//                       accountTextFocus.requestFocus();
//                     },
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
// // amount
//
// // Available
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Balance',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontFamily: 'Gilroy SemiBold',
//                         ),
//                       ),
//                       Row(
//                         children: <Widget>[
//                           const Text(
//                             '\u{20B9} ',
//                             style: TextStyle(color: Color(0xff757575), fontSize: 15, fontFamily: 'Gilroy Medium'),
//                           ),
//                           IntrinsicWidth(
//                               child: TextField(
//                             controller: amountTextController,
//                             inputFormatters: [
//                               // LengthLimitingTextInputFormatter(2),
//                               LimitRange(0, 25000),
//                             ],
//                             focusNode: amountFocus,
//                             onChanged: (value) {
//                               bool isFirst = true;
//                               String newValue = value.replaceAll(',', '').replaceAll('.', '');
//                               double value1 = double.parse(newValue);
//                               if (!isFirst) value1 = value1 * 100;
//                               value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
//                               amountTextController.value = TextEditingValue(
//                                 text: value,
//                                 selection: TextSelection.collapsed(offset: value.length),
//                               );
//                               setState(() {
//                                 amountSlider = double.tryParse(value.replaceAll(',', '')) ?? 0.00;
//
//                                 print('amountSlider:${amountSlider}');
//                                 print('value:${value}');
//                               });
//                               // print('TextEdit:$value');
//                             },
//                             style: const TextStyle(color: Color(0xff757575), fontSize: 15, fontFamily: 'Gilroy Medium'),
//                             decoration: const InputDecoration(
//                               // hintText: "12,450.00",
//                               border: InputBorder.none,
//                             ),
//                             maxLines: 1,
//                           )),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           InkWell(
//                             child: SvgPicture.asset('assets/svg/edit_button.svg'),
//                             onTap: () {
//                               amountFocus.requestFocus();
//                             },
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   SliderTheme(
//                     data: SliderThemeData(
//                       thumbShape: SliderThumbShape(inColor: 0xffFFBE78),
//                       overlayShape: SliderComponentShape.noOverlay,
//                     ),
//                     child: Slider(
//                       activeColor: Color(0xffFFBE78),
//                       // inactiveColor: Color(0xffDEFFF0),
//                       min: minValue,
//                       max: maxValue,
//                       value: amountSlider,
//                       onChanged: (value) => {
//                         setState(() {
//                           // print('minValue:${minValue}');
//
//                           print('amountSliders:${amountSlider}');
//
//                           amountSlider = value.roundToDouble();
//                           print(' after amountSliders:${amountSlider}');
//                           //  print('value:${value.runtimeType}');
//                           double newValue = amountSlider * 100;
//                           // print('newValue:${newValue}');
//
//                           var convertedValue = NumberFormat.currency(customPattern: '###,###.##').format(newValue / 100);
//                           //  print('convertedValue:${convertedValue.runtimeType}');
//
//                           // double value1 =
//                           //value=newValue;
//                           amountTextController.text = convertedValue;
//                           print('value after:${value}');
//
//                           // print('Slider: ${budgetTextController.text}');
//                         })
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
//                     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                       const Text(
//                         "0",
//                         style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 15, color: Color(0xff7d7d7d)),
//                       ),
//                       Text(
//                         _formattedAmount,
//                         style: const TextStyle(fontFamily: 'Gilroy Light', fontSize: 15, color: Color(0xff7d7d7d)),
//                       ),
//                     ]),
//                   ),
//                 ],
//               ),
//             ),
//             Spacer(),
// //SaveButton
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                   child: InkWell(
//                     onTap: () {
//                       updateAccountData();
//                       Get.back();
//                       // addCustomCategory();
//                       // print('$newCategoryBg, $newCategoryLogo');
//                       // if(budgetTextController.text != widget.data![0]['budgetedAmount']){
//                       //   print('Amount Changed');
//                       // }else{
//                       //   snackBarWidget("Hi", "We don't find any changes.");
//                       // }
//                       // showDialog(context: context, barrierColor: Colors.transparent, builder: (_) => CategorySelect());
//                     },
//                     child: Container(
//                       decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(40))),
//                       child: const Padding(
//                         padding: EdgeInsets.all(10.0),
//                         child: Center(
//                             child: Text(
//                           'Save',
//                           style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Medium', color: Colors.white),
//                         )),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   updateAccountData() async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = FirebaseAuth.instance.currentUser;
//
//     var query = await firebaseFirestore.collection("UserData").doc(user?.uid);
//
//     query.get().then((value) {
//       var accountList = value.data()!['accounts'];
//       // print(categoryList);
//
//       var editList = [
//         {
//           'accountId': widget.accountData['accountId'],
//           'accountName': accountTextController.text,
//           'accountType': accountType,
//           'amountBalance': amountTextController.text,
//           'currency': 'INR',
//           'isAvailable': 'Y',
//         }
//       ];
//
//       // print('EditList: ${editList}');
//       // print('EditListAccount: ${editList[0]['accountId']}');
//
//       for (int i = 0; i < accountList.length; i++) {
//         if (accountList[i]['accountId'] == editList[0]['accountId']) {
//           List newList = [];
//           newList.add(accountList[i]);
//           // print('Data: ${newList}');
//           query.update({'accounts': FieldValue.arrayRemove(newList)});
//           query.update({'accounts': FieldValue.arrayUnion(editList)});
//         }
//       }
//     });
//
//     Get.to(() => HomePage());
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/widgets/limit_amount.dart';

import '../../constants/svg_constant.dart';
import '../slider_thumb_shape.dart';
class AccountEditPopUp extends StatefulWidget {
  final Map accountData;
  const AccountEditPopUp({Key? key, required this.accountData}) : super(key: key);

  @override
  State<AccountEditPopUp> createState() => _AccountEditPopUpState();
}

class _AccountEditPopUpState extends State<AccountEditPopUp> {
  double minValue = 0.00;
  double maxValue = 25000.00;
  bool status = true;
  bool debit = false;
  bool credit = true;
  String accountType = "";
  double amountSlider = 0.00;
  TextEditingController accountTextController = TextEditingController();
  TextEditingController amountTextController = TextEditingController();
  final FocusNode amountFocus = FocusNode();
  final FocusNode accountTextFocus = FocusNode();

  final _formattedAmount = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
  ).format(25000);

  @override
  void initState() {
    super.initState();
    accountTextController.text = widget.accountData['accountName'];
    amountTextController.text = widget.accountData['amountBalance'].replaceAll(',', '');
    print('amount controller:${double.parse(amountTextController.text).runtimeType}');
    print('amount controller:${widget.accountData['amountBalance']}');
    amountSlider = double.parse(widget.accountData['amountBalance'].replaceAll(',', ''));
//minValue = double.parse(amountTextController.text);
    if (widget.accountData['accountType'] == 'Savings') {
      setState(() {
        status = false;
        debit = true;
        credit = false;
        accountType = 'Savings';
      });
    } else if (widget.accountData['accountType'] == 'Credit') {
      setState(() {
        status = true;
        debit = false;
        credit = true;
        accountType = 'Credit Card';
      });
    } else if (widget.accountData['accountType'] == 'Cash') {
      setState(() {
        accountType = 'Cash';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
// print(widget.accountData);
    return AlertDialog(
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
        height: MyUtility(context).height / 2.15,
        width: MyUtility(context).width,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
// debit/credit
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Savings', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: debit ? Colors.black : const Color(0xff81786f))),
                const SizedBox(
                  width: 5,
                ),
                FlutterSwitch(
                  width: 50.0,
                  height: 30.0,
                  activeIcon: SvgPicture.asset(swtichOnIconYellow),
                  inactiveIcon: SvgPicture.asset(swtichOffIconYellow),
                  activeColor: const Color(0xffffffff),
                  inactiveColor: const Color(0xffffffff),
                  activeToggleColor: const Color(0xffFFBA41),
                  inactiveToggleColor: const Color(0xffFFBA41),
                  toggleSize: 25.0,
                  value: status,
                  borderRadius: 30.0,
                  padding: 3.0,
                  onToggle: (val) {
                    setState(() {
                      status = val;
                      if (status == true) {
                        debit = false;
                        credit = true;
                        setState(() {
                          accountType = 'Credit Card';
                        });
                      } else {
                        debit = true;
                        credit = false;
                        setState(() {
                          accountType = 'Savings';
                        });
                      }
                    });
// print('status: $accountType');
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('Credit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: credit ? Colors.black : const Color(0xff81786f)))
              ],
            ),
            SizedBox(
              height: 10,
            ),
// account name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntrinsicWidth(
// width: 150,
                    child: TextField(
                      controller: accountTextController,
                      focusNode: accountTextFocus,
                      style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Gilroy SemiBold'),
                      decoration: InputDecoration(
                        hintText: accountTextController.text,
                        border: InputBorder.none,
                      ),
                      maxLines: 1,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: InkWell(
                    child: SvgPicture.asset('assets/svg/edit_button.svg'),
                    onTap: () {
                      accountTextFocus.requestFocus();
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
// amount

// Available
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Balance',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Gilroy SemiBold',
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Text(
                            '\u{20B9} ',
                            style: TextStyle(color: Color(0xff757575), fontSize: 15, fontFamily: 'Gilroy Medium'),
                          ),
                          IntrinsicWidth(
                              child: TextField(
                                controller: amountTextController,
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
                                  amountTextController.value = TextEditingValue(
                                    text: value,
                                    selection: TextSelection.collapsed(offset: value.length),
                                  );
                                  setState(() {
                                    amountSlider = double.tryParse(value.replaceAll(',', '')) ?? 0.00;

                                    print('amountSlider:${amountSlider}');
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
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            child: SvgPicture.asset('assets/svg/edit_button.svg'),
                            onTap: () {
                              amountFocus.requestFocus();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbShape: SliderThumbShape(inColor: 0xffFFBE78),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      activeColor: Color(0xffFFBE78),
// inactiveColor: Color(0xffDEFFF0),
                      min: minValue,
                      max: maxValue,
                      value: amountSlider,
                      onChanged: (value) => {
                        setState(() {
// print('minValue:${minValue}');

                          print('amountSliders:${amountSlider}');

                          amountSlider = value.roundToDouble();
                          print(' after amountSliders:${amountSlider}');
//  print('value:${value.runtimeType}');
                          double newValue = amountSlider * 100;
// print('newValue:${newValue}');

                          var convertedValue = NumberFormat.currency(customPattern: '###,###.##').format(newValue / 100);
//  print('convertedValue:${convertedValue.runtimeType}');

// double value1 =
//value=newValue;
                          amountTextController.text = convertedValue;
                          print('value after:${value}');

// print('Slider: ${budgetTextController.text}');
                        })
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text(
                        "0",
                        style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 15, color: Color(0xff7d7d7d)),
                      ),
                      Text(
                        _formattedAmount,
                        style: const TextStyle(fontFamily: 'Gilroy Light', fontSize: 15, color: Color(0xff7d7d7d)),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Spacer(),
//SaveButton
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: InkWell(
                    onTap: () {
                      updateAccountData();
                      Get.back();
// addCustomCategory();
// print('$newCategoryBg, $newCategoryLogo');
// if(budgetTextController.text != widget.data![0]['budgetedAmount']){
//   print('Amount Changed');
// }else{
//   snackBarWidget("Hi", "We don't find any changes.");
// }
// showDialog(context: context, barrierColor: Colors.transparent, builder: (_) => CategorySelect());
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
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  updateAccountData() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    var query = await firebaseFirestore.collection("UserData").doc(user?.uid);

    query.get().then((value) {
      var accountList = value.data()!['accounts'];
// print(categoryList);

      var editList = [
        {
          'accountId': widget.accountData['accountId'],
          'accountName': accountTextController.text,
          'accountType': accountType,
          'amountBalance': amountTextController.text,
          'currency': 'INR',
          'isAvailable': 'Y',
        }
      ];

// print('EditList: ${editList}');
// print('EditListAccount: ${editList[0]['accountId']}');

      for (int i = 0; i < accountList.length; i++) {
        if (accountList[i]['accountId'] == editList[0]['accountId']) {
          List newList = [];
          newList.add(accountList[i]);
// print('Data: ${newList}');
          query.update({'accounts': FieldValue.arrayRemove(newList)});
          query.update({'accounts': FieldValue.arrayUnion(editList)});
        }
      }
    });

    Get.to(() => HomePage());
  }
}