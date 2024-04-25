import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_management/constants/svg_constant.dart';
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

import 'add_more_options.dart';

class AddCategoryDesc extends StatefulWidget {
  final Function() resetSelectItemsCallback;

  const AddCategoryDesc({required this.resetSelectItemsCallback, Key? key}) : super(key: key);

  @override
  State<AddCategoryDesc> createState() => _AddCategoryDescState();
}

class _AddCategoryDescState extends State<AddCategoryDesc> {
  PageController pageController = PageController();
  final FocusNode budgetFocus = FocusNode();
  TextEditingController budgetAmountTextController = TextEditingController();
  bool newCategoryVisibility = false;
  bool isFirst = true;
  var budgetRemainingAmount = '';
  var budgetAllocatedAmount = '';
  var budgetCurrency = '';
  var budgetMonth = '';
  List updatedCategoryList = [];
  var data = Get.arguments;
  List list = [];

  @override
  Widget build(BuildContext context) {
    list = data;
    print('Elamparithi: ${list}');
    return Scaffold(
      body: Center(
        child: PageView.builder(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return screen(index);
            }),
      ),
    );
  }

  Widget screen(int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
// FocusScope.of(context).unfocus();
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          height: height,
          color: Color(int.parse(list[index]['color'])),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 23),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Remaining Budget',
                        style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 23),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('UserData').doc(storageContainer.read('uid')).snapshots(),
                              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.hasData) return const Text("Loading...");

                                final DocumentSnapshot? document = snapshot.data;
                                final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;
                                budgetRemainingAmount = documentData['budget']['availableAmount'];
                                budgetAllocatedAmount = documentData['budget']['allocatedAmount'];
                                budgetCurrency = documentData['budget']['currency'];
                                budgetMonth = documentData['budget']['month'];

                                // print('docData : ${documentData['budget']}');

                                return Text(
                                  '\u{20B9} $budgetRemainingAmount',
                                  style: const TextStyle(fontSize: 16, fontFamily: 'Gilroy Medium'),
                                  textAlign: TextAlign.center,
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 110,
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(list[index]['image']),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '\u{20B9} ',
                            style: TextStyle(color: Color(0xff727272), fontSize: 25),
                          ),
                          IntrinsicWidth(
                            child: TextField(
                              controller: budgetAmountTextController,
                              focusNode: budgetFocus,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  newCategoryVisibility = true;
                                });

                                String newValue = value.replaceAll(',', '').replaceAll('.', '');

                                if (value.isEmpty || newValue == '00') {
                                  budgetAmountTextController.clear();

                                  isFirst = true;

                                  return;
                                }

                                double value1 = double.parse(newValue);

                                if (!isFirst) value1 = value1 * 100;

                                value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);

                                budgetAmountTextController.value = TextEditingValue(
                                  text: value,
                                  selection: TextSelection.collapsed(offset: value.length),
                                );
                              },
                              style: const TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold'),
                              decoration: const InputDecoration(
                                hintText: "0.00 ",
                                border: InputBorder.none,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          InkWell(
                            child: SvgPicture.asset('assets/svg/edit_button.svg'),
                            onTap: () {
                              budgetFocus.requestFocus();
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Enter your ',
                            style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Light'),
                          ),
                          Text(
                            list[index]['name'],
                            style: const TextStyle(fontSize: 17, fontFamily: 'Gilroy Bold'),
                          ),
                          const Text(
                            ' expense',
                            style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Light'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: height * 0.18,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                        widget.resetSelectItemsCallback();
                      },
                      child: Container(
                        width: width * 0.40,
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
                        if (budgetAmountTextController.text.isEmpty) {
                          snackBarWidget("Help us here", "Please update the budget amount.");
                          budgetFocus.requestFocus();
                        } else {
                          goToNextPage(index);
                          addCategories();
                          print('updatedCategoryList:${updatedCategoryList}');
                        }
                      },
                      child: Container(
                        width: width * 0.40,
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

// Text('0.00', style: TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 45),),

                SizedBox(
                  height: height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var temp = 0;

  goToNextPage(index) {
    list[index]['budget'] = budgetAmountTextController.text;
    budgetAmountTextController.clear();
    print('list length:${list.length}');
    if (list.length == index) {
      print('came here:${list}');
      updatedCategoryList.add(list[index]);
      print('inside if:$updatedCategoryList');
      addCategories();
    } else {
      print('list:${list}');
      pageController.jumpToPage(index + 1);
      updatedCategoryList.add(list[index]);
      temp += 1;
      print('inside else:$updatedCategoryList');
      print('temp :$temp');
    }
  }

  generateCategoryId() {
    int min = 1;
    int max = 1000;
    int randomNumber = 1;
    randomNumber = Random().nextInt(max - min) + min;
    return randomNumber;
  }

  addCategories() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();
    double balance = 0.0;
    for (int i = 0; i < updatedCategoryList.length; i++) {
      await firebaseFirestore.collection("UserData").doc(user?.uid).update(userModel.categories(
          generateCategoryId().toString(),
          updatedCategoryList[i]['name'],
          updatedCategoryList[i]['image'],
          updatedCategoryList[i]['color'],
          'INR',
          updatedCategoryList[i]['budget'],
          'INR',
          updatedCategoryList[i]['budget'],
          '0'));

      var convertedRemainingAmount = double.parse(budgetRemainingAmount.replaceAll(',', ''));
      var convertedBudget = double.parse(updatedCategoryList[i]['budget'].replaceAll(',', ''));
      balance = convertedRemainingAmount - convertedBudget;
      var convertedBalance = NumberFormat.currency(customPattern: '###,###.##').format(balance);
      print('convertedRemainingAmount: $convertedRemainingAmount');
      print('con: $convertedBalance');
      print(' updatedCategoryList: ${updatedCategoryList[i]['budget']}');
      updatedCategoryList.remove(updatedCategoryList[i]);
      print('updatedCategoryList after:$updatedCategoryList');
      print('length after:${updatedCategoryList.length}');
      await firebaseFirestore
          .collection("UserData")
          .doc(user?.uid)
          .update(userModel.budget(budgetMonth, budgetCurrency, budgetAllocatedAmount, convertedBalance));
    }
    if (list.length == temp) {
      print('end');
      Get.to(() => const AddMoreOptionsPage(
        name: 'Categories',
      ));
    }
    print('list length:${list.length}');
    print('updatedCategoryList length:${updatedCategoryList.length}');
  }
}
