import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_finance_management/constants/color.dart';
import 'package:personal_finance_management/constants/my_utility.dart';
import 'package:personal_finance_management/pages/homePage.dart';
import 'package:personal_finance_management/pages/onBoarding/add_account.dart';
import 'package:personal_finance_management/pages/onBoarding/add_account_cash.dart';
import 'package:personal_finance_management/pages/onBoarding/add_custom_category.dart';
import 'package:personal_finance_management/pages/stepper.dart';
import 'package:personal_finance_management/service/AppChecker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMoreOptionsPage extends StatefulWidget {
  final String name;
  const AddMoreOptionsPage({Key? key, required this.name}) : super(key: key);

  @override
  State<AddMoreOptionsPage> createState() => _AddMoreOptionsPageState();
}

class _AddMoreOptionsPageState extends State<AddMoreOptionsPage> {
  double containerPosition = 0.0;
  int activeIndex =4 ;
  String visited ='dashboard';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          body: SafeArea(
            child: SizedBox(
              // height: MyUtility(context).height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30, top: 60),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () async {
                            SharedPreferences isOnboarding =await SharedPreferences.getInstance();
                            if (widget.name == 'Accounts') {
                              Get.to(() => const AddCashAccount());
                            } else if (widget.name == 'Categories') {
                              MySharedPreferences.instance.setBooleanValue("isfirstRun", true);

                              print('skip index:$activeIndex');
                              if(isOnboarding.getBool('isOnboarding') != true){
                                Get.to(() =>  StepperPage(visited,activeIndex));
                              }
                              else{
                                Get.to(() => HomePage());
                              }


                            }
                          },
                          child: const Text(
                            'Skip >>',
                            style: TextStyle(fontSize: 17, fontFamily: 'Gilroy Medium', color: skipColor),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  Column(
                    children: <Widget>[
                      const Text(
                        'Do you have more',
                        style: TextStyle(fontSize: 32, fontFamily: 'Gilroy SemiBold'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${widget.name} ?',
                        style: const TextStyle(fontSize: 32, fontFamily: 'Gilroy SemiBold'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SvgPicture.asset('assets/svg/dec_line.svg', width: MyUtility(context).width * 0.4),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        containerPosition = MediaQuery.of(context).size.width;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(left: containerPosition),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: SvgPicture.asset('assets/svg/onboardArrow.svg'),
                        ),
                      ),
                      onEnd: () {
                        if (widget.name == 'Accounts') {
                          Get.to(() =>  const AddAccountType(fromAccountPage: false,));
                        } else if (widget.name == 'Categories') {
                          Get.to(() => const AddCustomCategoryPage());
                        }
                        setState(() {
                          containerPosition = 0.0;
                        });
                      },
                    ),
                  ),
                  // Container(
                  //   decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       if (widget.name == 'Accounts') {
                  //         Get.to(() =>  const AddAccountType());
                  //       } else if (widget.name == 'Categories') {
                  //         Get.to(() => const AddCustomCategoryPage());
                  //       }
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(25.0),
                  //       child: SvgPicture.asset('assets/svg/onboardArrow.svg'),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          )),
    );
  }
}