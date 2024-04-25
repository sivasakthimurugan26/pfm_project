import 'dart:math';
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
import 'package:personal_finance_management/models/transaction_model.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/transactions/transfer_page.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction({Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  List transactionData = [];
  List cards = [];
  Map? _data;
  String creditTitle = 'Credit/Debit';
  String amountValue = "";
  String transactionLastUpdate = ""; //created/Last update Date & Time
  String transactionTypeDB = "Debit"; // transaction type
  String transactionCurrencyDB = ""; // currency
  String transactionAmountDB = ""; // Amount
  String transactionCategoryDB = ""; // Category
  String transactionAccountIDDB = ""; // Account ID
  String transactionAccountName = ""; // Account Name
  String transactionAccountType = ""; // Account Type
  String transactionAccountBalance = ""; // Account Balance
  String transactionUntaggedDB = ""; // Untagged
  String transactionAutoDB = ""; // Auto
  String transDateDB = ""; // Transaction Date
  String transactionIDDB = ""; // Transaction ID
  String transactionTransferDB = ""; // Transfer
  String transactionToAccountDB = ""; // To Account ID
  String transCatColor = ""; //category color
  String transCatIcon = ""; // categoryIcon
  DateTime initialDate = DateTime.now();
  var inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  String transactionDD = "";
  String transactionMMM = "";
  bool transactionDateSet = false;
  bool status = false;
  final FocusNode amountFocus = FocusNode();
  final FocusNode searchFocus = FocusNode();
  TextEditingController amountTextController = TextEditingController();
  bool isFirst = true;
  bool categoryVisible = true;
  bool searchBarIcon = true;
  bool categorySearch = false;
  bool selectedCategory = false;
  TextEditingController searchTextController = TextEditingController();
  int categoryIndex = 0;
  int selectedCard = 100;
  int newBgColor = 0;
  bool onSelected = false;
  List<Map<String, dynamic>> accountList = [];
  List<Map<String, dynamic>> categoriesList = [];
  List<Map<String, dynamic>> searchData = [];

  TextEditingController searchEditingController = TextEditingController();

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }

  searchList(String searchValue) {
    setState(() {
      searchData = categoriesList.where((element) => element['categoryName'].toLowerCase().contains(searchValue.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    accountList = [];
    super.initState();
  }

  Future<void> getMethod() async {
    await FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').get().then((value) {
      cards = [];
      value.docs.forEach((element) {
        if(element.data()['transaction'] == null){
          cards += element.data()['transaction'];
        }
        else{
          cards.add(element.data()['transaction']);
        }
      });

      setState(() {
        transactionData = cards;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    amountTextController.dispose();
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
        print('transactionDateDB: $transDateDB');
        transactionDateSet = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MyUtility(context).width,
                  child: Column(
                    children: [
//Select Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: <Widget>[
                              const Text(
                                'New Transaction',
                                style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 30),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  const TextSpan(text: "Is this a transfer ?", style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 17, color: Color(0xff464646))),
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                           Get.to(() => const TransferPage());
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
//Category List and search button
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('UserData').doc(getUid()).snapshots(),
                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) return const Text("Loading...");
                            final DocumentSnapshot? document = snapshot.data;
                            final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;
                            categoriesList = (documentData['categories'] as List).map((categoriesList) => categoriesList as Map<String, dynamic>).toList();
                            accountList = (documentData['accounts'] as List).map((accountList) => accountList as Map<String, dynamic>).toList();
                            accountList.insert(0, {'accountName': "Select Account"});
                            // print('accountList: $accountList');
                            // print('categoriesList: $categoriesList');

                            if (categoriesList.length > 3) {
                              categoryIndex = 3;
                            } else {
                              categoryIndex = categoriesList.length;
                            }
                            return Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Visibility(
                                          visible: categoryVisible,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MyUtility(context).width*.7,
                                                height: MyUtility(context).height*.12,

                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: categoryIndex,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      // print('Data: ${categoriesList[index]}');
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedCard = index;
                                                            selectedCategory = !selectedCategory;
                                                            categoryVisible = false;
                                                            searchBarIcon = false;
                                                          });
                                                          transactionCategoryDB = categoriesList[index]['categoryName'];
                                                          transCatColor = categoriesList[index]['backgroundColor'];
                                                          transCatIcon = categoriesList[index]['categoryLogo'];

                                                          // print('sel: ${selectedCard == index ? 0.5 : 1.0}');
                                                          // print('index: $index');
                                                          // print('Text: ${categoriesList[index]['categoryName']}');
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Color(int.parse(categoriesList[index]['backgroundColor'])),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      Opacity(
                                                                        opacity: selectedCard == index ? 0.5 : 1.0,
                                                                        child: Image.asset(
                                                                          categoriesList[index]['categoryLogo'],
                                                                          width: 60,
                                                                          height: 60,
                                                                          fit: BoxFit.contain,
                                                                        ),
                                                                      ),
                                                                      if (selectedCard == index)
                                                                        Image.asset(
                                                                          'assets/images/select_cate.png',
                                                                          width: 60,
                                                                          height: 60,
                                                                          color: Colors.white,
                                                                        ),
                                                                    ],
                                                                  )),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              categoriesList[index]['categoryName'],
                                                              style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 14),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
//SearchBar before selecting category
                                        Visibility(
                                          visible: searchBarIcon,
                                          child: Expanded(
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    categorySearch = true;
                                                    categoryVisible = false;
                                                    searchBarIcon = false;
                                                  });

                                                },
                                                icon: Icon(
                                                  Icons.search,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: MyUtility(context).height * 0.02),
                                Visibility(
                                  visible: selectedCategory,
                                  child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: selectedCategory ? Color(int.parse(transCatColor)) : Colors.white),
                                      child: Stack(
                                        children: [
                                          Center(child: Image.asset(transCatIcon)),
                                          Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    categorySearch = true;
                                                    categoryVisible = false;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: searchIcon),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(7.0),
                                                    child: Image.asset(
                                                      'assets/images/searchIcon.png',
                                                      width: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      )),
                                ),
                                SizedBox(height: MyUtility(context).height * 0.02),
                                Visibility(
                                  visible: categorySearch,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)) ,
                                        child: Container(
                                          color: Color(0xFFF6F6F6),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: TextField(
                                              focusNode: searchFocus,
                                              onChanged: (value) {
                                                setState(() {
                                                  searchList(value);
                                                  //print('searchData inside onchanged:$searchData');
                                                 // print('searchData length:${searchData.length}');
                                                });
                                              },
                                              controller: searchEditingController,
                                              decoration: const InputDecoration(hintText: " Search", suffixIcon: Icon(Icons.search),
                                                  focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width: 0, color: Color(0xF6F6F6)),),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(width: 0, color: Color(0xF6F6F6)),)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GridView.builder(
                                        // physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: searchEditingController.text.isEmpty?categoriesList.length:searchData.length,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 30,
                                        ),
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedCard = index;
                                                  });
                                                  transactionCategoryDB = searchEditingController.text.isEmpty?categoriesList[index]['categoryName']:searchData[index]['categoryName'];
                                                  transCatColor = searchEditingController.text.isEmpty?categoriesList[index]['backgroundColor']:searchData[index]['backgroundColor'];
                                                  transCatIcon = searchEditingController.text.isEmpty?categoriesList[index]['categoryLogo']:searchData[index]['categoryLogo'];
                                                //  print('seeeee:${searchData[index]['categoryName']}');
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(int.parse(searchEditingController.text.isEmpty?categoriesList[index]['backgroundColor']:searchData[index]['backgroundColor'])),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Opacity(
                                                          opacity: selectedCard == index ? 0.5 : 1.0,
                                                          child: Image.asset(
                                                            searchEditingController.text.isEmpty?categoriesList[index]['categoryLogo']:searchData[index]['categoryLogo'],
                                                            width: 60,
                                                            height: 60,
                                                          )),
                                                      if (selectedCard == index)
                                                        Image.asset(
                                                          'assets/images/select_cate.png',
                                                          width: 60,
                                                          height: 60,
                                                          color: Colors.white,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Text(searchEditingController.text.isEmpty?categoriesList[index]['categoryName'].toString():searchData[index]['categoryName']),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: !categorySearch,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
//Select Transaction Type
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          status ? Text('Debit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black.withOpacity(0.5))) : const Text('Debit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black)),
                                          const SizedBox(
                                            width: 5,
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
                                                    transactionTypeDB = 'Credit';
                                                  });
                                                } else {
                                                  setState(() {
                                                    transactionTypeDB = 'Debit';
                                                  });
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          status ? const Text('Credit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black)) : Text('Credit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black.withOpacity(0.5))),
                                        ],
                                      ),
                                      SizedBox(height: MyUtility(context).height * 0.02),
//Amount
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '\u{20B9}',
                                                style: TextStyle(color: status ? rupeeCredit : rupeeDebit, fontSize: 25),
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
                                                  style: TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold', color: status ? rupeeCredit : rupeeDebit),
                                                  decoration: InputDecoration(
                                                    hintText: "0.00 ",
                                                    hintStyle: TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold', color: status ? rupeeCredit : rupeeDebit),
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
                                                    style: TextStyle(fontFamily: 'Gilroy Bold', fontSize: 15, color: amount),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: MyUtility(context).height * 0.05),
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
                                          SizedBox(
                                            height: 150,
                                            child: ListWheelScrollView(
                                                itemExtent: 50,
                                                useMagnifier: true,
                                                magnification: 1.3,
                                                onSelectedItemChanged: (int index) {
                                                  setState(() {
                                                    transactionAccountIDDB = accountList[index]['accountId'];
                                                    transactionAccountName = accountList[index]['accountName'];
                                                    transactionAccountType = accountList[index]['accountType'];
                                                    transactionAccountBalance = accountList[index]['amountBalance'];
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
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),



                      SizedBox(height: MyUtility(context).height * 0.1),
//cancel & continue
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('categorySearch:$categorySearch');
                              if(categorySearch == false) {
                                // setState(() {
                                //   categorySearch = true;
                                // });
                                Get.back();
                              }
                               else{
                                setState(() {
                                  categoryVisible=true;
                                   categorySearch = false;
                                   searchBarIcon=true;
                                });
                              }
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
                          categorySearch
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      categoryVisible = false;
                                      categorySearch = false;
                                      selectedCategory = true;
                                      searchBarIcon = false;
                                    });
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
                                )
                              : GestureDetector(
                                  onTap: () {
                                    if (amountTextController.text.isEmpty) {
                                      snackBarWidget("Help us here", "Please update the balance.");
                                      amountFocus.requestFocus();
                                    } else if (transDateDB.isEmpty) {
                                      snackBarWidget("Help us here", "Please select the transaction date.");
                                    } else {
                                      addTransaction();
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
      ),
    );
  }

  generateTransactionNumber() {
    var rng = Random();
    var rand = rng.nextInt(5000) + 1000;
    var date = DateTime.now();
    var dd = DateFormat("dd").format(date);
    var mm = DateFormat("MMM").format(date);
    var transNum = dd + mm + transactionTypeDB == 'Credit' ? 'cre' : 'deb' + rand.toString();
    return transNum;
  }

  Future<void> addTransaction() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    TransactionModel transactionModel = TransactionModel();

    transactionModel.uid = getUid();
    transactionModel.currency = 'INR';
    transactionModel.accountId = transactionAccountIDDB;
    transactionModel.accountName = transactionAccountName;
    transactionModel.accountType = transactionAccountType;
    transactionModel.accountTotal = transactionAccountBalance;
    transactionModel.auto = 'Y';
    transactionModel.transfer = 'N';
    transactionModel.toAccountId = '';
    transactionModel.transferDate = '';
    transactionLastUpdate = inputFormat.format(DateTime.now());

    DocumentSnapshot<Map<String, dynamic>> document = await firebaseFirestore.collection("UserData").doc(getUid()).collection("TransactionData").doc(transactionAccountIDDB).get();
    User? user = FirebaseAuth.instance.currentUser;
    if (document.exists) {
      print('Exists');

      await firebaseFirestore
          .collection("UserData")
          .doc(getUid())
          .collection("TransactionData")
          .doc(transactionAccountIDDB)
          .update(transactionModel.transaction(transDateDB,transactionAccountIDDB , transactionTypeDB, amountTextController.text, 'N', transactionCategoryDB, transCatIcon, transCatColor, transactionLastUpdate, transactionLastUpdate));
      accountList.removeAt(0);
      var query = await firebaseFirestore.collection("UserData").doc(user?.uid);
      accountList.forEach((element) {
        double accountAvailable = 0;
        List<Map<String, dynamic>> editList;
        if (element['accountName'] == transactionModel.accountName && transactionTypeDB == 'Credit') {
          var amountBalance = element['amountBalance'].contains(",") ? double.parse(element['amountBalance'].replaceAll(',', '')) : double.parse(element['amountBalance']);
          accountAvailable = amountBalance + double.parse(amountValue);
          var accountAvailableFormat = NumberFormat("###,###.00#", "en_US");
          var accountAvailableCommaFormat = accountAvailableFormat.format(accountAvailable);
          List newList = [];
          newList.add(element);
          editList = [
            {
              'accountId': element['accountId'],
              'accountName': element['accountName'],
              'accountType': element['accountType'],
              'amountBalance': accountAvailableCommaFormat.toString(),
              'currency': element['currency'],
              'isAvailable': element['isAvailable'],
            }
          ];
          query.update({'accounts': FieldValue.arrayRemove(newList)});
          query.update({'accounts': FieldValue.arrayUnion(editList)});
          FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').doc(element['accountId']).update({
            'accountTotal': accountAvailableCommaFormat.toString(),
          });
        }

        if (element['accountName'] == transactionModel.accountName && transactionTypeDB == 'Debit') {
          var amountBalance = element['amountBalance'].contains(",") ? double.parse(element['amountBalance'].replaceAll(',', '')) : double.parse(element['amountBalance']);
          accountAvailable = amountBalance - double.parse(amountValue);
          var accountAvailableFormat = NumberFormat("###,###.00#", "en_US");
          var accountAvailableCommaFormat = accountAvailableFormat.format(accountAvailable);
          List newList = [];
          newList.add(element);
          editList = [
            {
              'accountId': element['accountId'],
              'accountName': element['accountName'],
              'accountType': element['accountType'],
              'amountBalance': accountAvailableCommaFormat.toString(),
              'currency': element['currency'],
              'isAvailable': element['isAvailable'],
            }
          ];
          query.update({'accounts': FieldValue.arrayRemove(newList)});
          query.update({'accounts': FieldValue.arrayUnion(editList)});

          FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').doc(element['accountId']).update({
            'accountTotal': accountAvailableCommaFormat.toString(),
          });
        }
      });

      categoriesList.forEach((element) {
        var currentAvailable;
        var currentSpent;
        List<Map<String, dynamic>> editList;
        if (element['categoryName'] == transactionCategoryDB) {
          if (transactionTypeDB == 'Credit') {
            var splitCurrentAvailable = element['availableAmount'];
            var currentAvailableData = splitCurrentAvailable.contains(",") ? double.parse(element['availableAmount'].replaceAll(',', '')) : double.parse(element['availableAmount']);
            currentAvailable = double.parse(amountValue) + currentAvailableData;
            var currentAvailableDataFormat = NumberFormat("###,###.00#", "en_US");
            var currentAvailableCommaFormat = currentAvailableDataFormat.format(currentAvailable);
            editList = [
              {
                'categoryId': element['categoryId'],
                'categoryName': element['categoryName'],
                'categoryLogo': element['categoryLogo'],
                'backgroundColor': element['backgroundColor'],
                'availableCur': element['availableCur'],
                'availableAmount': currentAvailableCommaFormat.toString(),
                'budgetedCur': element['budgetedCur'],
                'budgetedAmount': element['budgetedAmount'],
                'spentAmount': element['spentAmount'],
              }
            ];
          } else {
            var splitSpentAmount = element['spentAmount'];
            var currentSpentData = splitSpentAmount.contains(",") ? double.parse(element['spentAmount'].replaceAll(',', '')) : double.parse(element['spentAmount']);
            // print('split-${splitSpentAmount.contains(",")}');
            //  print('split-${currentSpentData}');
            //  print('doubleValue-${double.parse(amountValue)}');
            var splitCurrentAvailable = element['availableAmount'];
            var currentAvailableData = splitCurrentAvailable.contains(",") ? double.parse(element['availableAmount'].replaceAll(',', '')) : double.parse(element['availableAmount']);
            currentAvailable = currentAvailableData - double.parse(amountValue);
            var currentAvailableDataFormat = NumberFormat("###,###.00#", "en_US");
            var currentAvailableCommaFormat = currentAvailableDataFormat.format(currentAvailable);
            // print('currentAvailable:$currentAvailable');
            currentSpent = double.parse(amountValue) + currentSpentData;
            var currentSpentDataFormat = NumberFormat("###,###.00#", "en_US");
            var currentSpentCommaFormat = currentSpentDataFormat.format(currentSpent);
            // print('currentAvailableDataFormat-${currentSpentDataFormat.format(currentSpent)}');

            editList = [
              {
                'categoryId': element['categoryId'],
                'categoryName': element['categoryName'],
                'categoryLogo': element['categoryLogo'],
                'backgroundColor': element['backgroundColor'],
                'availableCur': element['availableCur'],
                'availableAmount': currentAvailableCommaFormat.toString(),
                'budgetedCur': element['budgetedCur'],
                'budgetedAmount': element['budgetedAmount'],
                'spentAmount': currentSpentCommaFormat.toString(),
              }
            ];
          }
          List newList = [];
          newList.add(element);

          // print('Data: ${newList}');
          query.update({'categories': FieldValue.arrayRemove(newList)});
          query.update({'categories': FieldValue.arrayUnion(editList)});
        }
      });

      Get.to(() => HomePage());
    }
    else {
     // print('Not Exists');
      await firebaseFirestore.collection("UserData").doc(getUid()).collection("TransactionData").doc(transactionAccountIDDB).set(transactionModel.toMap());
      await firebaseFirestore
          .collection("UserData")
          .doc(getUid())
          .collection("TransactionData")
          .doc(transactionAccountIDDB)
          .update(transactionModel.transaction(transDateDB, generateTransactionNumber(), transactionTypeDB, amountTextController.text, 'N', transactionCategoryDB, transCatIcon, transCatColor, transactionLastUpdate, transactionLastUpdate));

      accountList.removeAt(0);
      var query = await firebaseFirestore.collection("UserData").doc(user?.uid);
      accountList.forEach((element) {
        // print('element:$element');
        // print('element:${element['accountName']}');
        // print('${transactionModel.accountName}');
        // print('type:$transactionTypeDB');
        double accountAvailable = 0;
        List<Map<String, dynamic>> editList;
        if (element['accountName'] == transactionModel.accountName && transactionTypeDB == 'Credit') {
          var amountBalance = element['amountBalance'].contains(",") ? double.parse(element['amountBalance'].replaceAll(',', '')) : double.parse(element['amountBalance']);
          // print('amountBalance:$amountBalance');
          // print('amount:${double.parse(amountValue)}');
          accountAvailable = amountBalance + double.parse(amountValue);
          var accountAvailableFormat = NumberFormat("###,###.00#", "en_US");
          var accountAvailableCommaFormat = accountAvailableFormat.format(accountAvailable);
          // print('accountAvailableCommaFormat:$accountAvailableCommaFormat');
          List newList = [];
          newList.add(element);
          editList = [
            {
              'accountId': element['accountId'],
              'accountName': element['accountName'],
              'accountType': element['accountType'],
              'amountBalance': accountAvailableCommaFormat.toString(),
              'currency': element['currency'],
              'isAvailable': element['isAvailable'],
            }
          ];
          query.update({'accounts': FieldValue.arrayRemove(newList)});
          query.update({'accounts': FieldValue.arrayUnion(editList)});
          FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').doc(element['accountId']).update({
            'accountTotal': accountAvailableCommaFormat.toString(),
          });
        }

        if (element['accountName'] == transactionModel.accountName && transactionTypeDB == 'Debit') {
          var amountBalance = element['amountBalance'].contains(",") ? double.parse(element['amountBalance'].replaceAll(',', '')) : double.parse(element['amountBalance']);
          // print('amountBalance:$amountBalance');
          // print('amount:${double.parse(amountValue)}');
          accountAvailable = amountBalance - double.parse(amountValue);
          var accountAvailableFormat = NumberFormat("###,###.00#", "en_US");
          var accountAvailableCommaFormat = accountAvailableFormat.format(accountAvailable);
          // print('accountAvailableCommaFormat:$accountAvailableCommaFormat');
          List newList = [];
          newList.add(element);
          editList = [
            {
              'accountId': element['accountId'],
              'accountName': element['accountName'],
              'accountType': element['accountType'],
              'amountBalance': accountAvailableCommaFormat.toString(),
              'currency': element['currency'],
              'isAvailable': element['isAvailable'],
            }
          ];
          query.update({'accounts': FieldValue.arrayRemove(newList)});
          query.update({'accounts': FieldValue.arrayUnion(editList)});

          FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').doc(element['accountId']).update({
            'accountTotal': accountAvailableCommaFormat.toString(),
          });
        }
      });

      categoriesList.forEach((element) {
        //print('elementCategory-${element['categoryName']}');
        // print('transactionCategoryDB-$transactionCategoryDB');
        var currentAvailable;
        var currentSpent;
        List<Map<String, dynamic>> editList;
        if (element['categoryName'] == transactionCategoryDB) {
          if (transactionTypeDB == 'Credit') {
            //print('elementTranscation1-${amountValue.runtimeType}');
            //print('elementTranscation2-${element['availableAmount'].runtimeType}');
            // double amountController=amountTextController.value as double;
            //print('elementTotal-${double.parse(amountValue)+double.parse(element['availableAmount'])}');
            var splitCurrentAvailable = element['availableAmount'];
            var currentAvailableData = splitCurrentAvailable.contains(",") ? double.parse(element['availableAmount'].replaceAll(',', '')) : double.parse(element['availableAmount']);
            // var currentAvailableData= double.parse(element['availableAmount'].replaceAll(',',''));
            //print('currentAvailableData-${currentAvailableData}');
            currentAvailable = double.parse(amountValue) + currentAvailableData;
            var currentAvailableDataFormat = NumberFormat("###,###.00#", "en_US");
            var currentAvailableCommaFormat = currentAvailableDataFormat.format(currentAvailable);
            //print('currentAvailableDataFormat-${currentAvailableDataFormat.format(currentAvailable)}');
            editList = [
              {
                'categoryId': element['categoryId'],
                'categoryName': element['categoryName'],
                'categoryLogo': element['categoryLogo'],
                'backgroundColor': element['backgroundColor'],
                'availableCur': element['availableCur'],
                'availableAmount': currentAvailableCommaFormat.toString(),
                'budgetedCur': element['budgetedCur'],
                'budgetedAmount': element['budgetedAmount'],
                'spentAmount': element['spentAmount'],
              }
            ];
          } else {
            var splitSpentAmount = element['spentAmount'];
            var currentSpentData = splitSpentAmount.contains(",") ? double.parse(element['spentAmount'].replaceAll(',', '')) : double.parse(element['spentAmount']);
            var splitCurrentAvailable = element['availableAmount'];
            var currentAvailableData = splitCurrentAvailable.contains(",") ? double.parse(element['availableAmount'].replaceAll(',', '')) : double.parse(element['availableAmount']);
            currentAvailable = currentAvailableData - double.parse(amountValue);
            var currentAvailableDataFormat = NumberFormat("###,###.00#", "en_US");
            var currentAvailableCommaFormat = currentAvailableDataFormat.format(currentAvailable);
            // print('currentAvailable:$currentAvailable');
            currentSpent = double.parse(amountValue) + currentSpentData;
            var currentSpentDataFormat = NumberFormat("###,###.00#", "en_US");
            var currentSpentCommaFormat = currentSpentDataFormat.format(currentSpent);
            //print('currentAvailableDataFormat-${currentSpentDataFormat.format(currentSpent)}');

            editList = [
              {
                'categoryId': element['categoryId'],
                'categoryName': element['categoryName'],
                'categoryLogo': element['categoryLogo'],
                'backgroundColor': element['backgroundColor'],
                'availableCur': element['availableCur'],
                'availableAmount': currentAvailableCommaFormat.toString(),
                'budgetedCur': element['budgetedCur'],
                'budgetedAmount': element['budgetedAmount'],
                'spentAmount': currentSpentCommaFormat.toString(),
              }
            ];
          }

          List newList = [];
          newList.add(element);
          query.update({'categories': FieldValue.arrayRemove(newList)});
          query.update({'categories': FieldValue.arrayUnion(editList)});
        }
      });
      Get.to(() => HomePage());
    }
  }
}
