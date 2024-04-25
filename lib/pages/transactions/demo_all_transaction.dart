// import 'dart:core';
// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:personal_finance_management/constants/svg_constant.dart';
// import 'package:personal_finance_management/widgets/check_box.dart';
// import 'package:personal_finance_management/widgets/reminder/dropdown.dart';
//
// import '../HomeScreens/transaction_view.dart';
// import 'new_transaction.dart';
//
// class AllTransactionDemo extends StatefulWidget {
//   const AllTransactionDemo({Key? key}) : super(key: key);
//
//   @override
//   State<AllTransactionDemo> createState() => _AllTransactionDemoState();
// }
//
// class _AllTransactionDemoState extends State<AllTransactionDemo> {
//
//   List transactionData=[];
//   bool status = true;
//
//   bool isExtended = false;
//
//   var rupeeCredit = const Color(0xff4AD66D);
//   var transAmountDebit = const Color(0xff000000);
//   String? dropDownValue;
//   String? dropDownValue_1;
//   String? dropDownValue_2;
//   dynamic unTaggedCount;
//
//   // getData() async {
//   //     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//   //     User? user = FirebaseAuth.instance.currentUser;
//   //     QuerySnapshot querySnapshot = await firebaseFirestore.collection("UserData")
//   //     .doc(user?.uid).collection('TransactionData').get();
//   //     final val = querySnapshot.docs.map((doc) => doc.data());
//   //     for(int i=0; i<val.length; i++) {
//   //       tempList.add(val);
//   //     }
//   // }
//
//   // getAmountName() {
//   //   FirebaseFirestore.instance.collection('UserData')
//   //       .doc(FirebaseAuth.instance.currentUser?.uid).snapshots()
//   // }
//
//   Future getTransactionData() async {
//     await FirebaseFirestore.instance.collection('UserData').doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection('TransactionData').get().then((subCollection) {
//       subCollection.docs.forEach((element) {
//         element.data()['transaction'].forEach((value) {
//           setState(() {
//             transactionData.add(value);
//           });
//         });
//       });
//     });
//     return transactionData;
//   }
//
//   List dropDownValues = [];
//   getDropDownValue() async {
//     var documentReference = FirebaseFirestore.instance.collection('UserData')
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .collection('TransactionData');
//     var documentSnapshot = await documentReference.get();
//
//     for(var snapshot in documentSnapshot.docs) {
//       var docID = snapshot.id;
//       dropDownValues.add(snapshot.id);
//       print('docID: $docID');
//     }
//   }
//
//   @override
//   void initState() {
//     getTransactionData();
//     getDropDownValue();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       floatingActionButton: status
//           ? FloatingActionButton.extended(
//         shape: isExtended ? CircleBorder() : null,
//         label: AnimatedSwitcher(
//           duration: Duration(milliseconds: 500),
//           transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
//             opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
//             child: SizeTransition(
//               child: child,
//               sizeFactor: animation,
//               axis: Axis.horizontal,
//             ),
//           ),
//           child: isExtended
//               ? SvgPicture.asset(
//             'assets/svg/floatIcon.svg',
//           )
//               : Row(
//             children: [
//               SvgPicture.asset(
//                 'assets/svg/floatIcon.svg',
//               ),
//               const Text(
//                 ' New',
//                 style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20, color: Color(0xffB0B0B0)),
//               ),
//             ],
//           ),
//         ),
//         backgroundColor: Colors.black,
//         elevation: 0,
//         onPressed: () {
//           setState(() {
//             // print('newtransaction:${NewTransaction}');
//           });
//           showGeneralDialog(
//             barrierDismissible: true,
//             barrierLabel: '',
//             barrierColor: Colors.black38,
//             transitionDuration: const Duration(milliseconds: 500),
//             pageBuilder: (ctx, anim1, anim2) =>  const NewTransaction(),
//             transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
//               child: FadeTransition(
//                 child: child,
//                 opacity: anim1,
//               ),
//             ),
//             context: context,
//           );
//         },
//       )
//           : null,
//
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const ScrollPhysics(),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: (){
//                         Navigator.pop(context);
//                         print('Go Back!!');
//                       },
//                       child: Image.asset('assets/images/Arrow .png'),
//                     ),
//                     const Text('All Transactions',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontFamily: 'Gilroy Medium',
//                         fontSize: 22,
//                       ),
//                     ),
//                     StreamBuilder(
//                         stream: FirebaseFirestore.instance.collection('UserData')
//                             .doc(FirebaseAuth.instance.currentUser?.uid)
//                             .collection('TransactionData').doc('unTagged').snapshots(),
//                         builder: (context, index) {
//                           FirebaseFirestore.instance.collection('UserData')
//                               .doc(FirebaseAuth.instance.currentUser?.uid)
//                               .collection('TransactionData').doc('unTagged').get().then((value) {
//                             dynamic count = value.data()!['transaction'].length;
//                             unTaggedCount = count;
//                           });
//                           return Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(
//                                   color: const Color(0xffFF6349),
//                                   borderRadius: BorderRadius.circular(25)
//                               ),
//                               child: Text('$unTaggedCount Untagged',
//                                 style: const TextStyle(
//                                   color: Color(0xffFFE3DE),
//                                   fontFamily: 'Gilroy Medium',
//                                   fontSize: 9,
//                                 ),
//                               )
//                           );
//                         }),
//
//                   ],
//                 ),
//
//               ),
//
//               SingleChildScrollView(
//                 physics: const ScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                               color: const Color(0xffFFBE78),
//                               style: BorderStyle.solid, width: 0.80),
//                         ),
//                         child: DropdownButton(
//                           borderRadius: BorderRadius.circular(30),
//                           value: dropDownValue,
//                           hint: const Text('Accounts'),
//                           icon: Image.asset('assets/images/arrow-down.png', color: const Color(0xffFFBE78),width: 25),
//                           iconSize: 24,
//                           elevation: 5,
//                           style: const TextStyle(color: Colors.black),
//                           isExpanded: false,
//
//                           underline: const SizedBox.shrink(),
//                           onChanged: (newValue) {
//                             setState(() {
//                               dropDownValue = newValue.toString();
//                             });
//                           },
//                           items: dropDownValues.map((map) {
//                             return DropdownMenuItem(
//                               value: map,
//                               child: Text(map),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                               color: const Color(0xffFFBE78),
//                               style: BorderStyle.solid, width: 0.80),
//                         ),
//                         child: DropdownButton(
//                           borderRadius: BorderRadius.circular(30),
//                           value: dropDownValue_1,
//                           hint: const Text('Sort'),
//                           icon: Image.asset('assets/images/arrow-down.png',
//                               color: const Color(0xffFFBE78),width: 25),
//                           iconSize: 24,
//                           elevation: 5,
//                           style: const TextStyle(color: Colors.black),
//                           isExpanded: false,
//
//                           underline: const SizedBox.shrink(),
//                           onChanged: (newValue) {
//                             setState(() {
//                               dropDownValue_1 = newValue.toString();
//                             });
//                           },
//                           items: ['Amount (low to High)', 'Amount (High to low)', 'Untagged', 'Recent', 'Oldest'].map((map) {
//                             return DropdownMenuItem(
//                               value: map,
//                               child: Text(map),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                               color: const Color(0xffFFBE78),
//                               style: BorderStyle.solid, width: 0.80),
//                         ),
//                         child: DropdownButton(
//                           borderRadius: BorderRadius.circular(30),
//                           value: dropDownValue_2,
//                           hint: const Text('Credit/Debit'),
//                           icon: Image.asset('assets/images/arrow-down.png', color: const Color(0xffFFBE78),width: 25),
//                           iconSize: 24,
//                           elevation: 5,
//                           style: const TextStyle(color: Colors.black),
//                           isExpanded: false,
//
//                           underline: const SizedBox.shrink(),
//                           onChanged: (newValue) {
//                             setState(() {
//                               dropDownValue_2 = newValue.toString();
//                             });
//                           },
//                           items: ['Credit','Debit'].map((map) {
//                             return DropdownMenuItem(
//                               value: map,
//                               child: Text(map),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 height: 1000,
//                 child: ListView.builder(
//                     physics: ScrollPhysics(),
//                     itemCount: transactionData.length,
//                     itemBuilder: (context, index) {
//                       if(dropDownValue_1 == 'Untagged') {
//                         print('object: $transactionData');
//                       }
//                       return GestureDetector(
//                         onTap: (){
//                           print('object');
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                           child: Stack(
//                             children: [
//                               Container(
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                     color: const Color(0xffFFFFFF),
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: transactionData[index]['categoryName'] == '' //snapshot.data!.docs[index]['transaction'][index]['categoryName'] == ''
//                                           ? const Color(0xffFF6A6A)
//                                           : Colors.transparent,
//                                     )
//                                 ),
//                                 child: Image.asset(
//                                   transactionData[index]['categoryLogo'], //snapshot.data!.docs[index]['transaction'][index]['categoryLogo'].toString(),
//                                   width: 70,
//                                   // fit: BoxFit.scaleDown,
//                                 ),
//                               ),
//                               Positioned(
//                                 left: MediaQuery.of(context).size.width * 0.17,
//                                 bottom: MediaQuery.of(context).size.height * 0.005,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 15),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             transactionData[index]['categoryName'], //snapshot.data!.docs[index]['transaction'][index]['categoryName'].toString(),
//                                             style: const TextStyle(fontFamily: "Gilroy Medium", fontSize: 20),
//                                           ),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Container(
//                                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                                               decoration: BoxDecoration(
//                                                   color: transactionData[index]['categoryName'] == ''
//                                                       ? const Color(0xffFF6349)
//                                                       : Colors.transparent,
//                                                   borderRadius: BorderRadius.circular(25)
//                                               ),
//                                               child: Text(transactionData[index]['categoryName'] == ''
//                                                   ? 'Untagged' : '',
//                                                 style: const TextStyle(
//                                                   color: Color(0xffFFE3DE),
//                                                   fontFamily: 'Gilroy Medium',
//                                                   fontSize: 9,
//                                                 ),
//                                               )
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
//                                         child: Text(
//                                           transactionData[index]['transactionDate'],  //snapshot.data!.docs[index]['transaction'][index]['transactionDate'].toString(),
//                                           style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16, color: Color(0xffBABABA)),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 right: MediaQuery.of(context).size.width * 0.025,
//                                 // right: 10,
//                                 // bottom: 21,
//                                 bottom: MediaQuery.of(context).size.height * 0.025,
//                                 child: Text(
//                                   '\u{20B9} ${transactionData[index]['transactionAmount']}',
//                                   // '\u{20B9}, ${snapshot.data!.docs[index]['transaction'][index]['transactionAmount'].toString()}',
//                                   style: TextStyle(
//                                     color: transactionData[index]['transactionType'] == 'Credit' ? rupeeCredit : transAmountDebit,
//                                     fontFamily: "Gilroy Bold",
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                 ),
//               ),
//
//
//             ],
//           ),
//         ),
//       ),
//
//
//
//
//     );
//   }
// }
//
//
//
//
//
// ///
