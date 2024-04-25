import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/constants/svg_constant.dart';
import 'package:personal_finance_management/models/transaction_model.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/widgets/limit_amount.dart';
import 'package:personal_finance_management/widgets/slider_thumb_shape.dart';

class TransactionPopupPage2 extends StatefulWidget {
  final Map transactionData;
  final int index;
  const TransactionPopupPage2( {Key? key, required this.transactionData, required this.index}) : super(key: key);

  @override
  State<TransactionPopupPage2> createState() => _TransactionPopupPage2State();
}

class _TransactionPopupPage2State extends State<TransactionPopupPage2> {
  double minValue = 0.00;
  double maxValue = 25000.00;
  String transactionCategoryDB = "";
  String transCatColor = ""; //category color
  String transCatIcon = "";
  String transactionCategoryName = "";
  bool categoryVisible = true;
  bool categorySearch = false;
  int categoryIndex = 0;
  int selectedCard = 100;
  bool selectedCategory = false;
  bool searchBarIcon = true;
  bool status = false;
  bool credit = false;
  bool debit = true;
  String transactionType='';
  var amountController = TextEditingController();
  final FocusNode amountFocus = FocusNode();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController searchEditingController = TextEditingController();
  List<Map<String, dynamic>> categoriesList = [];
  List<Map<String, dynamic>> accountList = [];
  final PageController _controller = PageController(
    initialPage: 0,
  );
  int pageNumber = 0;
  DateTime selectedDate = DateTime.now();
  double amountSlider = 0.00;
  final _formattedAmount = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '',
  ).format(25000);
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  var query;
  List<Map<String, dynamic>> searchData = [];
  final FocusNode searchFocus = FocusNode();
  String transactionAccountIDDB ='';
  String transactionAccountName ='';
  String transactionAccountType ='';
  String  transactionAccountBalance='';
  String transactionLastUpdate = "";
  var inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  String transDateDB = "";
  String amountValue = "";

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    // print('uid out: $uid');
    return uid;
  }
  searchList(String searchValue) {
    setState(() {
      searchData = categoriesList.where((element) => element['categoryName'].toLowerCase().contains(searchValue.toLowerCase())).toList();
    });
  }
  void initState() {
    super.initState();
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(widget.transactionData['lastUpdatedDate']);
    selectedDate = tempDate;
    query = firebaseFirestore.collection("UserData").doc(user?.uid);
    amountController.text=widget.transactionData['transactionAmount'];
    transDateDB =widget.transactionData['transactionDate'];
    if (widget.transactionData['transactionType'] == 'Debit') {
      setState(() {
        status = false;
        debit = true;
        credit = false;
        transactionType = 'Debit';
      });
    }
    else if (widget.transactionData['transactionType'] == 'Credit') {
      setState(() {
        status = true;
        credit = true;
        debit = false;
        transactionType = 'Credit';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        height: MyUtility(context).height / 1.8,
        width: MyUtility(context).width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                  height: MyUtility(context).height / 2.3,
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (num) {
                      setState(() {
                        pageNumber = num;
                      });
                    },
                    children: [
                      pageOneWidget(),
                      pageTwoWidget(),
                    ],
                  ),
                ),
//Pagination
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      2,
                          (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                        child: AnimatedContainer(
                          curve: Curves.ease,
                          duration: const Duration(microseconds: 500),
                          width: pageNumber == index ? 35 : 10,
                          height: pageNumber == index ? 15 : 10,
                          decoration: BoxDecoration(
                            color: pageNumber == index ? Color(0xFFFFBE78) : Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              pageNumber == index ? '${index + 1}/2' : '', //$index
                              style: const TextStyle(
                                fontFamily: 'Gilroy Bold',
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
//Save Button
                GestureDetector(
                  onTap: () {
                    print('pressed');
                    updateUntagged();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        // transactionDD = DateFormat.d().format(selectedDate);
        // transactionMMM = DateFormat.MMM().format(selectedDate);
        transDateDB = inputFormat.format(selectedDate);
      });
    }
  }

  pageOneWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
// Switch
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            status
                ? Text('Debit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black.withOpacity(0.5)))
                : const Text('Debit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black)),
            const SizedBox(
              width: 5,
            ),
            FlutterSwitch(
              width: 40.0,
              height: 25.0,
              activeIcon: SvgPicture.asset(swtichOnIconYellow),
              inactiveIcon: SvgPicture.asset(swtichOffIconYellow),
              activeColor: const Color(0xffffffff),
              inactiveColor: const Color(0xffffffff),
              activeToggleColor: const Color(0xffFFBA41),
              inactiveToggleColor: const Color(0xffFFBA41),
              toggleSize: 20.0,
              value: status,
              borderRadius: 30.0,
              padding: 3.0,
              onToggle: (val) {
                setState(() {
                  status = val;
                  if (status == true) {
                    debit = false;
                    credit = true;
                    transactionType = 'Credit';
                  } else {
                    debit = true;
                    credit = false;
                    transactionType = 'Debit';
                  }
                });
              },
            ),
            const SizedBox(
              width: 5,
            ),
            status
                ? const Text('Credit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black))
                : Text('Credit', style: TextStyle(fontFamily: "Gilroy Medium", fontSize: 20, color: Colors.black.withOpacity(0.5)))
          ],
        ),

//Amount & slider
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amount',
                  style: TextStyle(fontSize: 20, fontFamily: 'Gilroy Medium', color: Color(0xff2d2d2d)),
                ),
                Row(
                  children: <Widget>[
                     const Text(
                      '\u{20B9} ',
                      style: TextStyle(color: Color(0xff757575), fontSize: 20, fontFamily: 'Gilroy Medium'),
                    ),
                    IntrinsicWidth(
                        child: TextField(
                          controller: amountController,
                          inputFormatters: [
                            LimitRange(0, 25000),
                          ],
                          focusNode: amountFocus,
                          // onChanged: (value) {
                          //   bool isFirst = true;
                          //   String newValue = value.replaceAll(',', '').replaceAll('.', '');
                          //   double value1 = double.parse(newValue);
                          //   if (!isFirst) value1 = value1 * 100;
                          //   value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
                          //   amountController.value = TextEditingValue(
                          //     text: value,
                          //     selection: TextSelection.collapsed(offset: value.length),
                          //   );
                          //   setState(() {
                          //     amountSlider = double.tryParse(value) ?? 0.00;
                          //   });
                          // },
                          onChanged: (value) {
                            setState(() {
                            bool isFirst = true;
                            String newValue = value.replaceAll(',', '').replaceAll('.', '');
                            if (value.isEmpty || newValue == '00') {
                              amountController.clear();
                              isFirst = true;
                              return;
                            }
                            double value1 = double.parse(newValue);
                            if (!isFirst) value1 = value1 * 100;
                            value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
                            amountValue = value.contains(',') ? value.replaceAll(',', '') : value;
                            amountController.value = TextEditingValue(
                              text: value,
                              selection: TextSelection.collapsed(offset: value.length),
                            );
                              amountSlider = double.tryParse(value) ?? 0.00;
                            });
                          },
                          style: const TextStyle(color: Color(0xff757575), fontSize: 20, fontFamily: 'Gilroy Medium'),
                          decoration: const InputDecoration(
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
            const SizedBox(
              height: 10,
            ),
            SliderTheme(
              data: SliderThemeData(
                thumbShape: SliderThumbShape(inColor: 0xffFFBE78),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                activeColor: const Color(0xffFFBE78),
                min: minValue,
                max: maxValue,
                value: amountSlider,
                onChanged: (value) => {
                  setState(() {
                    amountSlider = value.roundToDouble();
                    double newValue = amountSlider * 100;
                    var convertedValue = NumberFormat.currency(customPattern: '###,###.##').format(newValue / 100);
                    amountController.text = convertedValue;
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

// Date
        Container(
          decoration: const BoxDecoration(
            color: Color(0xffFEF8F1),
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20, color: Color(0xff2d2d2d)),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: SvgPicture.asset(
                        'assets/svg/edit_button.svg',
                        color: const Color(0xffFFBE78),
                      ),
                    ),
                    const SizedBox(height: 20, child: VerticalDivider(color: Color(0xffACACAC))),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: SvgPicture.asset('assets/svg/calender.svg'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  pageTwoWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Visibility(
                      visible: categoryVisible,
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: query.snapshots(),
                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) return const Text("Loading...");
                            final DocumentSnapshot? document = snapshot.data;
                            final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;
                            categoriesList =
                                (documentData['categories'] as List).map((categoriesList) => categoriesList as Map<String, dynamic>).toList();
                            accountList = (documentData['accounts'] as List).map((accountList) => accountList as Map<String, dynamic>).toList();
                            accountList.insert(0, {'accountName': "Select Account"});
                            if (categoriesList.length > 3) {
                              categoryIndex = 3;
                            } else {
                              categoryIndex = categoriesList.length;
                            }
                            return Container(
                              width: 220,
                              height: 100,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categoryIndex,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = !selectedCategory;
                                          transactionCategoryName = categoriesList[index]['categoryName'];
                                          transCatColor = categoriesList[index]['backgroundColor'];
                                          transCatIcon = categoriesList[index]['categoryLogo'];
                                          selectedCard = index;
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(int.parse(categoriesList[index]['backgroundColor'])),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Opacity(
                                                      opacity: selectedCard ==   index ? 0.5 : 1.0,
                                                      child: Image.asset(
                                                        categoriesList[index]['categoryLogo'],
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                    if ( selectedCard ==   index )
                                                      Image.asset(
                                                        'assets/images/select_cate.png',
                                                        width: 50,
                                                        height: 50,
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
                            );
                          }),
                    ),
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
                            icon: const Icon(
                              Icons.search,
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                //select Account
                Stack(
                  children: [
                    Positioned(
                      bottom: 40,
                      child: Container(
                        width: MyUtility(context).width - 110,
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
                      height: 140,
                      child: ListWheelScrollView(
                          itemExtent: 50,
                          useMagnifier: true,
                          magnification: 1,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              transactionAccountIDDB = accountList[index]['accountId'];
                              transactionAccountName = accountList[index]['accountName'];
                              transactionAccountType = accountList[index]['accountType'];
                              transactionAccountBalance = accountList[index]['amountBalance'];
                            });
                            },
                          children: accountList.map((item) {
                            // print('Item: ${item['accountName']}');
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
                      const SizedBox(
                        height: 5,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: searchEditingController.text.isEmpty?categoriesList.length:searchData.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 30,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    transactionCategoryName = searchEditingController.text.isEmpty?categoriesList[index]['categoryName']:searchData[index]['categoryName'];
                                    transCatColor = searchEditingController.text.isEmpty?categoriesList[index]['backgroundColor']:searchData[index]['backgroundColor'];
                                    transCatIcon = searchEditingController.text.isEmpty?categoriesList[index]['categoryLogo']:searchData[index]['categoryLogo'];
                                    selectedCard = index;
                                  });
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
              ],
            ),

          ],
        ),
      ),
    );
  }

  updateUntagged()  async {
    //delete untagged
    var query1 = firebaseFirestore.collection("UserData").doc(user?.uid).collection("TransactionData").doc('Untagged').get().then((docSnapshot) {
      if (docSnapshot.exists) {
        var data = docSnapshot.data();
        var transactionList = List.from(data!['transaction']);

        if (widget.index >= 0 && widget.index < transactionList.length) {
          transactionList.removeAt(widget.index);
          data!['transaction'] = transactionList;
          firebaseFirestore.collection("UserData").doc(user?.uid).collection("TransactionData").doc('Untagged').update(data!).then((_) {
            print('Index ${widget.index} deleted successfully');
          }).catchError((error) {
            print('Error: $error');
          });
        } else {
          print('Invalid : ${widget.index}');
        }
      }
    });

    // update untagged

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
    if (document.exists) {
      print('Exists');

      await firebaseFirestore
          .collection("UserData")
          .doc(getUid())
          .collection("TransactionData")
          .doc(transactionAccountIDDB)
          .update(transactionModel.transaction(transDateDB,transactionAccountIDDB , transactionType, amountController.text, 'N', transactionCategoryName, transCatIcon, transCatColor, transactionLastUpdate, transactionLastUpdate));
      accountList.removeAt(0);
      var query = await firebaseFirestore.collection("UserData").doc(user?.uid);
      accountList.forEach((element) {
        double accountAvailable = 0;
        List<Map<String, dynamic>> editList;
        if (element['accountName'] == transactionModel.accountName && transactionType == 'Credit') {
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

        if (element['accountName'] == transactionModel.accountName && transactionType == 'Debit') {
          var amountBalance = element['amountBalance'].contains(",") ? double.parse(element['amountBalance'].replaceAll(',', '')) : double.parse(element['amountBalance']);
          var value=widget.transactionData['transactionAmount'];
          amountValue = value.contains(',') ? value.replaceAll(',', '') : value;
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
          if (transactionType == 'Credit') {
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
            var splitCurrentAvailable = element['availableAmount'];
            var currentAvailableData = splitCurrentAvailable.contains(",") ? double.parse(element['availableAmount'].replaceAll(',', '')) : double.parse(element['availableAmount']);
            currentAvailable = currentAvailableData - double.parse(amountValue);
            var currentAvailableDataFormat = NumberFormat("###,###.00#", "en_US");
            var currentAvailableCommaFormat = currentAvailableDataFormat.format(currentAvailable);
            currentSpent = double.parse(amountValue) + currentSpentData;
            var currentSpentDataFormat = NumberFormat("###,###.00#", "en_US");
            var currentSpentCommaFormat = currentSpentDataFormat.format(currentSpent);

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

  }
}
