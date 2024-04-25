import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

import 'add_category_desc.dart';

class AddBudgetCategory extends StatefulWidget {
  const AddBudgetCategory({Key? key}) : super(key: key);

  @override
  _AddBudgetCategoryState createState() => _AddBudgetCategoryState();
}

var categoryList = [
  {
    "name": "Games",
    "image": "assets/images/category/gift_Box.png",
    "color": "0xffFFE2AB",
    "budget": "0",
  },
  {
    "name": "Grocery",
    "image": "assets/images/category/Grocery.png",
    "color": "0xffFFDFCD",
    "budget": "0",
  },
  {
    "name": "Education",
    "image": "assets/images/category/books.png",
    "color": "0xffFFA2C0",
    "budget": "0",
  },
  {
    "name": "Medicine",
    "image": "assets/images/category/health.png",
    "color": "0xffFFE2AB",
    "budget": "0",
  },
  {
    "name": "Travelling",
    "image": "assets/images/category/trade.png",
    "color": "0xffABC3FF",
    "budget": "0",
  },
  {
    "name": "Saving",
    "image": "assets/images/category/Savings.png",
    "color": "0xffCAB0FF",
    "budget": "0",
  },
];

var categoryIndex = [];
var selectedCategoryList = [];
var categoryLength = 0;
HashSet selectItems = HashSet();

class _AddBudgetCategoryState extends State<AddBudgetCategory> {
  String availableAmount = '';
  final FocusNode budgetFocus = FocusNode();
  TextEditingController budgetAmountTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectItems = HashSet<int>();
  }

  void resetSelectItems() {
    setState(() {
      selectItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                          ),
                          const Text(
                            'Let\'s Budget',
                            style: TextStyle(fontSize: 30, fontFamily: 'Gilroy Medium'),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          const Text(
                            'Choose common expense categories ',
                            style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Light'),
                          ),
                        ],
                      ),
                      GridView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoryList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          // crossAxisSpacing: 10,
                          mainAxisSpacing: 30,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              doMultiSelection(index);
                            },
                            child: categoryGridSelect(
                              categoryList[index]['name'].toString(),
                              categoryList[index]['image'].toString(),
                              categoryList[index]['color'].toString(),
                              index,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: height * 0.20,
                      ),
                    ],
                  ),
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
                          // print('categoryIndex: ${categoryIndex}');
                          if (categoryIndex.isEmpty) {
                            // print('Select one Category');
                            snackBarWidget("Help us here", "Please select atleast one Category.");
                          } else {
                            Get.to(() => AddCategoryDesc(resetSelectItemsCallback: resetSelectItems), arguments: categoryIndex);
                            // print('empty:${categoryIndex.length}');
                            categoryLength = categoryIndex.length;
                            categoryIndex = [];
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
                  SizedBox(
                    height: height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    //   ),
    // );
  }

  doMultiSelection(int index) {
    // print('index:${selectItems.contains(index)}');
    // print('index:${categoryIndex}');
    // print('index:${categoryList[index]}');
    setState(() {
      if (selectItems.contains(index)) {
        selectItems.remove(index);
        categoryIndex.remove(categoryList[index]);
      } else {
        selectItems.add(index);
        categoryIndex.add(categoryList[index]);
      }
    });
    return selectItems;
    // print('Seleted: ${selectItems}');
  }

  categoryGridSelect(String name, String image, String color, int index) {
    // print('selectItems:${categoryIndex}');
    // var data = categoryList.where((element) => print('Element: $element'););
    // print('selectItems:${MyUtility(context).width * 0.235}');
    // print('select: ${selectItems}');
    return GridView.count(
      crossAxisCount: 1,
      children: [
        Column(
          children: [
            Stack(children: [
              Container(
                height: MyUtility(context).height * 0.09,
                width: MyUtility(context).width * 0.235,
                decoration: BoxDecoration(
                  color: Color(int.parse(color)),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(image),
              ),
              Visibility(
                  visible: selectItems.contains(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(int.parse(color)).withOpacity(0.65),
                      shape: BoxShape.circle,
                    ),
                    height: MyUtility(context).height * 0.09,
                    width: MyUtility(context).width * 0.235,
                    child: Center(child: SvgPicture.asset('assets/svg/categoryTick.svg')),
                  ))
            ]),
            SizedBox(
              height: MyUtility(context).height * 0.0035,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontFamily: 'Gilroy Medium'),
            )
          ],
        ),
      ],
    );
  }
}
