import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/svg_constant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'add_custom_category_desc.dart';

class AddCustomCategoryIconPage extends StatefulWidget {
  const AddCustomCategoryIconPage({Key? key}) : super(key: key);

  @override
  _AddCustomCategoryIconPageState createState() => _AddCustomCategoryIconPageState();
}

class _AddCustomCategoryIconPageState extends State<AddCustomCategoryIconPage> {
  final FocusNode categoryFocus = FocusNode();
  TextEditingController categoryNameTextController = TextEditingController();

  var data = Get.arguments;

  PageController controller = PageController(
    initialPage: 0,
  );
  final List<int> colors = [
    0xffF4F4F4,
    0xffFFE2AB,
    0xff89DBED,
    0xffFBA2BF,
    0xffFFDFCD,
    0xff52FFCF,
    0xffC27AD3,
  ];

  String selectedColor = '';

  int bgColor = 0;
  bool selectedIcon = false;
  int colorSelected = 0;
  int selectedIndex = 0;

  String categoryName = '';
  String categoryBgColor = '';
  String categoryIcon = '';

  String selectedIcons = '';

  List<String> categoryListOne = [
    "assets/images/category/achive.png",
    "assets/images/category/Aeroplain.png",
    "assets/images/category/Auto.png",
    "assets/images/category/Basket Ball.png",
    "assets/images/category/Bills.png",
    "assets/images/category/books.png",
    "assets/images/category/boxs.png",
    "assets/images/category/bugger.png",
    "assets/images/category/Cap.png",
  ];

  var categoryIndex = [];
  int selectedCard = 0;
  int selectedCardOne = -1;
  int selectedCardTwo = -1;
  int selectedCardThree = -1;
  int newBgColor = 0;
  String categoryIcons = '';

  List<String> categoryListTwo = [
    "assets/images/category/car.png",
    "assets/images/category/cash_bag.png",
    "assets/images/category/credit.png",
    "assets/images/category/cycle.png",
    "assets/images/category/Entertainment.png",
    "assets/images/category/Foot Ball.png",
    "assets/images/category/gift_Box.png",
    "assets/images/category/Grocery.png",
    "assets/images/category/hands.png",
  ];

  List<String> categoryListThree = [
    "assets/images/category/health.png",
    "assets/images/category/Laptop.png",
    "assets/images/category/List.png",
    "assets/images/category/Medicine.png",
    "assets/images/category/Mobile.png",
    "assets/images/category/Money.png",
    "assets/images/category/Movie.png",
    "assets/images/category/Object.png",
    "assets/images/category/Petroleum.png",
  ];

  List<String> categoryListFour = [
    "assets/images/category/pop.png",
    "assets/images/category/SavingHand.png",
    "assets/images/category/Savings.png",
    "assets/images/category/School_Bus.png",
    "assets/images/category/Scooty.png",
    "assets/images/category/tab.png",
    "assets/images/category/trade.png",
    "assets/images/category/Travelling_Bag.png",
    "assets/images/category/truck.png",
  ];
  var categoryIndex_1 = [];
  var categoryImage = ''.obs;

  @override
  void initState() {
    super.initState();
    print('Data: ${data}');
    if (data[1] != null) {
      if (data[1]['backgroundColor'] != null) {
        bgColor = int.parse(data[1]['backgroundColor']);
        categoryIcon = data[1]['categoryLogo'];
      }
    } else {
      bgColor = colors[0];
    }
    storageContainer.write('catBg', bgColor);
    storageContainer.write('catIcon', categoryListOne[0]);

    // else{
    //   bgColor = colors[0];
    // }
  }

  @override
  void dispose() {
    categoryNameTextController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    categoryName = data[0];
    print('DataPrevious: ${data[0]}');
    if (categoryBgColor == null) {}

    // print('OP: $bgColor');

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // height: height,
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
                      Text(
                        categoryName,
                        style: const TextStyle(fontSize: 30, fontFamily: 'Gilroy Medium'),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const Text(
                        'Let\'s add color to your category',
                        style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Light'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  SizedBox(
                    height: height * 0.4,
                    child: Stack(
                      children: [
                        PageView(
                          controller: controller,
                          onPageChanged: (value) {
                            value = -1;
                            selectedCard = value;
                            selectedCardOne = value;
                            selectedCardTwo = value;
                            selectedCardThree = value;
                          },
                          children: [
                            gridViewOne(),
                            gridViewTwo(),
                            gridViewThree(),
                            gridViewFour(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: 4,
                            effect: const SlideEffect(dotWidth: 10, dotHeight: 10, dotColor: Color(0xffeeeeee), activeDotColor: Color(0xffFFBE78)),
                            onDotClicked: (index) =>
                                controller.animateTo(index.toDouble(), duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30),
                    height: 40.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (BuildContext context, int index) {
                          // if (bgColor == colors[index]) {
                          //   print('index: $bgColor');
                          //   selectedIndex = index;
                          // }
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                bgColor = colors[index];
                                selectedIndex = index;
                                colorSelected = bgColor;
                                print('bgColor: $bgColor');
                              });
                              storageContainer.write('catBg', bgColor);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(colors[index]), // inner circle color
                                ),
                                width: 35.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: selectedIndex == index
                                      ? SvgPicture.asset(
                                          'assets/svg/categoryTick.svg',
                                          color: Colors.black,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: height * 0.07,
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
                          // addCustomCategory();
                          print('currentBGColor: ${bgColor.toString()}');
                          Get.to(() => const AddCustomCategoryDesc(), arguments: (data));
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
  }

  GridView gridViewOne() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: categoryListOne.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 75,
        crossAxisSpacing: 40,
        mainAxisSpacing: 30,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCard = index;
              newBgColor = bgColor;
              categoryIcon = categoryListOne[index];
            });
            if (categoryIcon == '') {
              storageContainer.write('catIcon', categoryIcon);
              storageContainer.write('catBg', bgColor);
              print('widget.selectedIcon:$categoryIcon');
            } else {
              storageContainer.write('catIcon', categoryIcon);
              // storageContainer.write('catBg', bgColor);
              print('categoryIcon: $categoryIcon, newBgColor: $newBgColor');
            }
          },
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: selectedCard == index ? Color(bgColor) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(categoryListOne[index]),
          ),
        );
      },
    );
  }

  GridView gridViewTwo() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: categoryListTwo.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 75,
        crossAxisSpacing: 40,
        mainAxisSpacing: 30,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCardOne = index;
              newBgColor = bgColor;
              categoryIcon = categoryListTwo[index];
            });
            if (categoryIcon == '') {
              storageContainer.write('catIcon', categoryIcon);
              storageContainer.write('catBg', bgColor);
              print('widget.selectedIcon:$categoryIcon');
            } else {
              storageContainer.write('catIcon', categoryIcon);
              storageContainer.write('catBg', bgColor);
              print('categoryIcon: $categoryIcon, newBgColor: $newBgColor');
              print('categoryIcon: $index');
            }
          },
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: selectedCardOne == index ? Color(bgColor) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(categoryListTwo[index]),
          ),
        );
      },
    );
  }

  GridView gridViewThree() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: categoryListThree.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 75,
        crossAxisSpacing: 40,
        mainAxisSpacing: 30,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCardTwo = index;
              newBgColor = bgColor;
              categoryIcon = categoryListThree[index];
            });
            if (categoryIcon == '') {
              storageContainer.write('catIcon', categoryIcon);
              storageContainer.write('catBg', bgColor);
              print('widget.selectedIcon:$categoryIcon');
            } else {
              storageContainer.write('catIcon', categoryIcon);
              storageContainer.write('catBg', bgColor);
              print('categoryIcon: $categoryIcon, newBgColor: $newBgColor');
            }
          },
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: selectedCardTwo == index ? Color(bgColor) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(categoryListThree[index]),
          ),
        );
      },
    );
  }

  GridView gridViewFour() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: categoryListFour.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 75,
        crossAxisSpacing: 40,
        mainAxisSpacing: 30,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCardThree = index;
              newBgColor = bgColor;
              categoryIcon = categoryListFour[index];
            });
            if (categoryIcon == '') {
              storageContainer.write('catIcon', categoryIcon);
              storageContainer.write('catBg', bgColor);
              print('widget.selectedIcon:$categoryIcon');
            } else {
              storageContainer.write('catIcon', categoryIcon);
              storageContainer.write('catBg', bgColor);
              print('categoryIcon: $categoryIcon, newBgColor: $newBgColor');
            }
          },
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: selectedCardThree == index ? Color(bgColor) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(categoryListFour[index]),
          ),
        );
      },
    );
  }
}
