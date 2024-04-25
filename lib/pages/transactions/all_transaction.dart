import 'dart:core';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/pages/transactions/new_transaction.dart';
import 'package:personal_finance_management/widgets/edit_popup/transaction_popup_2nd_page.dart';
import 'package:personal_finance_management/widgets/emptyMessageWidget.dart';
import 'package:personal_finance_management/widgets/reminder/expanded.dart';

class NewAllTransaction extends StatefulWidget {
  int counter;
  String accountTitle;
  NewAllTransaction(this.counter, {Key? key, required this.accountTitle}) : super(key: key);

  @override
  _NewAllTransactionState createState() => _NewAllTransactionState();
}

class _NewAllTransactionState extends State<NewAllTransaction> {

  List transactionData = [];
  List cards = [];
  String tempType = '';
  bool status = true;

  bool isExtended = false;
  List creditList = [
    'Credit',
    'Debit',
  ];
  var rupeeCredit = const Color(0xff4AD66D);
  var transAmountDebit = const Color(0xff000000);
  String? dropDownValue;
  String? dropDownValue_1;
  String? dropDownValue_2;
  String tempData = '';
  String tempaccountId = '';
  String title = 'Sort';

  String creditTitle = 'Credit/Debit';
  // dynamic unTaggedCount;
  final layerLink = LayerLink();
  bool isShowOverlay = false;
  bool accountIsShowOverlay = false;
  bool isVisible = true;
  bool creditIsVisible = true;
  bool accountIsVisible = true;
  Map? _data;
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  bool openAppBar = true;
  bool isStretchedDropDown = false;
  OverlayEntry? entry;
  List sortList = [
    'Amount(low to high)',
    'Amount(high to low)',
    'Oldest',
    'Recent',
  ];
  String accountTitle ='Untagged';
  bool creditIsStretchedDropDown = false;
  bool accountIsStretchedDropDown = false;
  final creditLayerLink = LayerLink();
  final accountLayerLink = LayerLink();
  OverlayEntry? accountEntry;
  OverlayEntry? creditEntry;
  int unTaggedCount =0;


  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    return uid;
  }

  Future<void> getAll() async {
    await FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').get().then((value) {
      cards = [];
      for (var element in value.docs) {
        if(element.data()['transaction']!= null){
          cards += element.data()['transaction'];
        }
      }
      setState(() {
        transactionData = cards;

      });
      //  }
    });
  }

  Future<void> getCredit() async {
    if (creditTitle == 'Credit') {
      List credit = [];
      for (int i = 0; i < transactionData.length; i++) {
        if (transactionData[i]['transactionType'] == creditTitle) {
          credit.add(transactionData[i]);
        }
      }
      setState(() {
        transactionData = credit;
      });
    }
  }

  Future<void> getDebit() async {
    if (creditTitle == 'Debit') {
      List debit = [];
      for (int i = 0; i < transactionData.length; i++) {
        if (transactionData[i]['transactionType'] == creditTitle) {
          debit.add(transactionData[i]);
        }
      }
      setState(() {
        transactionData = debit;
      });
    }
  }

  Future<void> AmountLowToHigh() async {
    if (title == 'Amount(low to high)') {
      for (int i = 0; i < transactionData.length - 1; i++) {
        for (int j = 0; j < transactionData.length - i - 1; j++) {
          if (double.parse(removeSpecial(transactionData[j]['transactionAmount'])) >
              double.parse(removeSpecial(transactionData[j + 1]['transactionAmount']))) {
            var temp = transactionData[j];
            transactionData[j] = transactionData[j + 1];
            transactionData[j + 1] = temp;
          }
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

      for (int i = 0; i < transactionData.length - 1; i++) {
        for (int j = 0; j < transactionData.length - i - 1; j++) {
          if (double.parse(removeSpecial(transactionData[j]['transactionAmount'])) <
              double.parse(removeSpecial(transactionData[j + 1]['transactionAmount']))) {
            var temp = transactionData[j];
            transactionData[j] = transactionData[j + 1];
            transactionData[j + 1] = temp;
          }
        }
      }
    }
  }

  Future<void> Recent() async {
    if (title == 'Recent') {
      for (int i = 0; i < transactionData.length - 1; i++) {
        for (int j = 0; j < transactionData.length - i - 1; j++) {
          if (transactionData[j]['lastUpdatedDate'].compareTo(transactionData[j + 1]['lastUpdatedDate']) < 0) {
            var temp = transactionData[j];
            transactionData[j] = transactionData[j + 1];
            transactionData[j + 1] = temp;
          }
        }
      }
    }
  }

  Future<void> Oldest() async {
    if (title == 'Oldest') {
      for (int i = 0; i < transactionData.length - 1; i++) {
        for (int j = 0; j < transactionData.length - i - 1; j++) {
          if (transactionData[j]['lastUpdatedDate'].compareTo(transactionData[j + 1]['lastUpdatedDate']) > 0) {
            var temp = transactionData[j];
            transactionData[j] = transactionData[j + 1];
            transactionData[j + 1] = temp;
          }
        }
      }
    }
  }

  Future<void> account() async {
    List account = [];
    List untagged = [];
    await FirebaseFirestore.instance.collection('UserData').doc(getUid()).collection('TransactionData').get().then((value) {
      for (var element in value.docs) {
        if (widget.accountTitle == 'Untagged' && element.data()['accountId'] == null) {
          untagged += element.data()['transaction'];
          if(element.data()['transaction'] == null ){
            untagged =[];
          }
          setState(() {
            transactionData = untagged;
          });
        }
        if (widget.accountTitle == element.data()['accountName']) {
          if(element.data()['transaction'] != null ){
            account += element.data()['transaction'];
          }

          setState(() {
            transactionData = account;
          });
        }
      }
    });
  }

  List dropDownValues = ['All transactions'];

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

  @override
  void initState() {
    super.initState();
    getDropDownValue();
    isVisible = false;
    creditIsVisible = false;
    accountIsVisible = false;

    if(widget.accountTitle =='All transactions'){
      getAll();
    }
    if(widget.accountTitle =='Untagged'&& widget.counter!= 0) {
      accountTitle = 'Untagged';
      account();
    }
    else{
      accountTitle = 'Untagged';
    }
    controller.addListener(() {
      setState(() {
        closeTopContainer = controller.offset > 0;
        openAppBar = controller.offset < 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          });
          showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: '',
            barrierColor: Colors.black38,
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (ctx, anim1, anim2) =>  NewTransaction(),
            transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
              child: FadeTransition(
                opacity: anim1,
                child: child,
              ),
            ),
            context: context,
          );
        },
      )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/Arrow .png'),
                    ),
                    const Text(
                      'All Transactions',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Gilroy Medium',
                        fontSize: 22,
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xffFF6349), borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          '${widget.counter} Untagged!',
                          style: const TextStyle(
                            color: Color(0xffFFE3DE),
                            fontFamily: 'Gilroy Medium',
                            fontSize: 9,
                          ),
                        )),

                  ],
                ),
              ),
//Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CompositedTransformTarget(
                      link: accountLayerLink,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Stack(children: [
                          Container(
                            width: 200 ,
                            //padding: const EdgeInsets.only(left: 15, top: 12, right: 15),
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
                                            borderRadius: accountIsStretchedDropDown
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
                                                // border: Border.all(width: 1.5, color: Color(0xffFFF0D3))
                                                constraints: const BoxConstraints(
                                                  minHeight: 40,
                                                  minWidth: double.infinity,
                                                ),
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      accountIsStretchedDropDown = !accountIsStretchedDropDown;
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
                                                                  widget.accountTitle,
                                                                  style:
                                                                  const TextStyle(fontSize: 16, fontFamily: ' Gilroy Medium', color: Color(0xff5E5E5E)),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Icon(
                                                        accountIsStretchedDropDown ? Icons.expand_less : Icons.expand_more,
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
                          Visibility(
                            visible: accountIsVisible,
                            child: Container(
                              margin: accountIsShowOverlay
                                  ? const EdgeInsets.only(
                                top: 0,
                                left: 184,
                              )
                                  : const EdgeInsets.only(left: 70),
                              decoration: const BoxDecoration(color: Color(0xffFF6349), shape: BoxShape.circle),
                              child: InkWell(
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onTap: () {
                                  setState(() {
                                    accountIsVisible = !accountIsVisible;
                                    widget. accountTitle = "All transactions";
                                    if (widget.accountTitle == 'All transactions') {
                                      getAll();
                                    }
                                    getAll();
                                    accountIsShowOverlay = false;
                                    accountHideOverlay();
                                  });
                                },
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
                                            borderRadius: isStretchedDropDown
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
                                                // border: Border.all(width: 1.5, color: Color(0xffFFF0D3))
                                                constraints: const BoxConstraints(
                                                  minHeight: 40,
                                                  minWidth: double.infinity,
                                                ),
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isStretchedDropDown = !isStretchedDropDown;
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
                                                                  style:
                                                                  const TextStyle(fontSize: 16, fontFamily: ' Gilroy Medium', color: Color(0xff5E5E5E)),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Icon(
                                                        isStretchedDropDown ? Icons.expand_less : Icons.expand_more,
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
                                // transform: Matrix4.translationValues(0, -15, 0),
                                // width: 30,
                                // height: 30,
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
                                      //sortAll();
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
                          //padding: const EdgeInsets.only(left: 15, top: 12, right: 15),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Container(
                                        //  margin: EdgeInsets.only(left: 0),
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
                                          borderRadius: creditIsStretchedDropDown
                                              ? const BorderRadius.only(
                                            topLeft: Radius.circular(22.5),
                                            topRight: Radius.circular(22.5),
                                          )
                                              : const BorderRadius.all(Radius.circular(22.5)),
                                          // border: !isVisible
                                          //     ? Border.all(color: const Color(0xffE3E3E3))
                                          //     : Border.all(color: const Color(0xffFFBE78)),
                                          // // borderRadius: const BorderRadius.all(Radius.circular(27)),
                                          // borderRadius: isStrechedDropDown
                                          //     ? BorderRadius.only(
                                          //         topLeft: Radius.circular(27),
                                          //         topRight: Radius.circular(27))
                                          //     : BorderRadius.all(Radius.circular(27)),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(right: 5),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                              ),
                                              // border: Border.all(width: 1.5, color: Color(0xffFFF0D3))
                                              constraints: const BoxConstraints(
                                                minHeight: 40,
                                                minWidth: double.infinity,
                                              ),
                                              alignment: Alignment.center,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    creditIsStretchedDropDown = !creditIsStretchedDropDown;
                                                    WidgetsBinding.instance.addPostFrameCallback((_) => showCreditOverlay());
                                                    //isVisible=false;
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
                                                                style: const TextStyle(fontSize: 16, fontFamily: ' Gilroy Medium', color: Color(0xff5E5E5E)),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    Icon(
                                                      creditIsStretchedDropDown ? Icons.expand_less : Icons.expand_more,
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
                              // transform: Matrix4.translationValues(0, -15, 0),
                              // width: 30,
                              // height: 30,
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
                                    if (accountIsVisible == true) {
                                      account();
                                    }
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

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.75,
                child:AllTransactionListView(
                  transactionData: transactionData,
                  dropDownValue_1: dropDownValue_1,
                  rupeeCredit: rupeeCredit,
                  transAmountDebit: transAmountDebit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSortOverlay() {
    // RenderBox renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        // left: offset.dx,
        //   top:offset.dy+size.height+8,
          width: 210,
          child: CompositedTransformFollower(link: layerLink, showWhenUnlinked: false, offset: const Offset(0, 57), child: sortDropdown())),
    );
    final overlay = Overlay.of(context);
    overlay?.insert(entry!);
  }

  void showCreditOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    creditEntry = OverlayEntry(
      builder: (context) => Positioned(
        // left: offset.dx,
        //   top:offset.dy+size.height+8,

          width: 190,
          child: CompositedTransformFollower(link: creditLayerLink, showWhenUnlinked: false, offset: const Offset(0, 42), child: creditDropdown())),
    );
    final overlay = Overlay.of(context);
    overlay?.insert(creditEntry!);
  }

  void showAccountOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    accountEntry = OverlayEntry(
      builder: (context) => Positioned(
        // left: offset.dx,
        //   top:offset.dy+size.height+8,

          width: 210,
          child: CompositedTransformFollower(link: accountLayerLink, showWhenUnlinked: false, offset: const Offset(0, 58), child: accountDropdown())),
    );
    final overlay = Overlay.of(context);
    overlay?.insert(accountEntry!);
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

  Widget creditDropdown() => Material(
    child: Container(
      margin: const EdgeInsets.only(right: 40),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(27), bottomRight: Radius.circular(27)),
        //borderRadius: BorderRadius.all(Radius.circular(27)),
        border: creditIsStretchedDropDown ? Border.all(color: const Color(0xffE3E3E3)) : Border.all(color: Colors.transparent),
      ),
      child: ExpandedSection(
        expand: creditIsStretchedDropDown,
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
                      creditIsStretchedDropDown = false;
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

  Widget sortDropdown() => Material(
    // elevation: 3,

    child: Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(22.5), bottomRight: Radius.circular(22.5)),
        border: isStretchedDropDown ? Border.all(color: const Color(0xffE3E3E3)) : Border.all(color: Colors.transparent),
      ),
      child: ExpandedSection(
        expand: isStretchedDropDown,
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
                      // sorting(title);
                      AmountLowToHigh();
                      AmountHighToLow();
                      Oldest();
                      Recent();
                      isVisible = true;
                      isStretchedDropDown = false;
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

  Widget accountDropdown() => Material(
    // elevation: 3,

    child: Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(22.5), bottomRight: Radius.circular(22.5)),
        border: accountIsStretchedDropDown ? Border.all(color: const Color(0xffE3E3E3)) : Border.all(color: Colors.transparent),
      ),
      child: ExpandedSection(
        expand: accountIsStretchedDropDown,
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
                      widget.accountTitle = dropDownValues.elementAt(index);
                      if (widget.accountTitle == 'All transactions') {
                        getAll();
                        accountHideOverlay();
                        accountIsVisible = true;
                        accountIsStretchedDropDown = false;
                      }
                      else {
                        accountHideOverlay();
                        account();
                        accountIsVisible = true;
                        accountIsStretchedDropDown = false;
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

class AllTransactionListView extends StatelessWidget {

  AllTransactionListView({
    Key? key,
    required this.transactionData,
    required this.dropDownValue_1,
    required this.rupeeCredit,
    required this.transAmountDebit,
  }) : super(key: key);

  final List transactionData;
  final String? dropDownValue_1;
  final Color rupeeCredit;
  final Color transAmountDebit;
  bool isAllTransaction = true;

  @override
  Widget build(BuildContext context) {
    return transactionData.isNotEmpty ? ListView.builder(
        physics: const ScrollPhysics(),
        itemCount: transactionData.length,
        itemBuilder: (context, index) {
          if (dropDownValue_1 == 'Untagged') {
          }
          return GestureDetector(
            onLongPress: (){
              if(transactionData[index]['categoryName'] == ''){
                showGeneralDialog(
                  barrierDismissible: true,
                  barrierLabel: '',
                  barrierColor: Colors.black38,
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (ctx, anim1, anim2) =>  TransactionPopupPage2(transactionData: transactionData[index],index: index,),
                  transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                    child: FadeTransition(
                      child: child,
                      opacity: anim1,
                    ),
                  ),
                  context: context,
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(42),
                  color:transactionData[index]['categoryBgColor'] == ''?untaggedColor: Colors.white,

                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Stack(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: transactionData[index]['categoryBgColor'] != ''
                              ? Color(int.parse(transactionData[index]['categoryBgColor']))
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: transactionData[index]['categoryName'] == '' //snapshot.data!.docs[index]['transaction'][index]['categoryName'] == ''
                                ? const Color(0xffFF6A6A)
                                : Colors.transparent,
                          )),
                      child: Image.asset(
                        transactionData[index]['categoryLogo'], //snapshot.data!.docs[index]['transaction'][index]['categoryLogo'].toString(),
                        width: 70,
                        // fit: BoxFit.scaleDown,
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.17,
                      bottom: MediaQuery.of(context).size.height * 0.005,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  transactionData[index]['categoryName'], //snapshot.data!.docs[index]['transaction'][index]['categoryName'].toString(),
                                  style: const TextStyle(fontFamily: "Gilroy Medium", fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: transactionData[index]['categoryName'] == '' ? const Color(0xffFF6349) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25)),
                                    child: Text(
                                      transactionData[index]['categoryName'] == '' ? 'Untagged' : '',
                                      style: const TextStyle(
                                        color: Color(0xffFFE3DE),
                                        fontFamily: 'Gilroy Medium',
                                        fontSize: 9,
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                              child: Text(
                                transactionData[index]['createdDate'], //snapshot.data!.docs[index]['transaction'][index]['transactionDate'].toString(),
                                style: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16, color: Color(0xffBABABA)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.025,
                      // right: 10,
                      // bottom: 21,
                      bottom: MediaQuery.of(context).size.height * 0.025,
                      child: Text(
                        '\u{20B9} ${transactionData[index]['transactionAmount']}',
                        // '\u{20B9}, ${snapshot.data!.docs[index]['transaction'][index]['transactionAmount'].toString()}',
                        style: TextStyle(
                          color: transactionData[index]['transactionType'] == 'Credit' ? rupeeCredit : transAmountDebit,
                          fontFamily: "Gilroy Bold",
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }): EmptyMessageWidget(isAllTransaction: isAllTransaction, text: 'Transaction',);
  }
}