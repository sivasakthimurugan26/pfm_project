import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/widgets/edit_popup/second_popup_dashboard.dart';

import '../pages/onBoarding/add_custom_category.dart';

listCardViewStart(context, categoriesList) {
  Color color;
  if (categoriesList['type'] == 'Credit') {
    color = searchIcon;
  } else if (categoriesList['type'] == 'Debit') {
    color = rupeeDebit;
  } else {
    color = const Color(0xff8A8A8A);
  }

  return GestureDetector(
    onTap: () {
      Get.to(() => const AddCustomCategoryPage(), arguments: categoriesList);
    },
    // onTap: () {
    //   PopUpBox();
    //   // Get.to(() =>PopUpBox());
    // },
    onLongPress: () {
      showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black38,
        transitionDuration: Duration(milliseconds: 500),
        // pageBuilder: (ctx, anim1, anim2) => PopUpBox(),
        // pageBuilder: (ctx, anim1, anim2) => SecondPopUpDashboard(budget: categoriesList['budgetedAmount'], available: categoriesList['availableAmount'], icon: categoriesList['categoryLogo'], categoryName: categoriesList['categoryName'], backgroundColor: categoriesList['backgroundColor'],),
        pageBuilder: (ctx, anim1, anim2) => SecondPopUpDashboard(data: [categoriesList],),
        transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
          child: FadeTransition(
            child: child,
            opacity: anim1,
          ),
        ),
        context: context,
      );
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
// color: Color(0xff8A8A8A),
                      color: Color(int.parse(categoriesList['backgroundColor'])),
                      // color: Color(categoriesList['backgroundColor']),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      categoriesList['categoryLogo'],
                      width: 70,
                      // fit: BoxFit.contain,
                    )),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.17,
                  // left: 70,
                  // bottom:10,
                  bottom: MediaQuery.of(context).size.height * 0.002,
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
                        // calculatePercentage(categoriesList['spendAmount']),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                            child: Text(
                              '\u{20B9} ${categoriesList['budgetedAmount']}',
                              style: const TextStyle(color: homeCatText, fontFamily: "Gilroy Medium", fontSize: 16),
                            ))
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
                    '\u{20B9} ${categoriesList['availableAmount']}',
                    style: TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 20, color: color),
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

calculatePercentage(String spend) {
  Color bgColor = const Color(0xffffffff);
  Color fontColor = const Color(0xffffffff);
  // double availablePercentage = (double.parse(spend.replaceAll(',', '')) / double.parse(`bud`geted.replaceAll(',', ''))) * 100;
  // print('availablePercentage: $availablePercentage');
  double spendAmount = double.parse(spend.replaceAll(',', ''));
  if (spendAmount >= 75.00) {
    bgColor = percentBgGreen;
    fontColor = percentFontGreen;
  } else if (spendAmount <= 75.00 && spendAmount >= 40.00) {
    bgColor = percentBgYellow;
    fontColor = percentFontYellow;
  } else if (spendAmount < 40.00) {
    bgColor = percentBgRed;
    fontColor = percentFontRed;
  }

  return Container(
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
        child: Text(
          '${spendAmount.toInt().toString()}%',
          style: TextStyle(color: fontColor, fontFamily: "Gilroy Medium", fontSize: 15),
        )),
  );
}
