import 'package:flutter/material.dart';

class EmptyMessageWidget extends StatelessWidget {
  bool isAllTransaction;
  String text;
  EmptyMessageWidget({Key? key, required this.isAllTransaction, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      // decoration: const BoxDecoration(
      //   gradient: LinearGradient(colors: [Color(0xffF5E5E5), introScreenGradient2], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      // ),
      child: isAllTransaction
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/emptyTransactionIcon.png'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.020,
                ),
                Text(
                  'No $text',
                  style: const TextStyle(fontSize: 25, fontFamily: 'Gilroy SemiBold', color: Color(0xff574B3D)),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/emptyTransactionIcon.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.030,
                ),
                Text(
                  'No $text',
                  style: const TextStyle(fontSize: 25, fontFamily: 'Gilroy SemiBold', color: Color(0xff574B3D)),
                ),
              ],
            ),
    );
  }
}
