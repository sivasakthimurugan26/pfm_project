import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";
import 'package:personal_finance_management/models/user_model.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/widgets/category_select_widget.dart';
import 'package:personal_finance_management/widgets/limit_amount.dart';
import 'package:personal_finance_management/widgets/slider_thumb_shape.dart';

class SecondPopUpDashboard extends StatefulWidget {
  final List? data;

  const SecondPopUpDashboard({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _SecondPopUpDashboardState createState() => _SecondPopUpDashboardState();
}

class _SecondPopUpDashboardState extends State<SecondPopUpDashboard> {
  TextEditingController availablePercentage = TextEditingController();
  TextEditingController budgetTextController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController availableTextController = TextEditingController();
  TextEditingController sliderController = TextEditingController();
  final FocusNode categoryNameFocus = FocusNode();
  final FocusNode budgetFocus = FocusNode();
  String returnText = 'Test Data';
  var newCategoryLogo;
  var newCategoryBg;
  double availablePercentageTemp = 50.00;
  double budgetSlider = 0.00;
  double minValue = 0.00;
  double maxValue = 25000.00;
  final _formattedAmount = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
  ).format(25000);

  @override
  void initState() {
    super.initState();
    availablePercentage.text = availablePercentageTemp.toString();
    budgetTextController.text = widget.data![0]['budgetedAmount'];
    categoryNameController.text = widget.data![0]['categoryName'];
    availableTextController.text = widget.data![0]['availableAmount'];
    if (widget.data![0]['budgetedAmount'] != '') {
      setState(() {
        budgetSlider = double.parse(widget.data![0]['budgetedAmount'].replaceAll(',', ''));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xffFFE4C8), Colors.white], begin: Alignment.topCenter, end: Alignment.center),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
//close button
                  Container(
                    alignment: FractionalOffset.bottomRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffFEF8F1),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xffFFBE78),
                        size: 20,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
//Circle Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(int.parse(newCategoryBg ?? widget.data![0]['backgroundColor'])),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 40,
                          child: Image.asset(newCategoryLogo ?? widget.data![0]['categoryLogo']),
                        ),
                      ),
                      Positioned(
                        right: -10,
                        bottom: -5,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xff4DC88F),
                            shape: const CircleBorder(),
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/edit_button.svg',
                            color: Colors.white,
                            width: 15,
                          ),
                          onPressed: () async {
                            var returnValue = await showDialog(
                                context: context,
                                barrierColor: Colors.transparent,
                                builder: (_) => CategorySelect(
                                      data: widget.data!,
                                    ));

                            setState(() {
                              newCategoryLogo = returnValue[0];
                              newCategoryBg = returnValue[1];
                            });
                          },
                        ),
                      ),
                    ],
                  ),
//Category Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IntrinsicWidth(
                          // width: 150,
                          child: TextField(
                        controller: categoryNameController,
                        focusNode: categoryNameFocus,
                        style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Gilroy SemiBold'),
                        decoration: InputDecoration(
                          hintText: categoryNameController.text,
                          border: InputBorder.none,
                        ),
                        maxLines: 1,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: InkWell(
                          child: SvgPicture.asset('assets/svg/edit_button.svg'),
                          onTap: () {
                            categoryNameFocus.requestFocus();
                          },
                        ),
                      )
                    ],
                  ),
//Available
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Available',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Gilroy SemiBold',
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Text(
                                        '\u{20B9} ',
                                        style: TextStyle(color: Color(0xff757575), fontSize: 15, fontFamily: 'Gilroy Medium'),
                                      ),
                                      IntrinsicWidth(
                                          child: TextField(
                                        controller: availableTextController,
                                        style: const TextStyle(color: Color(0xff757575), fontSize: 15, fontFamily: 'Gilroy Medium'),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        maxLines: 1,
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    disabledActiveTrackColor: Color(0xff5DCF9A),
                                    disabledInactiveTrackColor: Color(0xffDEFFF0),
                                    thumbShape: SliderComponentShape.noThumb,
                                    overlayShape: SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    min: 0,
                                    max: 100,
                                    value: availablePercentageTemp,
                                    onChanged: null,
                                    activeColor: Color(0xff5DCF9A),
                                    inactiveColor: Color(0xffDEFFF0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 50,
                                decoration: const BoxDecoration(color: Color(0xffDEFFF0), borderRadius: BorderRadius.all(Radius.circular(40))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('${availablePercentage.text} %',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12, fontFamily: 'Gilroy Medium', color: Color(0xff4DC88F))),
                                ),
                              ),
                            ],
                          ),
//Budget
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Budget',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Gilroy SemiBold',
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Text(
                                        '\u{20B9} ',
                                        style: TextStyle(color: Color(0xff757575), fontSize: 15, fontFamily: 'Gilroy Medium'),
                                      ),
                                      IntrinsicWidth(
                                          child: TextField(
                                        controller: budgetTextController,
                                        inputFormatters: [
                                          LimitRange(0, 25000),
                                        ],
                                        focusNode: budgetFocus,
                                        onChanged: (value) {
                                          bool isFirst = true;
                                          String newValue = value.replaceAll(',', '').replaceAll('.', '');
                                          double value1 = double.parse(newValue);
                                          if (!isFirst) value1 = value1 * 100;
                                          value = NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
                                          budgetTextController.value = TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(offset: value.length),
                                          );
                                          setState(() {
                                            budgetSlider = double.tryParse(value.replaceAll(',', '')) ?? 0.00;
                                          });
                                        },
                                        style: const TextStyle(color: Color(0xff757575), fontSize: 15, fontFamily: 'Gilroy Medium'),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        maxLines: 1,
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        child: SvgPicture.asset('assets/svg/edit_button.svg'),
                                        onTap: () {
                                          budgetFocus.requestFocus();
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SliderTheme(
                                data: SliderThemeData(
                                  thumbShape: SliderThumbShape(inColor: 0xffFFBE78),
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: Slider(
                                  activeColor: const Color(0xffFFBE78),
                                  min: minValue,
                                  max: maxValue,
                                  value: budgetSlider,
                                  onChanged: (value) => {
                                    setState(() {
                                      budgetSlider = value.roundToDouble();
                                      double newValue = budgetSlider * 100;
                                      var convertedValue = NumberFormat.currency(customPattern: '###,###.##').format(newValue / 100);
                                      budgetTextController.text = convertedValue;
                                    })
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  const Text(
                                    "0",
                                    style: TextStyle(fontFamily: 'Gilroy Light', fontSize: 15, color: Color(0xff7d7d7d)),
                                  ),
                                  Text(
                                    _formattedAmount,
                                    style: const TextStyle(fontFamily: 'Gilroy Light', fontSize: 15, color: Color(0xff7d7d7d)),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
//SaveButton
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: InkWell(
                      onTap: () {
                        addCustomCategory();
                        Get.back();
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(40))),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                              child: Text(
                            'Save',
                            style: TextStyle(fontSize: 15, fontFamily: 'Gilroy Medium', color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  addCustomCategory() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();

    // myProgressIndicator(context);

    var query = await firebaseFirestore.collection("UserData").doc(user?.uid);

    query.get().then((value) {
      var categoryList = value.data()!['categories'];
      // print(categoryList);

      var editList = [
        {
          'categoryId': widget.data![0]['categoryId'],
          'categoryName': categoryNameController.text,
          'categoryLogo': newCategoryLogo ?? widget.data![0]['categoryLogo'],
          'backgroundColor': newCategoryBg ?? widget.data![0]['backgroundColor'],
          'availableCur': widget.data![0]['availableCur'],
          'availableAmount': availableTextController.text,
          'budgetedCur': widget.data![0]['budgetedCur'],
          'budgetedAmount': budgetTextController.text,
          'spentAmount': widget.data![0]['spentAmount'],
        }
      ];

      // print('EditList: ${editList}');
      for (int i = 0; i < categoryList.length; i++) {
        if (categoryList[i]['categoryId'] == editList[0]['categoryId']) {
          List newList = [];
          newList.add(categoryList[i]);
          print('Data: ${newList}');
          query.update({'categories': FieldValue.arrayRemove(newList)});
          query.update({'categories': FieldValue.arrayUnion(editList)});
        }
      }
    });
    // storeOnboardInfo();
    Get.to(() => HomePage());
  }
}
