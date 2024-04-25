
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/pages/homePage.dart';

class CategorySelect extends StatefulWidget {
  final List data;
  const CategorySelect({Key? key, required this.data}) : super(key: key);

  @override
  _CategorySelectState createState() => _CategorySelectState();
}

List<String> images = [
  // "assets/images/testing.png",
  "assets/images/category/Aeroplain.png",
  // "assets/images/testing2.png",
  "assets/images/category/Auto.png",
  "assets/images/category/Basket Ball.png",
  // "assets/images/testing3.png",
  "assets/images/category/Bills.png",
  "assets/images/category/boxs.png",
  "assets/images/category/Cap.png",
  "assets/images/category/credit.png",
  "assets/images/category/car.png",
  "assets/images/category/cash_bag.png",
  "assets/images/category/cycle.png",
  "assets/images/category/Entertainment.png",
  "assets/images/category/Movie.png",
  "assets/images/category/hands.png",
  "assets/images/category/bugger.png",
  "assets/images/category/Foot Ball.png",
  "assets/images/category/trade.png",
  "assets/images/category/gift_Box.png",
  "assets/images/category/Grocery.png",
  "assets/images/category/hands.png",
  "assets/images/category/health.png",
  "assets/images/category/Laptop.png",
  "assets/images/category/List.png",
  "assets/images/category/Mobile.png",
  "assets/images/category/Money.png",
  "assets/images/category/pop.png",
  "assets/images/category/Object.png",
  "assets/images/category/Medicine.png",
  "assets/images/category/Savings.png",
  "assets/images/category/Petroleum.png",
  "assets/images/category/School_Bus.png",
  "assets/images/category/Scooty.png",
  "assets/images/category/tab.png",
  "assets/images/category/truck.png",
  "assets/images/category/Volley Ball.png",
  "assets/images/category/Wallet.png",
  "assets/images/category/scooty.png",
  // "assets/images/category/Savings_1.png",
  // "assets/images/category/tab_1 2.png",
  // "assets/images/category/Scooty.png",
  // "assets/images/category/Savings_1.png",
  // "assets/images/category/tab_1 2.png",
  // "assets/images/category/Scooty.png",
  // "assets/images/category/Savings_1.png",
];

class _CategorySelectState extends State<CategorySelect> {
  List newData = [];
  var categoryImage = ''.obs;
  var bgColor;
  int selectedIndex = 0;
  bool visibleIcon = true;
  String selectedIcon = '';
  String selectedColor = '';
  final List colors = [
    '0xffF4F4F4',
    '0xffFFE2AB',
    '0xff89DBED',
    '0xffFBA2BF',
    '0xffFFDFCD',
    '0xff52FFCF',
    '0xffC27AD3',
  ];

  int productsPerPage = 9;
  int currentPage = 0;

  double pageCount() {
    return images.length / productsPerPage;
  }

  previousPage() {
    //lets not go bellow 0 :-)
    if (currentPage != 0) {
      setState(() {
        currentPage -= 1;
      });
    }
  }

  nextPage() {
    if ((currentPage + 1) < pageCount()) {
      // print('Current Page, $currentPage');
      setState(() {
        currentPage += 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print('Data: ${widget.data[0]['categoryLogo']}');

    selectedIcon = widget.data[0]['categoryLogo'];
    categoryImage.value = selectedIcon;
    bgColor = widget.data[0]['backgroundColor'];
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
            // color: Colors.white,
              gradient:
              LinearGradient(colors: [Color(0xffFFE4C8), Colors.white], stops: [0.0, 0.5], begin: Alignment.topCenter, end: Alignment.center),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          // height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
//back & close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xffFEF8F1),
                          shape: CircleBorder(),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xffFFBE78),
                            size: 20,
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xffFEF8F1),
                          shape: CircleBorder(),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xffFFBE78),
                          size: 20,
                        ),
                        onPressed: () {
                          Get.to(() => HomePage());
                        },
                      ),
                    ],
                  ),
//Circle Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(int.parse(bgColor)),
                        child: CircleAvatar(backgroundColor: Colors.transparent,
                            radius: 30, child: Obx(() => Image.asset(categoryImage.toString(),))
                          // Image.asset('assets/images/food.png'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

//Grid/ next & previous
                  Container(
                    height: 250,
                    child: Center(
                      child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 75, childAspectRatio: 2 / 1.75,
                              crossAxisSpacing: 10, mainAxisSpacing: 20),
                          itemCount: productsPerPage,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                              // alignment: Alignment.center,
                              // child: Text(myProducts[index + (currentPage * productsPerPage)].name),
                              child: GestureDetector(
                                  onTap: () {
                                    categoryImage.value = images[index + (currentPage * productsPerPage)];
                                    selectedIcon = categoryImage.toString();
                                    // print('selectedIcon: $selectedIcon');
                                    // print('currentPage: ${currentPage+productsPerPage}');
                                    // print('Index: ${index + (currentPage * productsPerPage)}');
                                  },
                                  child: Image.asset(images[index + (currentPage * productsPerPage)])),
                              // decoration: BoxDecoration(
                              //     color: Color.fromARGB(rng.nextInt(255), rng.nextInt(255), rng.nextInt(255), 47), borderRadius: BorderRadius.circular(15)),
                            );
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                    TextButton(
                      child: Text("Previous"),
                      // child: Container(
                      //     decoration: const BoxDecoration(color: dateSelect, borderRadius: BorderRadius.all(Radius.circular(40))),
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                      //       child: Text('${currentPage + 1}/${(pageCount().round())}', style: const TextStyle(fontSize: 13, fontFamily: 'Gilroy Bold'),),
                      //     )),
                      onPressed: (currentPage - 1) >= 0 ? previousPage : null,
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      child: Text("Next"),
                      onPressed: ((currentPage + 1) * productsPerPage) <= images.length ? nextPage : null,
                    )
                  ]),

//color picker
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    height: 40.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                bgColor = colors[index];
                                selectedIndex = index;
                                selectedColor = bgColor.toString();
                                print('selectedColor: $bgColor');
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(int.parse(colors[index])), // inner circle color
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: selectedIndex == index
                                      ? SvgPicture.asset(
                                    'assets/svg/categoryTick.svg',
                                    color: Colors.black,
                                  )
                                      : null,
                                ),
                                width: 35.0,
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: InkWell(
                      onTap: () {
                        if (selectedIcon.isNotEmpty) {
                          print('Icon Changed');
                        } else {
                          print('Icon Not Changed');
                        }
                        List dat = [];
                        dat.add(selectedIcon);
                        dat.add(bgColor);
                        print('selectedIcon: $dat');
                        Navigator.pop(context, dat);
                        // Get.to(SecondPopUpDashboard(data: [],), arguments: ["First data", "Second data"]);
                        // showDialog(context: context, barrierColor: Colors.transparent, builder: (_) => CategorySelect());
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
                    height: 30,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}