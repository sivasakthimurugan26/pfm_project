import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/pages/stepper.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_category.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {

  String visited = 'categoryVisited';
  int activeIndex = 3;
  bool isFirst = true;
  String currencyCode = '';
  final FocusNode budgetFocus = FocusNode();
  TextEditingController budgetAmountTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getCurrency();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(child:       GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      const Text(
                        'Budget',
                        style:
                        TextStyle(fontSize: 30, fontFamily: 'Gilroy Medium'),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        children: <Widget>[
                          const Text(
                            'Enter your total month expenses  ',
                            style: TextStyle(
                                fontSize: 17, fontFamily: 'Gilroy Light'),
                          ),
                          SvgPicture.asset('assets/svg/idea.svg'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '\u{20B9} ',
                        style: TextStyle(color: Color(0xff727272), fontSize: 25),
                      ),
                      IntrinsicWidth(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: budgetAmountTextController,
                          focusNode: budgetFocus,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            String newValue =
                            value.replaceAll(',', '').replaceAll('.', '');
                            if (value.isEmpty || newValue == '00') {
                              budgetAmountTextController.clear();
                              isFirst = true;
                              return;
                            }
                            double value1 = double.parse(newValue);
                            if (!isFirst) value1 = value1 * 100;
                            value =
                                NumberFormat.currency(customPattern: '###,###.##')
                                    .format(value1 / 100);
                            budgetAmountTextController.value = TextEditingValue(
                              text: value,
                              selection:
                              TextSelection.collapsed(offset: value.length),
                            );
                          },
                          style: const TextStyle(
                              fontSize: 45, fontFamily: 'Gilroy SemiBold'),
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
                  SizedBox(
                    height: height * 0.20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Get.to(()=> AddCashAccount);
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
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: 'Gilroy Medium'),
                                )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (budgetAmountTextController.text.isEmpty) {
                            snackBarWidget("Help us here",
                                "Please update the budget amount.");
                            budgetFocus.requestFocus();
                          } else {
                            addBudget();
                            // Get.to(() => AddBudgetCategory());
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
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Gilroy Medium',
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
        onWillPop: ()async=>false);
  }

  // getCurrency() async {
  //   final CollectionReference _currencyCollection =
  //       FirebaseFirestore.instance.collection('currency');
  //   final snapshot = await _currencyCollection.doc('INR').get().then((value) {
  //     setState(() {
  //       currencyCode = value['code'];
  //       storageContainer.write('currency',value['code']);
  //     });
  //   });
  //   // return snapshot['code'];
  // }

  addBudget() async {
    SharedPreferences isOnboarding =await SharedPreferences.getInstance();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();

    // getCurrency();
    print('currencyCode: $currencyCode');

    var date = DateTime.now();
    var month = DateFormat("MMMM").format(date);

    // myProgressIndicator(context);
    await firebaseFirestore.collection("UserData").doc(user?.uid).update(
        userModel.budget(month,'INR', budgetAmountTextController.text, budgetAmountTextController.text));
    if(isOnboarding.getBool('isOnboarding') != true){
      Get.to(() =>  StepperPage(visited,activeIndex));
    }
    else{
      Get.to(() => const AddBudgetCategory());
    }

    //
  }
}