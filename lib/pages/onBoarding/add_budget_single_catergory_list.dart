import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

import 'add_category.dart';
import 'add_custom_category.dart';

class SingleCategoryPageView extends StatefulWidget {
  const SingleCategoryPageView({Key? key}) : super(key: key);

  @override
  _SingleCategoryPageViewState createState() => _SingleCategoryPageViewState();
}

class _SingleCategoryPageViewState extends State<SingleCategoryPageView> {
  getUid() {
    User? user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    // print('uid out: $uid');
    return uid;
  }

  String value = '';

  bool isFirst = true;
  final FocusNode budgetFocus = FocusNode();
  TextEditingController budgetAmountTextController = TextEditingController();

  bool newCategoryVisibility = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    value = getUid().toString();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          color: Color(0xffFFE2AB),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            stream: FirebaseFirestore.instance.collection('budget').doc(value).snapshots(),
                            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              // if (snapshot.connectionState == ConnectionState.done) {
                              //   var result = snapshot.data!;
                              //   var availableAmount = result['availableAmount'];
                              //   print('availableAmount: $availableAmount');
                              //   return Text('\u{20B9} ${result['availableAmount']}');
                              // } else {
                              //   return CircularProgressIndicator();
                              // }
                              var result = snapshot.data!;
                              return Text('\u{20B9} ${result['availableAmount']}');
                            }),
                        // Text(
                        //   '\u{20B9} 12,500.00',
                        //   style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Medium'), textAlign: TextAlign.center,
                        // ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/food.png'),
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
                      children: const <Widget>[
                        Text(
                          'Enter You ',
                          style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Light'),
                        ),
                        Text(
                          'Gym ',
                          style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Bold'),
                        ),
                        Text(
                          'expenses',
                          style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Light'),
                        ),
                      ],
                    )
                  ],
                ),

                // SizedBox(
                //   height: height * 0.20,
                // ),
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
                          Get.to(() => AddCustomCategoryPage());
                          // Get.to(() => AddCustomCategoryPage);

                          // print('TEst');
                          // Get.to(() => const AddAccountName(), arguments: ['0xffDDF9FF','Savings',budgetAmountTextController.text]);

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
    );
  }
}
