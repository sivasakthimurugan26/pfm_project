import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/color.dart';

import '../pages/onBoarding/add_custom_category.dart';

listCardViewStop(context, categoriesList, toggleValue) {
  return GestureDetector(
    onTap: () {
      Get.to(() => const AddCustomCategoryPage(), arguments: categoriesList);
    },

    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            offset: const Offset(1, 3),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.10),
          ),
        ], color: Colors.white, borderRadius: const BorderRadius.all(Radius.circular(60))),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: [
                Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(int.parse(categoriesList['backgroundColor'])),
                      // color: Color(categoriesList['backgroundColor']),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      categoriesList['categoryLogo'],
                      width: 70,
                    )),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.17,
                  // left: 70,
                  // bottom:10,
                  bottom: MediaQuery.of(context).size.height * 0.007,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoriesList['categoryName'],
                          style: const TextStyle(fontFamily: "Gilroy Medium", fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        calculatePercentage(
                            categoriesList['availableAmount'], categoriesList['budgetedAmount'], categoriesList['spentAmount'], toggleValue),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width * 0.025,
                  // right: 10,
                  // bottom: 21,
                  bottom: MediaQuery.of(context).size.height * 0.025,
                  child: toggleValue == 0
                      ? Text(
                    '\u{20B9} ${categoriesList['availableAmount']}',
                    style: const TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 20, color: Color(0xff8A8A8A)),
                  )
                      : Text(
                    '\u{20B9} ${categoriesList['spentAmount']}',
                    style: const TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 20, color: Color(0xff8A8A8A)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

calculatePercentage(String available, String budgeted, String spent, int toggleValue) {
  // Color bgColor = Colors.greenAccent;
  Color bgColor = const Color(0xffffffff);
  Color fontColor = const Color(0xffffffff);
  double avBal = double.parse(available.replaceAll(',', ''));
  double budBal = double.parse(budgeted.replaceAll(',', ''));
  double spBal = double.parse(spent.replaceAll(',', ''));
  //double availablePercentage = (avBal / budBal) * 100;
  //double spendAmount = budBal -spBal;
  //double spendAmount = spBal;
  double spendPercentage = (spBal/budBal)* 100;
  //print('spendPercentage: $spendPercentage');
  double availablePercentage =100- spendPercentage;
   //print('availablePercentage: $availablePercentage');

  if (toggleValue == 0) {
    if (availablePercentage >= 75.00) {
      bgColor = percentBgGreen;
      fontColor = percentFontGreen;
    } else if (availablePercentage < 75.00 && availablePercentage >= 40.00) {
      bgColor = percentBgYellow;
      fontColor = percentFontYellow;
    } else if (availablePercentage < 40.00) {
      bgColor = percentBgRed;
      fontColor = percentFontRed;
    }
  } else if (toggleValue == 1) {
    if (spendPercentage <= 40.00) {
      bgColor = percentBgGreen;
      fontColor = percentFontGreen;
    } else if (spendPercentage < 40.00 && spendPercentage >= 75.00) {
      bgColor = percentBgYellow;
      fontColor = percentFontYellow;
     // print('bgColor:$bgColor');
     // print('fontColor:$fontColor');
    } else if (spendPercentage > 75.00) {
      bgColor = percentBgRed;
      fontColor = percentFontRed;
    }
  }

  return Container(
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
        child: toggleValue == 0
            ? Text(availablePercentage.toInt() >=100?'100%':
        '${availablePercentage.toInt().toString()}%',
          style: TextStyle(color: fontColor, fontFamily: "Gilroy Medium", fontSize: 15),
        )
            : Text(
          '${spendPercentage.toInt().toString()}%',
          style: TextStyle(color: fontColor, fontFamily: "Gilroy Medium", fontSize: 15),
        )),
  );
}
