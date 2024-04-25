import 'package:flutter/material.dart';

class CardPageAppBar extends StatelessWidget {
  const CardPageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient:
        LinearGradient(colors: [Color(0xffE2FAFF), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            ListTile(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              title: Center(
                  child: Text(
                    'All Transaction',
                    style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 22, color: Colors.black),
                  )),
              trailing: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffFF6349),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child:
                    Text('4 Untagged', style: TextStyle(fontFamily: 'Gilroy Medium', fontSize: 12, color: Color(0xffFFE3DE))),
                  )),
            ),
// Dropdown
//                             SizedBox(
//                               height: 50,
//                               child: ListView(
//                                 scrollDirection: Axis.horizontal,
//                                 shrinkWrap: true,
//                                 children: [
//                                   Container(
//                                     width: 150,
//                                     height: 40,
//                                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
//                                     child: CustDropDown(
//                                       items: const [
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           child: Text('Account 1'),
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 1'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                         ),
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           child: Text('Account 2'),
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 2'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                         ),
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 3'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                           child: Text('Account 3'),
//                                         )
//                                       ],
//                                       hintText: "Category",
//                                       borderRadius: 40,
//                                       onChanged: (val) {
//                                         // print(val);
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Container(
//                                     width: 100,
//                                     height: 40,
//                                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
//                                     child: CustDropDown(
//                                       items: [
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           child: Text('Account 1'),
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 1'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                         ),
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           child: Text('Account 2'),
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 2'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                         ),
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 3'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                           child: Text('Account 3'),
//                                         )
//                                       ],
//                                       hintText: "Sort",
//                                       borderRadius: 40,
//                                       onChanged: (val) {
//                                         // print(val);
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Container(
//                                     width: 150,
//                                     height: 40,
//                                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
//                                     child: CustDropDown(
//                                       items: [
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           child: Text('Account 1'),
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 1'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                         ),
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           child: Text('Account 2'),
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 2'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                         ),
//                                         CustDropdownMenuItem(
//                                           value: 0,
//                                           // child: Row(
//                                           //   children: [
//                                           //     Text('Account 3'),
//                                           //     Checkbox(
//                                           //       value: isChecked,
//                                           //       onChanged: (value) {
//                                           //         setState(() {
//                                           //           isChecked = value!;
//                                           //         });
//                                           //       },
//                                           //     ),
//                                           //   ],
//                                           // ),
//                                           child: Text('Account 3'),
//                                         )
//                                       ],
//                                       hintText: "Credit/Debit",
//                                       borderRadius: 40,
//                                       onChanged: (val) {
//                                         // print(val);
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
          ],
        ),
      ),
    );
  }
}
