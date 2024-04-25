import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LimitRange extends TextInputFormatter {
  LimitRange(
      this.minRange,
      this.maxRange,
      ) : assert(
  minRange < maxRange,
  );

  final double minRange;
  final double maxRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = double.tryParse(newValue.text)??0;
    if (value < minRange) {
      print('value print in between 1 - 20');
      return TextEditingValue(text: minRange.toString());
    } else if (value > maxRange) {
      print('not more 20');
      Get.snackbar(
        "Your Budget is exceeding",
        "Please enter the less amount",
        icon: Icon(Icons.warning_rounded, color: Color(0xffFEF3DD)),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xffFFB62D),
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return TextEditingValue(text: maxRange.toString());
    }
    return newValue;
  }
}