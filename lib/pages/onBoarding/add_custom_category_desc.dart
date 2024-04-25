import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_management/constants/svg_constant.dart';
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/stepper.dart';
import 'package:personal_finance_management/service/AppChecker.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_category.dart';

class AddCustomCategoryDesc extends StatefulWidget {
  const AddCustomCategoryDesc({Key? key}) : super(key: key);

  @override
  _AddCustomCategoryDescState createState() => _AddCustomCategoryDescState();
}

class _AddCustomCategoryDescState extends State<AddCustomCategoryDesc> {
  int activeIndex = 4;
  String visited = 'dashboard';
  User? user = FirebaseAuth.instance.currentUser;

  bool isFirst = true;
  final FocusNode budgetFocus = FocusNode();
  TextEditingController budgetAmountTextController = TextEditingController();
  String catIcon = storageContainer.read('catIcon');
  int bgColor = storageContainer.read('catBg');
  bool newCategoryVisibility = false;

  var data = Get.arguments;
  var categoryName = '';
  var cateName = [];
  String availableCur = 'INR';
  String budgetedCur = 'INR';
  var availableAmount = '';
  var budgetAmount = '';
  String value = '';
  var allocatedAmount = '';
  var budgetCurrencyValue = '';
  var budgetMonth = '';

  @override
  void initState() {
    // print('Data: ${data[0]}');
    // print('bgcolor:$bgColor');
    // print('newDataZero: $data[0]');
    // print('newDataone: $data[1]');
    // print('backColor: $bgColor');
    // print('newStorage: $catIcon');
    categoryName = data[0];
    // print('categoryName: ${data[0]}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print('Data: ${data[1]}');

    if (data[1] != null) {
      budgetAmountTextController.text = data[1]['budgetedAmount'].toString();
      availableCur = data[1]['availableCur'];
      budgetedCur = data[1]['budgetedCur'];
    }

    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: height,
              color: Color(bgColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text(
                          'Remaining Budget',
                          style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 25),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('UserData').doc(user?.uid).snapshots(),
                                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (!snapshot.hasData) return const Text("Loading...");
                                  final DocumentSnapshot? document = snapshot.data;
                                  final Map<String, dynamic> documentData = document?.data() as Map<String, dynamic>;
                                  availableAmount = documentData['budget']['availableAmount'];
                                  allocatedAmount = documentData['budget']['allocatedAmount'];
                                  budgetCurrencyValue = documentData['budget']['currency'];
                                  budgetMonth = documentData['budget']['month'];
                                  print('documentData:$documentData');
                                  print('docData : ${documentData['budget']['availableAmount']}');
                                  return Text(
                                    '\u{20B9} $availableAmount',
                                    style: const TextStyle(fontSize: 15, fontFamily: 'Gilroy Medium'),
                                    textAlign: TextAlign.center,
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(catIcon),
                    ),

                    Column(
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
                                  // setState(() {
                                  //   newCategoryVisibility = true;
                                  // });
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
                              categoryName,
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

                    SizedBox(
                      height: height * 0.20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
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
                              addCustomCategory();
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

                    // SizedBox(height: height*0.05,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Do You have more categories ? ',
                          style: TextStyle(
                            fontFamily: 'Gilroy Medium',
                            fontSize: 17,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const AddBudgetCategory());
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 20, color: Color(0xffFF9E36)),
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
        onWillPop: () async => false);
  }

  storeOnboardInfo() async {
    MySharedPreferences.instance.setBooleanValue("isfirstRun", true);
  }

  generateCategoryId() {
    int min = 1;
    int max = 1000;
    int randomNumber = 1;
    randomNumber = Random().nextInt(max - min) + min;
    return randomNumber;
  }

  addCustomCategory() async {
    SharedPreferences isOnboarding = await SharedPreferences.getInstance();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    UserModel userModel = UserModel();

    // myProgressIndicator(context);

    var query = await firebaseFirestore.collection("UserData").doc(user?.uid);

    if (data[1] == null) {
      // update the Budget balance

      var finalAvailableBalance = double.parse(availableAmount.replaceAll(',', ''));
      var finalBudgetAmount = double.parse(budgetAmountTextController.text.replaceAll(',', ''));
      double calculateBalance = 0;

      calculateBalance = finalAvailableBalance - finalBudgetAmount;
      print('Balance: $calculateBalance');
      var convertedBalance = NumberFormat.currency(customPattern: '###,###.##').format(calculateBalance);

// allocatedAmount, budgetCurrencyValue, budgetMonth
      await firebaseFirestore
          .collection("UserData")
          .doc(user?.uid)
          .update(userModel.budget(budgetMonth, budgetCurrencyValue, allocatedAmount, convertedBalance));
      query.update(userModel.categories(generateCategoryId().toString(), data[0], catIcon, bgColor.toString(), 'INR', budgetAmountTextController.text,
          'INR', budgetAmountTextController.text, '0'));
      storeOnboardInfo();

      if (isOnboarding.getBool('isOnboarding') != true) {
        Get.to(() => StepperPage(visited, activeIndex));
      } else {
        Get.to(() => HomePage());
      }
    } else {
      query.get().then((value) {
        var categoryList = value.data()!['categories'];

        var editList = [
          {
            'categoryId': data[1]['categoryId'],
            'categoryName': categoryName,
            'categoryLogo': catIcon,
            'backgroundColor': bgColor.toString(),
            'availableCur': availableCur,
            'availableAmount': data[1]['availableAmount'],
            'budgetedCur': budgetedCur,
            'budgetedAmount': budgetAmountTextController.text,
            'spentAmount': data[1]['spentAmount'],
          }
        ];
        print('EditList: ${editList}');
        for (int i = 0; i < categoryList.length; i++) {
          if (categoryList[i]['categoryId'] == editList[0]['categoryId']) {
            List newList = [];
            newList.add(categoryList[i]);
            print('Data: ${newList}');
            query.update({'categories': FieldValue.arrayRemove(newList)});
            query.update({'categories': FieldValue.arrayUnion(editList)});
          }
        }
      });
      // storeOnboardInfo();
      //Get.to(() =>  StepperPage(visited,activeIndex));
      Get.to(() => HomePage());
    }
  }
}
