import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/pages/notification/notifcationPage.dart';
import 'package:personal_finance_management/pages/profile/profile_view.dart';
import 'package:personal_finance_management/pages/transactions/all_transaction.dart';
import 'package:personal_finance_management/pages/transactions/new_transaction.dart';
import 'package:personal_finance_management/widgets/amount_page_widget.dart';
import 'package:personal_finance_management/widgets/card_page_widget.dart';
import 'package:personal_finance_management/widgets/card_selector.dart';
import 'package:personal_finance_management/widgets/emptyMessageWidget.dart';
import 'package:personal_finance_management/widgets/reminder/expanded.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String tempData = '';
  String tempType = '';
  String tempAccountId = '';
  List documentData = [];
  List cards = [];
  List cardsCredit = [];
  List listTransaction = [];
  bool isExtended = false;
  Map? _data;
  Map? show_cards;
  double _width = 0;
  bool openAppBar = true;
  var topColor = const Color(0xffE2FAFF);
  bool closeTopContainer = false;
  ScrollController controller = ScrollController();
  bool isChecked = false;
  List sortList = [
    'Amount(low to high)',
    'Amount(high to low)',
    'Oldest',
    'Recent',
  ];
  List creditList = [
    'Credit',
    'Debit',
  ];
  bool isStrechedDropDown = false;
  int? groupValue;
  bool isVisible = true;
  bool isShowOverlay = false;
  bool accountIsShowOverlay = false;
  String title = 'Sort';
  bool status = true;
  bool creditIsStrechedDropDown = false;
  bool accountIsStrechedDropDown = false;
  int? CreditgroupValue;
    bool creditIsVisible = true;
    bool accountIsVisible = true;
  String creditTitle = 'Credit/Debit';
  final layerLink = LayerLink();
  OverlayEntry? entry;
  final creditLayerLink = LayerLink();
    OverlayEntry? creditEntry;
  final accountLayerLink = LayerLink();
  OverlayEntry? accountEntry;
  String accountTitle = 'Accounts';
  var count;
  String? dropDownValue;
  List dropDownValues = ['All transactions'];
  int counter = 0;


  getDropDownValue() async {
    await FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['accountId'] != null) {
          dropDownValues.add(element.data()['accountName']);
        }
      });
      // print('dropDownValues:$dropDownValues');
    });

  }

  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }

  Future<void> getData() async {
    await FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['accountId'] != null) {
          cards.add(element.data());
        } else {
          int unTagged = element.data()['transaction'].length;
          counter += unTagged;
        }
      });
      setState(() {
        _data = cards[0];
        tempData = cards[0]['accountName'];
        tempAccountId = cards[0]['accountId'];
        tempType = cards[0]['accountType'];
      });
    });
  }

  Future<void> getAll() async {
    if (creditTitle == 'Credit/Debit') {
      setState(() {
        var listTransaction = {};
        listTransaction['transaction'] = [];
        for (int i = 0; i < cards.length; i++) {
          if(cards[i]['transaction'] != null) {
            for (int j = 0; j < cards[i]['transaction'].length; j++) {
              if (accountTitle == 'Accounts' || accountTitle == 'All transactions') {
                listTransaction['transaction'].add(cards[i]['transaction'][j]);
              } else {
                if (accountTitle == cards[i]['accountId']) {
                  listTransaction['transaction'].add(cards[i]['transaction'][j]);
                }
              }
            }
          }
        }
        setState(() {
          _data = listTransaction;
        });
      });
    }
  }

  Future<void> getCredit() async {
    if (creditTitle == 'Credit') {
      var listTransaction = {};
      listTransaction['transaction'] = [];
      for (int i = 0; i < cards.length; i++) {
        if(cards[i]['transaction'] != null) {
          for (int j = 0; j < cards[i]['transaction'].length; j++) {
            if (accountTitle == 'Accounts' || accountTitle == 'All transactions') {
              if (cards[i]['transaction'][j]['transactionType'] == creditTitle && tempAccountId == cards[i]['accountId']) {
                listTransaction['transaction'].add(cards[i]['transaction'][j]);
              }
            } else {
              if (cards[i]['transaction'][j]['transactionType'] == creditTitle && accountTitle == cards[i]['accountId']) {
                listTransaction['transaction'].add(cards[i]['transaction'][j]);
              }
            }
          }
        }
      }
      setState(() {
        _data = listTransaction;
      });
    }
  }

  Future<void> getDebit() async {
    if (creditTitle == 'Debit') {
      var listTransaction = {};
      listTransaction['transaction'] = [];
      for (int i = 0; i < cards.length; i++) {
        if(cards[i]['transaction'] != null) {
          for (int j = 0; j < cards[i]['transaction'].length; j++) {
            if (accountTitle == 'Accounts' || accountTitle == 'All transactions') {
              if (cards[i]['transaction'][j]['transactionType'] == creditTitle && tempAccountId == cards[i]['accountId']) {
                listTransaction['transaction'].add(cards[i]['transaction'][j]);
              }
            } else {
              if (cards[i]['transaction'][j]['transactionType'] == creditTitle && accountTitle == cards[i]['accountId']) {
                listTransaction['transaction'].add(cards[i]['transaction'][j]);
              }
            }
          }
        }
      }
      setState(() {
        _data = listTransaction;
      });
    }
  }


  Future<void> AmountLowToHigh() async {
    if (title == 'Amount(low to high)') {
      var listTransaction = {};
      for (int i = 0; i < cards.length; i++) {
        if(cards[i]['transaction'] != null) {
          for (int j = 0; j < cards[i]['transaction'].length; j++) {
            if (tempAccountId == cards[i]['accountId'] || accountTitle == cards[i]['accountId']) {
              listTransaction['transaction'] = cards[i]['transaction'];
            }
          }
        }
      }
      for (int i = 0; i < listTransaction['transaction'].length - 1; i++) {
        for (int j = 0; j < listTransaction['transaction'].length - i - 1; j++) {
          if (double.parse(removeSpecial(listTransaction['transaction'][j]['transactionAmount'])) >
              double.parse(removeSpecial(listTransaction['transaction'][j + 1]['transactionAmount']))) {
            var temp = listTransaction['transaction'][j];
            listTransaction['transaction'][j] = listTransaction['transaction'][j + 1];
            listTransaction['transaction'][j + 1] = temp;
          }
          setState(() {
            _data = listTransaction;
          });
        }
      }
    }
  }

  removeSpecial(var a) {
    var result = a.replaceAll(",", "");
    return result;
  }

  Future<void> AmountHighToLow() async {
    if (title == 'Amount(high to low)') {
      var listTransaction = {};
      for (int i = 0; i < cards.length; i++) {
        if(cards[i]['transaction'] != null) {
          for (int j = 0; j < cards[i]['transaction'].length; j++) {
            if (tempAccountId == cards[i]['accountId'] || accountTitle == cards[i]['accountId']) {
              listTransaction['transaction'] = cards[i]['transaction'];
            }
          }
        }
      }
      for (int i = 0; i < listTransaction['transaction'].length - 1; i++) {
        for (int j = 0; j < listTransaction['transaction'].length - i - 1; j++) {
          if (double.parse(removeSpecial(listTransaction['transaction'][j]['transactionAmount'])) <
              double.parse(removeSpecial(listTransaction['transaction'][j + 1]['transactionAmount']))) {
            var temp = listTransaction['transaction'][j];
            listTransaction['transaction'][j] = listTransaction['transaction'][j + 1];
            listTransaction['transaction'][j + 1] = temp;
          }
          setState(() {
            _data = listTransaction;
          });
        }
      }
    }
  }

  Future<void> Oldest() async {
    if (title == 'Oldest') {
      var listTransaction = {};
      for (int i = 0; i < cards.length; i++) {
        if(cards[i]['transaction'] != null) {
          for (int j = 0; j < cards[i]['transaction'].length; j++) {
            if (tempAccountId == cards[i]['accountId'] || accountTitle == cards[i]['accountId']) {
              listTransaction['transaction'] = cards[i]['transaction'];
            }
          }
        }
      }
      for (int i = 0; i < listTransaction['transaction'].length - 1; i++) {
        for (int j = 0; j < listTransaction['transaction'].length - i - 1; j++) {
          if (listTransaction['transaction'][j]['lastUpdatedDate'].compareTo(listTransaction['transaction'][j + 1]['lastUpdatedDate']) < 0) {
            var temp = listTransaction['transaction'][j];
            listTransaction['transaction'][j] = listTransaction['transaction'][j + 1];
            listTransaction['transaction'][j + 1] = temp;
          }
          setState(() {
            _data = listTransaction;
          });
        }
      }
    }
  }

  Future<void> Recent() async {
    if (title == 'Recent') {
      var listTransaction = {};
      for (int i = 0; i < cards.length; i++) {
        if(cards[i]['transaction'] != null) {
          for (int j = 0; j < cards[i]['transaction'].length; j++) {
            if (tempAccountId == cards[i]['accountId'] || accountTitle == cards[i]['accountId']) {
              listTransaction['transaction'] = cards[i]['transaction'];
            }
          }
        }
      }

      for (int i = 0; i < listTransaction['transaction'].length - 1; i++) {
        for (int j = 0; j < listTransaction['transaction'].length - i - 1; j++) {
          if (listTransaction['transaction'][j]['lastUpdatedDate'].compareTo(listTransaction['transaction'][j + 1]['lastUpdatedDate']) > 0) {
            var temp = listTransaction['transaction'][j];
            listTransaction['transaction'][j] = listTransaction['transaction'][j + 1];
            listTransaction['transaction'][j + 1] = temp;
          }
          setState(() {
            _data = listTransaction;
          });
        }
      }
    }
  }

  Future<void> account() async {
    await FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').get().then((value) {
      var index = -1;
      value.docs.forEach((element) {
        index += 1;
        var listTransaction = {};
        listTransaction['transaction'] = [];
        if (accountTitle == element.data()['accountId']) {
          if(element.data()['transaction'] != null) {
            listTransaction['transaction']+=element.data()['transaction'];
            setState(() {
              _data = listTransaction;
              show_cards = cards[index];
            });
          }
          else{
            setState(() {
              _data!['transaction'] = null;
            });
          }
        }
        return;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDropDownValue();
    isVisible = false;
    creditIsVisible = false;
    accountIsVisible = false;
    getData();
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 0;
        openAppBar = controller.offset < 50;
      });
    });
  }

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final Size sized = MediaQuery.of(context).size;
    double appBarHeight = sized.height * 0.14;
    double cardContainerHeight = sized.height * 0.3;
    if (_width <= 0) _width = MediaQuery.of(context).size.width - 40.0;

    return (_data != null)?Scaffold(
      floatingActionButton: status
          ? FloatingActionButton.extended(
        shape: isExtended ? const CircleBorder() : null,
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: child,
            ),
          ),
          child: isExtended
              ? SvgPicture.asset(
            'assets/svg/floatIcon.svg',
          )
              : Row(
            children: [
              SvgPicture.asset(
                'assets/svg/floatIcon.svg',
              ),
              const Text(
                ' New',
                style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 20, color: Color(0xffB0B0B0)),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        onPressed: () {
          setState(() {
            Get.to(() => NewTransaction());
          });
        },
      ) : null,
      body:  SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AnimatedOpacity(
                  opacity: openAppBar ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: sized.width,
                    alignment: Alignment.topCenter,
                    height: openAppBar ? 0 : sized.height / 7,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: closeTopContainer ? 0 : 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: sized.width,
                    alignment: Alignment.center,
                    height: closeTopContainer ? 0 : cardContainerHeight,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 15),
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('UserData').doc(user?.uid).snapshots(),
                                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  final document = snapshot.data;
                                  if(snapshot.data ==null){
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: (){
                                      Get.to(() => const ProfilePage());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          (document!['profileImage'] == null)
                                              ? SvgPicture.asset('assets/svg/avatar.svg')
                                              : Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [BoxShadow(blurRadius: 3, color: Color(0xffE9E9E9), spreadRadius: 2)],
                                            ),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Image.asset(document['profileImage']),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              Get.to(() => const NotificationPage());
                                            },
                                            child: SvgPicture.asset(
                                              'assets/svg/notify.svg',
                                              width: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          CardSelector(
                              cards: cards.map((e) {
                                return CardPage(e, counter);
                              }).toList(),
                              mainCardWidth: _width,
                              mainCardHeight: _width * 0.5,
                              mainCardPadding: 20.0,
                              onChanged: (i) {
                                setState(() {
                                  _data = cards[i];
                                  tempAccountId = cards[i]['accountId'];
                                  tempData = cards[i]['accountName'];
                                  tempType = cards[i]['accountType'];
                                  creditTitle = "Credit/Debit";
                                  creditIsVisible = false;
                                  title = 'Sort'; //for clear creditFilters to next card
                                  isVisible = false; //for clear sortFilters to next card
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CompositedTransformTarget(
                        link: accountLayerLink,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Stack(children: [
                            SizedBox(
                              width: accountIsShowOverlay ? 200 : 140,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: !accountIsVisible
                                                  ? const Border(
                                                top: BorderSide(color: Color(0xffE3E3E3)),
                                                left: BorderSide(color: Color(0xffE3E3E3)),
                                                right: BorderSide(color: Color(0xffE3E3E3)),
                                                bottom: BorderSide(color: Color(0xffE3E3E3)),
                                              )
                                                  : const Border(
                                                top: BorderSide(color: Color(0xffFFBE78)),
                                                left: BorderSide(color: Color(0xffFFBE78)),
                                                right: BorderSide(color: Color(0xffFFBE78)),
                                                bottom: BorderSide(color: Color(0xffFFBE78)),
                                              ),
                                              borderRadius: accountIsStrechedDropDown
                                                  ? const BorderRadius.only(
                                                topLeft: Radius.circular(22.5),
                                                topRight: Radius.circular(22.5),
                                              )
                                                  : const BorderRadius.all(Radius.circular(22.5)),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.only(right: 5),
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(27)),
                                                  ),
                                                  constraints: const BoxConstraints(
                                                    minHeight: 40,
                                                    minWidth: double.infinity,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        accountIsStrechedDropDown = !accountIsStrechedDropDown;
                                                        WidgetsBinding.instance.addPostFrameCallback((_) => showAccountOverlay());
                                                        accountIsShowOverlay = true;
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Wrap(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 10),
                                                                  child: Text(
                                                                    accountTitle,
                                                                    style: const TextStyle(
                                                                        fontSize: 16, fontFamily: ' Gilroy Medium', color: Color(0xff5E5E5E)),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                        Icon(
                                                          accountIsStrechedDropDown ? Icons.expand_less : Icons.expand_more,
                                                          color: !accountIsVisible ? const Color(0xffE3E3E3) : const Color(0xffFFBE78),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Visibility(
                                visible: accountIsVisible,
                                child: Container(
                                  margin: accountIsShowOverlay ? const EdgeInsets.only(top: 0, left: 184) : const EdgeInsets.only(left: 70),
                                  decoration: const BoxDecoration(color: Color(0xffFF6349), shape: BoxShape.circle),
                                  child: accountTitle != 'All transactions'
                                      ? InkWell(
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        accountIsVisible = !accountIsVisible;
                                        accountTitle = "Accounts";
                                        getAll();
                                        accountIsShowOverlay = false;
                                        accountHideOverlay();
                                      });
                                    },
                                  )
                                      : null,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      CompositedTransformTarget(
                        link: layerLink,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Stack(children: [
                            Container(
                              width: isShowOverlay ? 200 : 90,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: !isVisible
                                                  ? const Border(
                                                top: BorderSide(color: Color(0xffE3E3E3)),
                                                left: BorderSide(color: Color(0xffE3E3E3)),
                                                right: BorderSide(color: Color(0xffE3E3E3)),
                                                bottom: BorderSide(color: Color(0xffE3E3E3)),
                                              )
                                                  : const Border(
                                                top: BorderSide(color: Color(0xffFFBE78)),
                                                left: BorderSide(color: Color(0xffFFBE78)),
                                                right: BorderSide(color: Color(0xffFFBE78)),
                                                bottom: BorderSide(color: Color(0xffFFBE78)),
                                              ),
                                              borderRadius: isStrechedDropDown
                                                  ? const BorderRadius.only(
                                                topLeft: Radius.circular(22.5),
                                                topRight: Radius.circular(22.5),
                                              )
                                                  : const BorderRadius.all(Radius.circular(22.5)),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.only(right: 5),
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(27)),
                                                  ),
                                                  constraints: const BoxConstraints(
                                                    minHeight: 40,
                                                    minWidth: double.infinity,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isStrechedDropDown = !isStrechedDropDown;
                                                        WidgetsBinding.instance.addPostFrameCallback((_) => showSortOverlay());
                                                        isShowOverlay = true;
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Wrap(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 10),
                                                                  child: Text(
                                                                    title,
                                                                    style: const TextStyle(
                                                                        fontSize: 16, fontFamily: ' Gilroy Medium', color: Color(0xff5E5E5E)),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                        Icon(
                                                          isStrechedDropDown ? Icons.expand_less : Icons.expand_more,
                                                          color: !isVisible ? const Color(0xffE3E3E3) : const Color(0xffFFBE78),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Visibility(
                                visible: isVisible,
                                child: Container(
                                  margin: isShowOverlay ? const EdgeInsets.only(top: 0, left: 184) : const EdgeInsets.only(left: 70),
                                  decoration: const BoxDecoration(color: Color(0xffFF6349), shape: BoxShape.circle),
                                  child: InkWell(
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                        title = "Sort";
                                        isShowOverlay = false;
                                        hideOverlay();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      CompositedTransformTarget(
                        link: creditLayerLink,
                        child: Stack(children: [
                          Container(
                            width: 150,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: !creditIsVisible
                                                ? const Border(
                                              top: BorderSide(color: Color(0xffE3E3E3)),
                                              left: BorderSide(color: Color(0xffE3E3E3)),
                                              right: BorderSide(color: Color(0xffE3E3E3)),
                                              bottom: BorderSide(color: Color(0xffE3E3E3)),
                                            )
                                                : const Border(
                                              top: BorderSide(color: Color(0xffFFBE78)),
                                              left: BorderSide(color: Color(0xffFFBE78)),
                                              right: BorderSide(color: Color(0xffFFBE78)),
                                              bottom: BorderSide(color: Color(0xffFFBE78)),
                                            ),
                                            borderRadius: creditIsStrechedDropDown
                                                ? const BorderRadius.only(
                                              topLeft: Radius.circular(22.5),
                                              topRight: Radius.circular(22.5),
                                            )
                                                : const BorderRadius.all(Radius.circular(22.5)),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(right: 5),
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                ),
                                                constraints: const BoxConstraints(
                                                  minHeight: 40,
                                                  minWidth: double.infinity,
                                                ),
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      creditIsStrechedDropDown = !creditIsStrechedDropDown;
                                                      WidgetsBinding.instance.addPostFrameCallback((_) => showCreditOverlay());
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Wrap(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                child: Text(
                                                                  creditTitle,
                                                                  style: const TextStyle(
                                                                      fontSize: 16, fontFamily: ' Gilroy Medium', color: Color(0xff5E5E5E)),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Icon(
                                                        creditIsStrechedDropDown ? Icons.expand_less : Icons.expand_more,
                                                        color: !creditIsVisible ? const Color(0xffE3E3E3) : const Color(0xffFFBE78),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Visibility(
                              visible: creditIsVisible,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 135,
                                ),
                                decoration: const BoxDecoration(color: Color(0xffFF6349), shape: BoxShape.circle),
                                child: InkWell(
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      creditIsVisible = !creditIsVisible;
                                      creditTitle = "Credit/Debit";
                                      creditHideOverlay();
                                      getAll();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                _data!['transaction']== null ? EmptyMessageWidget(isAllTransaction: false, text: 'Transaction',) : Expanded(child: AmountPage(_data!, controller)),
              ],
            ),
          ],
        ),
      ),
    ):const Center(child: CircularProgressIndicator());
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  void creditHideOverlay() {
    creditEntry?.remove();
    creditEntry = null;
  }

  void accountHideOverlay() {
    accountEntry?.remove();
    accountEntry = null;
  }

  void showSortOverlay() {
    entry = OverlayEntry(
      builder: (context) => Positioned(
          width: 210,
          child: CompositedTransformFollower(link: layerLink, showWhenUnlinked: false, offset: const Offset(0, 57), child: sortDropdown())),
    );
    final overlay = Overlay.of(context);
    overlay?.insert(entry!);
  }

  void showCreditOverlay() {
    creditEntry = OverlayEntry(
      builder: (context) => Positioned(
          width: 190,
          child: CompositedTransformFollower(link: creditLayerLink, showWhenUnlinked: false, offset: const Offset(0, 42),
              child: creditDropdown())),
    );
    final overlay = Overlay.of(context);
    overlay?.insert(creditEntry!);
  }

  void showAccountOverlay() {
    accountEntry = OverlayEntry(
      builder: (context) => Positioned(
          width: 210,
          child: CompositedTransformFollower(link: accountLayerLink, showWhenUnlinked: false, offset: const Offset(0, 57), child: accountDropdown())),
    );
    final overlay = Overlay.of(context);
    overlay?.insert(accountEntry!);
  }

  Widget sortDropdown() => Material(
    child: Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(22.5), bottomRight: Radius.circular(22.5)),
        border: isStrechedDropDown ? Border.all(color: const Color(0xffE3E3E3)) : Border.all(color: Colors.transparent),
      ),
      child: ExpandedSection(
        expand: isStrechedDropDown,
        height: 100,
        child: ListView.builder(
            padding: const EdgeInsets.only(left: 10),
            shrinkWrap: true,
            itemCount: sortList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      title = sortList.elementAt(index);
                      hideOverlay();
                      AmountLowToHigh();
                      AmountHighToLow();
                      Oldest();
                      Recent();
                      isVisible = true;
                      isStrechedDropDown = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sortList.elementAt(index),
                        style: const TextStyle(
                          fontFamily: 'Gilroy-Medium',
                          fontSize: 15,
                          color: Color(0xff5E5E5E),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SvgPicture.asset('assets/svg/radioButton.svg'),
                    ],
                  ),
                ),
              );
            }),
      ),
    ),
  );

  Widget creditDropdown() => Material(
    child: Container(
      margin: const EdgeInsets.only(right: 40),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(27), bottomRight: Radius.circular(27)),
        border: creditIsStrechedDropDown ? Border.all(color: const Color(0xffE3E3E3)) : Border.all(color: Colors.transparent),
      ),
      child: ExpandedSection(
        expand: creditIsStrechedDropDown,
        height: 100,
        child: ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: creditList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      creditTitle = creditList.elementAt(index);
                      getCredit();
                      getDebit();
                      creditHideOverlay();
                      creditIsVisible = true;
                      creditIsStrechedDropDown = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        creditList.elementAt(index),
                        style: const TextStyle(
                          fontFamily: 'Gilroy-Medium',
                          fontSize: 15,
                          color: Color(0xff5E5E5E),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SvgPicture.asset('assets/svg/radioButton.svg'),
                    ],
                  ),
                ),
              );
            }),
      ),
    ),
  );

  Widget accountDropdown() => Material(
    child: Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(22.5), bottomRight: Radius.circular(22.5)),
        border: accountIsStrechedDropDown ? Border.all(color: const Color(0xffE3E3E3)) : Border.all(color: Colors.transparent),
      ),
      child: ExpandedSection(
        expand: accountIsStrechedDropDown,
        height: 100,
        child: ListView.builder(
            padding: const EdgeInsets.only(left: 10),
            shrinkWrap: true,
            itemCount: dropDownValues.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      accountTitle = dropDownValues.elementAt(index);
                      if (accountTitle == 'All transactions') {
                        accountHideOverlay();
                        accountIsStrechedDropDown = false;
                        Get.to(() =>  NewAllTransaction(counter,accountTitle:'All transactions'));
                      } else {
                        account();
                        accountIsVisible = true;
                        accountHideOverlay();
                        accountIsStrechedDropDown = false;
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dropDownValues.elementAt(index),
                        style: const TextStyle(
                          fontFamily: 'Gilroy-Medium',
                          fontSize: 15,
                          color: Color(0xff5E5E5E),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SvgPicture.asset('assets/svg/radioButton.svg'),
                    ],
                  ),
                ),
              );
            }),
      ),
    ),
  );
}