import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackBarWidget(String heading, String subtitle){
  Get.snackbar(
    heading,
    subtitle,
    icon: const Icon(Icons.warning_rounded, color: Color(0xffFEF3DD)),
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color(0xffFFB62D),
    borderRadius: 20,
    margin: const EdgeInsets.all(15),
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}