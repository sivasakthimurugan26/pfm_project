import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:personal_finance_management/constants/my_utility.dart';

class TeamsPopUp extends StatefulWidget {
  const TeamsPopUp({Key? key}) : super(key: key);

  @override
  _TeamsPopUpState createState() => _TeamsPopUpState();
}

class _TeamsPopUpState extends State<TeamsPopUp> {
  // bool status = true;
  // bool credit = true;
  // bool debit = false;
  // bool isDisabled = false;
  // TextEditingController amountController = TextEditingController();
  // TextEditingController categoryNameController = TextEditingController();
  // TextEditingController budgetController = TextEditingController();
  // final FocusNode amountFocus = FocusNode();
  // final FocusNode categoryNameFocus = FocusNode();
  // final FocusNode budgetFocus = FocusNode();
  // String transactionType = "";
  // var editIcon = 'assets/svg/edit_button.svg';
  //
  // final double _sliderValue = 0.0;
  // TextEditingController _sliderTextController = TextEditingController();
  // TextEditingController _secondSliderTextController = TextEditingController();
  //
  // int value = 0;
  // int availableValue = 0;
  // int budgetValue = 0;
  //
  // double minValue = 0.0;
  // double maxValue = 25000.0;
  // double _availableValue = 0;
  // double _budgetValue = 5450.0;
  //
  // String transactionAccountIDDB = "";
  // String transactionAccountType = "";
  // String transactionAccountBalance = "";
  // String transDateDB = "";
  // var transactionAccountName = 'Cash';
  // var transactionTypeDB = 'Debit';
  // var transactionCategoryDB = '';
  // var transCatColor = '';
  // var transCatIcon = '';
  // var inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');



  @override
  Widget build(BuildContext context) {
    return dialogBox1();
  }

  Widget dialogBox1() => AlertDialog(
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
        height: MyUtility(context).height / 4.25,
        width: MyUtility(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Padding(
                padding: const EdgeInsets.all(28.0),
                child: Center(child: Text('Please Accept the teams and condition',style: TextStyle(fontFamily: 'Gilroy Medium',fontSize: 20),)),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Center(
                  child: Container(
                    width: MyUtility(context).width * 0.40,
                    decoration: const BoxDecoration(
                      color:Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                          child: Text(
                            'Okay',
                            style: TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium',color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ),

            ],
          )
        ),
  );

}
