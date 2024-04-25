// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:personal_finance_management/constants/color.dart';
// import 'package:personal_finance_management/constants/my_utility.dart';
// import 'package:personal_finance_management/models/transaction_model.dart';
// import 'package:personal_finance_management/pages/homePage.dart';
// import 'package:personal_finance_management/widgets/animation_search_widget.dart';
// import 'package:personal_finance_management/widgets/custom_progress_indicator.dart';
// import 'package:personal_finance_management/widgets/snack_bar_widget.dart';
//
// import '../HomeScreens/transaction_view.dart';
//
// class NewTransactionPage extends StatefulWidget {
//   const NewTransactionPage({Key? key}) : super(key: key);
//
//   @override
//   State<NewTransactionPage> createState() => _NewTransactionPageState();
// }
//
// class _NewTransactionPageState extends State<NewTransactionPage> {
//   String transactionLastUpdate = ""; //created/Last update Date & Time
//   String transactionTypeDB = "Debit"; // transaction type
//   String transactionCurrencyDB = ""; // currency
//   String transactionAmountDB = ""; // Amount
//   String transactionCategoryDB = ""; // Category
//   String transactionAccountIDDB = ""; // Account ID
//   String transactionAccountName = ""; // Account Name
//   String transactionAccountType = ""; // Account Type
//   String transactionAccountBalance = "";// Account Balance
//   String transactionUntaggedDB = ""; // Untagged
//   String transactionAutoDB = ""; // Auto
//   String transDateDB = ""; // Transaction Date
//   String transactionIDDB = ""; // Transaction ID
//   String transactionTransferDB = ""; // Transfer
//   String transactionToAccountDB = ""; // To Account ID
//   String transCatColor = ""; //category color
//   String transCatIcon = ""; // categoryIcon
//
//   DateTime initialDate = DateTime.now();
//   var inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
//   String transactionDD = "";
//   String transactionMMM = "";
//   bool transactionDateSet = false;
//   // String transactionType = "Debit";
//   bool status = false;
//   final FocusNode amountFocus = FocusNode();
//   TextEditingController amountTextController = TextEditingController();
//   bool isFirst = true;
//   bool categoryVisible = true;
//   bool searchBarIcon = true;
//   bool categorySearch = false;
//   bool selectedCategory = false;
//
//   TextEditingController searchTextController = TextEditingController();
//   int categoryIndex = 0;
//   int selectedCard = 100;
//   int newBgColor = 0;
//   bool onSelected = false;
//   List<Map<String, dynamic>> accountList = [];
//   List<Map<String, dynamic>> categoriesList = [];
//
//   getUid() {
//     User? user = FirebaseAuth.instance.currentUser;
//     final uid = user!.uid;
//     // print('uid out: $uid');
//     return uid;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     amountTextController.dispose();
//   }
//
//   Future<void> _transactionDate(BuildContext context) async {
//     final DateTime? selectedDate = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2022, 1),
//       initialDate: initialDate,
//       lastDate: DateTime(2050),
//       helpText: 'Select Transaction Date',
//     );
//     if (selectedDate != null && selectedDate != initialDate) {
//       setState(() {
//         initialDate = selectedDate;
//         transactionDD = DateFormat.d().format(initialDate);
//         transactionMMM = DateFormat.MMM().format(initialDate);
//         transDateDB = inputFormat.format(initialDate);
//         // transDateDB = transactionLastUpdate;
//         print('transactionDateDB: $transDateDB');
//         transactionDateSet = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(25),
//             child: SingleChildScrollView(
//               child: SizedBox(
//                 // height: MyUtility(context).height * 0.85,
//                 width: MyUtility(context).width,
//                 child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
// //Select Date
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           children: <Widget>[
//                             const Text(
//                               'New Transaction',
//                               style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 30),
//                             ),
//                             RichText(
//                               textAlign: TextAlign.center,
//                               text: TextSpan(children: <TextSpan>[
//                                 const TextSpan(
//                                     text: "Is this a transfer ?",
//                                     style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 17, color: Color(0xff464646))),
//                                 TextSpan(
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = () {
//                                         // Get.to(() => const SignUpPage());
//                                       },
//                                     text: " Click here",
//                                     style: const TextStyle(
//                                       fontFamily: 'Gilroy SemiBold',
//                                       fontSize: 18,
//                                       color: Color(0xffFF9E36),
//                                     )),
//                               ]),
//                             ),
//                           ],
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             _transactionDate(context);
//                           },
//                           child: Container(
//                             decoration: const BoxDecoration(color: Color(0xffFFF0D3), borderRadius: BorderRadius.all(Radius.circular(10))),
//                             child: Padding(
//                               padding: const EdgeInsets.all(13.0),
//                               child: transactionDateSet
//                                   ? Column(
//                                 children: [
//                                   Text(
//                                     transactionDD,
//                                     style: const TextStyle(fontSize: 12, fontFamily: 'Gilroy Medium'),
//                                   ),
//                                   Text(
//                                     transactionMMM,
//                                     style: const TextStyle(fontSize: 15, fontFamily: 'Gilroy SemiBold', color: transDate),
//                                   )
//                                 ],
//                               )
//                                   : Image.asset('assets/images/calender.png'),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: MyUtility(context).height * 0.02),
// //Category List and search button
//                     Row(
//                       children: [
//                         Visibility(
//                           visible: categoryVisible,
//                           child: StreamBuilder<DocumentSnapshot>(
//                               stream: FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots(),
//                               builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                                 if (!snapshot.hasData) return const Text("Loading...");
//                                 final DocumentSnapshot? document = snapshot.data;
//                                 final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;
//
//                                 categoriesList =
//                                     (documentData['categories'] as List).map((categoriesList) => categoriesList as Map<String, dynamic>).toList();
//                                 accountList = (documentData['accounts'] as List).map((accountList) => accountList as Map<String, dynamic>).toList();
//
//                                 // print('categoriesList: $categoriesList');
//
//                                 if (categoriesList.length > 3) {
//                                   categoryIndex = 3;
//                                 } else {
//                                   categoryIndex = categoriesList.length;
//                                 }
//                                 return Container(
//                                   // color: Colors.brown,
//                                   width: 300,
//                                   height: 100,
//                                   child: ListView.builder(
//                                       shrinkWrap: true,
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: categoryIndex,
//                                       itemBuilder: (BuildContext context, int index) {
//                                         // print('Data: ${categoriesList[index]}');
//                                         return GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               selectedCard = index;
//                                               selectedCategory = !selectedCategory;
//                                               categoryVisible = false;
//                                               searchBarIcon = false;
//                                             });
//                                             transactionCategoryDB = categoriesList[index]['categoryName'];
//                                             transCatColor = categoriesList[index]['backgroundColor'];
//                                             transCatIcon = categoriesList[index]['categoryLogo'];
//
//                                             // print('sel: ${selectedCard == index ? 0.5 : 1.0}');
//                                             // print('index: $index');
//                                             // print('Text: ${categoriesList[index]['categoryName']}');
//                                           },
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Color(int.parse(categoriesList[index]['backgroundColor'])),
//                                                       shape: BoxShape.circle,
//                                                     ),
//                                                     child: Stack(
//                                                       children: [
//                                                         Opacity(
//                                                           opacity: selectedCard == index ? 0.5 : 1.0,
//                                                           child: Image.asset(
//                                                             categoriesList[index]['categoryLogo'],
//                                                             width: 60,
//                                                             height: 60,
//                                                             fit: BoxFit.contain,
//                                                           ),
//                                                         ),
//                                                         if (selectedCard == index)
//                                                           Image.asset(
//                                                             'assets/images/select_cate.png',
//                                                             width: 60,
//                                                             height: 60,
//                                                             color: Colors.white,
//                                                           ),
//                                                       ],
//                                                     )),
//                                               ),
//                                               const SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Text(
//                                                 categoriesList[index]['categoryName'],
//                                                 style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 14),
//                                               )
//                                             ],
//                                           ),
//                                         );
//                                       }),
//                                 );
//                               }),
//                         ),
// //SearchBar before selecting category
//                         Visibility(
//                           visible: searchBarIcon,
//                           child: Expanded(
//                             child: AnimatedSearchBar(
//                               style: const TextStyle(fontSize: 17, fontFamily: 'Gilroy Light', color: searchText),
//                               color: searchBar,
//                               categoryVisible: () {
//                                 setState(() {
//                                   categoryVisible = !categoryVisible;
//                                   categorySearch = !categorySearch;
//                                   // selectedCategory = !selectedCategory;
//                                 });
//                                 // print(searchTextController);
//                               },
//                               rtl: true,
//                               width: MyUtility(context).width,
//                               textController: searchTextController,
//                               onSuffixTap: () {
//                                 setState(() {
//                                   // debugPrint('Tet');
//                                   searchTextController.clear();
//                                 });
//                               },   onChanged: (value) {
//                               print("value on Change");
//                               setState(() {
//                                // searchText = value;
//                               });
//                             },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: MyUtility(context).height * 0.02),
// //searchBar Selected Category
//
//                     // Visibility(
//                     //   visible: selectedCategory,
//                     //     child:Container(
//                     //       // margin: EdgeInsets.only(top: 15, left: 15, right: 10),
//                     //       width: MyUtility(context).width,
//                     //       decoration: BoxDecoration(
//                     //           color: searchBar, borderRadius: BorderRadius.circular(30)),
//                     //       child: TextField(style: const TextStyle(fontFamily: 'Gilroy Light', fontSize: 17),
//                     //         decoration:  InputDecoration(
//                     //           suffixIcon: Image.asset('assets/images/searchIcon.png'),
//                     //           hintText: 'Category',
//                     //           border: InputBorder.none,
//                     //           contentPadding: const EdgeInsets.only(top: 15, left: 15),
//                     //         ),
//                     //         onChanged: (val) {
//                     //           setState(() {
//                     //             // title = val;
//                     //           });
//                     //         },
//                     //       ),
//                     //     ),
//                     // ),
//
// //Selected Category
//                     Visibility(
//                       visible: selectedCategory,
//                       child: Container(
//                           width: 100,
//                           height: 100,
//                           decoration: BoxDecoration(shape: BoxShape.circle, color: selectedCategory ? Color(int.parse(transCatColor)) : Colors.white),
//                           child: Stack(
//                             children: [
//                               Center(child: Image.asset(transCatIcon)),
//                               Positioned(
//                                   bottom: 0,
//                                   right: 0,
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         categorySearch = true;
//                                         categoryVisible = false;
//                                       });
//                                     },
//                                     child: Container(
//                                       decoration: const BoxDecoration(shape: BoxShape.circle, color: searchIcon),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(7.0),
//                                         child: Image.asset(
//                                           'assets/images/searchIcon.png',
//                                           width: 15,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ))
//                             ],
//                           )),
//                     ),
//                     // const Spacer(),
//                     SizedBox(height: MyUtility(context).height * 0.02),
// //Category Search
//                     Visibility(
//                       visible: categorySearch,
//                       child: GridView.builder(
//                         // physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: categoriesList.length,
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 30,
//                         ),
//                         itemBuilder: (BuildContext context, int index) {
//                           return Column(
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedCard = index;
//                                   });
//                                   transactionCategoryDB = categoriesList[index]['categoryName'];
//                                   transCatColor = categoriesList[index]['backgroundColor'];
//                                   transCatIcon = categoriesList[index]['categoryLogo'];
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Color(int.parse(categoriesList[index]['backgroundColor'])),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Stack(
//                                     children: [
//                                       Opacity(
//                                           opacity: selectedCard == index ? 0.5 : 1.0,
//                                           child: Image.asset(
//                                             categoriesList[index]['categoryLogo'],
//                                             width: 60,
//                                             height: 60,
//                                           )),
//                                       if (selectedCard == index)
//                                         Image.asset(
//                                           'assets/images/select_cate.png',
//                                           width: 60,
//                                           height: 60,
//                                           color: Colors.white,
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Text(categoriesList[index]['categoryName'].toString()),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     Visibility(
//                       visible: !categorySearch,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
// //Select Transaction Type
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               status
//                                   ? Text('Debit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black.withOpacity(0.5)))
//                                   : const Text('Debit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black)),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               FlutterSwitch(
//                                 width: 55.0,
//                                 height: 30.0,
//                                 activeIcon: SvgPicture.asset('assets/svg/switchOnIcon_yellow.svg'),
//                                 inactiveIcon: SvgPicture.asset('assets/svg/switchOffIcon_yellow.svg'),
//                                 activeColor: closeIconBg,
//                                 inactiveColor: closeIconBg,
//                                 activeToggleColor: dateSelect,
//                                 inactiveToggleColor: dateSelect,
//                                 toggleSize: 30.0,
//                                 value: status,
//                                 borderRadius: 30.0,
//                                 padding: 2.0,
//                                 onToggle: (val) {
//                                   setState(() {
//                                     status = val;
//                                     // // print('status: $status');
//                                     if (status == true) {
//                                       setState(() {
//                                         transactionTypeDB = 'Credit';
//                                       });
//                                     } else {
//                                       setState(() {
//                                         transactionTypeDB = 'Debit';
//                                       });
//                                     }
//                                   });
//                                 },
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               status
//                                   ? const Text('Credit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black))
//                                   : Text('Credit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black.withOpacity(0.5))),
//                             ],
//                           ),
//                           SizedBox(height: MyUtility(context).height * 0.02),
// //Amount
//                           Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     '\u{20B9}',
//                                     style: TextStyle(color: status ? rupeeCredit : rupeeDebit, fontSize: 25),
//                                   ),
//                                   IntrinsicWidth(
//                                     child: TextField(
//                                       textAlign: TextAlign.center,
//                                       controller: amountTextController,
//                                       focusNode: amountFocus,
//                                       keyboardType: TextInputType.number,
//                                       onChanged: (value) {
//                                         String newValue = value.replaceAll(',', '').replaceAll('.', '');
//                                         if (value.isEmpty || newValue == '00') {
//                                           amountTextController.clear();
//                                           isFirst = true;
//                                           return;
//                                         }
//                                         double value1 = double.parse(newValue);
//                                         if (!isFirst) value1 = value1 * 100;
//                                         value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
//                                         amountTextController.value = TextEditingValue(
//                                           text: value,
//                                           selection: TextSelection.collapsed(offset: value.length),
//                                         );
//                                       },
//                                       style: TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold', color: status ? rupeeCredit : rupeeDebit),
//                                       decoration: InputDecoration(
//                                         hintText: "0.00 ",
//                                         hintStyle: TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold', color: status ? rupeeCredit : rupeeDebit),
//                                         border: InputBorder.none,
//                                       ),
//                                       maxLines: 1,
//                                     ),
//                                   ),
//                                   InkWell(
//                                     child: SvgPicture.asset(
//                                       'assets/svg/edit_button.svg',
//                                       color: rupeeSymbol,
//                                     ),
//                                     onTap: () {
//                                       amountFocus.requestFocus();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               Container(
//                                 width: MyUtility(context).width * 0.5,
//                                 decoration: const BoxDecoration(
//                                   color: dateSelect,
//                                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         ' Available',
//                                         style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 13, color: Colors.black.withOpacity(0.75)),
//                                       ),
//                                       const Text(
//                                         ' \u{20B9} 5,000.00',
//                                         style: TextStyle(fontFamily: 'Gilroy Bold', fontSize: 15, color: amount),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: MyUtility(context).height * 0.05),
// //select Account
//                           Stack(
//                             children: [
//                               Positioned(
//                                 bottom: 40,
//                                 child: Container(
//                                   width: MyUtility(context).width - 50,
//                                   height: MyUtility(context).height * 0.075,
//                                   decoration: const BoxDecoration(
//                                     color: closeIconBg,
//                                     // color: Colors.grey,
//                                     borderRadius: BorderRadius.all(Radius.circular(50)),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Image.asset('assets/images/account_arrow_left.png'),
//                                         Image.asset('assets/images/account_arrow_right.png'),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 150,
//                                 child: ListWheelScrollView(
//                                     itemExtent: 50,
//                                     useMagnifier: true,
//                                     magnification: 1.3,
//                                     onSelectedItemChanged: (int index) {
//                                       setState(() {
//                                         transactionAccountIDDB = accountList[index]['accountId'];
//                                         transactionAccountName = accountList[index]['accountName'];
//                                         transactionAccountType = accountList[index]['accountType'];
//                                         transactionAccountBalance = accountList[index]['amountBalance'];
//                                       });
//                                       // print('selectedAccount: $selectedAccount');
//                                     },
//                                     children: accountList
//                                         .map(
//                                           (item) => Center(
//                                         child: Text(
//                                           item['accountName'],
//                                           style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 18),
//                                         ),
//                                       ),
//                                     )
//                                         .toList()),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: MyUtility(context).height * 0.1),
// //cancel & continue
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Get.back();
//                           },
//                           child: Container(
//                             width: MyUtility(context).width * 0.40,
//                             decoration: const BoxDecoration(
//                               color: Color(0xffF6F6F6),
//                               borderRadius: BorderRadius.all(Radius.circular(40)),
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               child: Center(
//                                   child: Text(
//                                     'Back',
//                                     style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
//                                   )),
//                             ),
//                           ),
//                         ),
//                         categorySearch
//                             ? GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               // categoryVisible = true;
//                               categorySearch = false;
//                             });
//                           },
//                           child: Container(
//                             width: MyUtility(context).width * 0.40,
//                             decoration: const BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.all(Radius.circular(40)),
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               child: Center(
//                                   child: Text(
//                                     'Continue',
//                                     style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Colors.white),
//                                   )),
//                             ),
//                           ),
//                         )
//                             : GestureDetector(
//                           onTap: () {
//                             if (amountTextController.text.isEmpty) {
//                               snackBarWidget("Help us here", "Please update the balance.");
//                               amountFocus.requestFocus();
//                             } else if (transDateDB.isEmpty) {
//                               snackBarWidget("Help us here", "Please select the transaction date.");
//                             } else {
//                               addTransaction();
//                             }
//                           },
//                           child: Container(
//                             width: MyUtility(context).width * 0.40,
//                             decoration: const BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.all(Radius.circular(40)),
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               child: Center(
//                                   child: Text(
//                                     'Done',
//                                     style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium', color: Colors.white),
//                                   )),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   generateTransactionNumber() {
//     var rng = Random();
//     var rand = rng.nextInt(5000) + 1000;
//     var date = DateTime.now();
//     var dd = DateFormat("dd").format(date);
//     var mm = DateFormat("MMM").format(date);
//     var transNum = dd + mm + transactionTypeDB == 'Credit' ? 'cre' : 'deb' + rand.toString();
//     return transNum;
//   }
//
//   addTransaction() async {
//     // print('Uid: ${getUid()}');
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     TransactionModel transactionModel = TransactionModel();
//
//     transactionModel.uid = getUid();
//     transactionModel.currency = 'INR';
//     transactionModel.accountId = transactionAccountIDDB;
//     transactionModel.accountName = transactionAccountName;
//     transactionModel.accountType = transactionAccountType;
//     transactionModel.accountTotal = transactionAccountBalance;
//     transactionModel.auto = 'Y';
//     transactionModel.transfer = 'N';
//     transactionModel.toAccountId = '';
//     transactionLastUpdate = inputFormat.format(DateTime.now());
//
//     // myProgressIndicator(context);
//
//     print('transactionAccountIDDB: $transactionAccountIDDB');
//
//     DocumentSnapshot<Map<String, dynamic>> document = await firebaseFirestore
//         .collection("UserData")
//         .doc(getUid())
//         .collection("TransactionData").doc(transactionAccountIDDB).get();
//
//     if(document.exists){
//       print('Exists');
//       await firebaseFirestore.collection("UserData").doc(getUid()).collection("TransactionData").doc(transactionAccountIDDB).update(
//           transactionModel.transaction(transDateDB, generateTransactionNumber(), transactionTypeDB,amountTextController.text, 'N', transactionCategoryDB,
//               transCatIcon,transCatColor, transactionLastUpdate, transactionLastUpdate));
//     }else{
//       print('Not Exists');
//       await firebaseFirestore
//           .collection("UserData")
//           .doc(getUid())
//           .collection("TransactionData")
//           .doc(transactionAccountIDDB)
//           .set(transactionModel.toMap());
//       await firebaseFirestore.collection("UserData").doc(getUid()).collection("TransactionData").doc(transactionAccountIDDB).update(
//           transactionModel.transaction(transDateDB, generateTransactionNumber(), transactionTypeDB,amountTextController.text, 'N', transactionCategoryDB,
//               transCatIcon,transCatColor, transactionLastUpdate, transactionLastUpdate));
//     }
//
//     Get.to(() =>  TransactionPage());
//   }
// }
