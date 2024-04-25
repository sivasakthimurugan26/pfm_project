import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/widgets/snack_bar_widget.dart';

import 'add_custom_category_icon_page.dart';

class AddCustomCategoryPage extends StatefulWidget {
  const AddCustomCategoryPage({Key? key}) : super(key: key);

  @override
  _AddCustomCategoryPageState createState() => _AddCustomCategoryPageState();
}

class _AddCustomCategoryPageState extends State<AddCustomCategoryPage> {
  final FocusNode categoryFocus = FocusNode();
  TextEditingController categoryNameTextController = TextEditingController();

  var categoryData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print('CategoryData: $categoryData');

    if (categoryData != null) {
      // print(categoryData['categoryName']);
      categoryNameTextController.text = categoryData['categoryName'].toString();
    }

    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            // FocusScope.of(context).unfocus();
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: height,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.05,
                          ),
                          const Text(
                            'What\'s the Category',
                            style: TextStyle(fontSize: 30, fontFamily: 'Gilroy Medium'),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          const Text(
                            'Choose the category name',
                            style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Light'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IntrinsicWidth(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: categoryNameTextController,
                              focusNode: categoryFocus,
                              style: const TextStyle(fontSize: 45, fontFamily: 'Gilroy SemiBold'),
                              decoration: const InputDecoration(
                                hintText: "Category ",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black)
                              ),
                              maxLines: 1,
                            ),
                          ),
                          InkWell(
                            child: SvgPicture.asset('assets/svg/edit_button.svg'),
                            onTap: () {
                              categoryFocus.requestFocus();
                            },
                          ),
                        ],
                      ),

                      // Text('0.00', style: TextStyle(fontFamily: 'Gilroy SemiBold', fontSize: 45),),
                      SizedBox(
                        height: height * 0.20,
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
                              if (categoryNameTextController.text.isEmpty) {
                                snackBarWidget("Help us here", "Please update the budget amount.");
                                categoryFocus.requestFocus();
                              } else {
                                // Get.to(() => const AddAccountName(), arguments: ['0xffDDF9FF','Savings',budgetAmountTextController.text]);
                                Get.to(() => const AddCustomCategoryIconPage(), arguments: [categoryNameTextController.text, categoryData]);
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
        ),
        onWillPop: () async => false);
  }
}
