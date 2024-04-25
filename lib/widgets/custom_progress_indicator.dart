import 'package:flutter/material.dart';

void myProgressIndicator(BuildContext context) {
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
    contentPadding: const EdgeInsets.only(top: 10.0),
    content: SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 5), child: const Text("Loading")),
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
