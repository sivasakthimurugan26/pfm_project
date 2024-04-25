
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:personal_finance_management/widgets/reminder/expanded.dart';


import 'monthpage.dart';
import 'mylistview.dart';
import 'weekpage.dart';

class DropDown extends StatefulWidget {
  final String? title;
  const DropDown({Key? key, this.title}) : super(key: key);
  @override
  _DropDownState createState() => _DropDownState();
}


List weekDays = [

  'Week',
'All',
  'Month',
];


class _DropDownState extends State<DropDown> {
  bool isStrechedDropDown = false;
  // bool Allvisible=true;
  // bool Weekvisible=false;
  // bool Monthvisible=false;
  String? title;
  @override
  Widget build(BuildContext context) {
    return
      Container(
        height: 150,
        width: MediaQuery.of(context).size.width * 0.40,
        padding: const EdgeInsets.only(left: 15, top: 12, right: 15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffFFF0D3)),
                        borderRadius: const BorderRadius.all(Radius.circular(27)),
                      ),
                      child:
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(right: 5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ), // border: Border.all(width: 1.5, color: Color(0xffFFF0D3))
                            constraints: const BoxConstraints(
                              minHeight: 45,
                              minWidth: double.infinity,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15, right: 10),
                                          child: Image.asset('assets/images/calender.png', width: 18, height: 18, color: const Color(0xffFF9E36)),
                                        ),
                                        Text(
                                          widget.title!,
                                          style: const TextStyle(fontSize: 16, color: Color(0xff000000)),
                                        ),
                                      ],
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isStrechedDropDown = !isStrechedDropDown;
                                    });

                                  },
                                  child: Icon(
                                    isStrechedDropDown ? Icons.expand_less : Icons.expand_more,
                                    color: const Color(0xff444444),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            constraints: const BoxConstraints(minWidth: double.infinity, maxHeight: double.infinity),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: weekDays.length,
                              itemBuilder: (context, index) {
                                return ExpandedSection(
                                  expand: isStrechedDropDown,
                                  height: 100,
                                  child: GestureDetector(

                                    onTap: () {
                                      setState(() {
                                        print('title:${title}');

                                        title = weekDays.elementAt(index);
                                        isStrechedDropDown = false;

                                        // MyListView(title: 'All',);
                                        // WeekPage(title: 'Week');
                                        // MonthPage(title: 'Month',);
                                        if(weekDays.elementAt(index)=='All'){
                                          // Allvisible=true;
                                          // MyListView(title: 'All');
                                          Get.to(()=>MyListView(title: 'All'));


                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyListView(title:'All')));
                                        }
                                        if (weekDays.elementAt(index) == 'Week') {
                                          Get.to(()=>WeekPage(title: 'Week',));
                                          // Allvisible=false;
                                          // Navigator.push(context, MaterialPageRoute
                                          //
                                          //   (builder: (context) => const
                                          // WeekPage(title: 'Week',),
                                          // ));
                                        } else if(weekDays.elementAt(index) == 'Month') {
                                          Get.to(()=>MonthPage(title: 'Month',));

                                          // Navigator.push(context,
                                          // MaterialPageRoute(builder: (context) => const MonthPage(title: 'Month',)));
                                        }
                                        else{
                                          print('This page is empty');
                                        }
                                      });
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 10),
                                            child: Image.asset('assets/images/calender.png', width: 18, height: 18, color: Color(0xffFF9E36)),
                                          ),
                                          Text(
                                            weekDays.elementAt(index),
                                            style: TextStyle(fontSize: 16, color: Color(0xffA6A6A6)),
                                          ),
                                        ],
                                      ),
                                    ),



                                  ),
                                );
                              },
                            ),
                          ),
                          // Visibility(
                          //     visible: Allvisible,
                          //     child:Allvisible?MyListView(title: 'All'):Weekvisible?WeekPage(title: 'Week'):Monthvisible?
                          //     MonthPage(title: 'Month',):Text('error')
                          // )
                        ],
                      ),
                    )),

              ],
            )
          ],
        ),
      );
  }
}